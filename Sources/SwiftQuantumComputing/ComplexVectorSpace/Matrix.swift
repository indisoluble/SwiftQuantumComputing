//
//  Matrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/07/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if os(Linux)

import CBLAS_Linux

#else

import Accelerate

#endif

import Foundation

// MARK: - Main body

/// Swift representation of a complex 2-dimensional matrix
public struct Matrix {

    // MARK: - Public properties

    /// Number of rows in the matrix
    public let rowCount: Int

    /// Number of columns per row in the matrix
    public let columnCount: Int

    /// Returns first element in first row
    public var first: Complex {
        return values.first!
    }

    /// Use [row, column] to access elements in the matrix
    public subscript(row: Int, column: Int) -> Complex {
        return values[(column * rowCount) + row]
    }

    // MARK: - Internal properties

    var isSquare: Bool {
        return (rowCount == columnCount)
    }

    // MARK: - Private properties

    private let values: [Complex]

    // MARK: - Public init methods

    /// Errors throwed by `Matrix()`
    public enum InitError: Error {
        /// Throwed when no `Complex` element is provided to initialize a new matrix
        case doNotPassAnEmptyArray
        /// Throwed if any sub-list/row does not have the same length that the others
        case subArraysHaveToHaveSameSize
        /// Throwed if any sub-list/row is empty
        case subArraysMustNotBeEmpty
    }

    /**
     Initializes a new `Matrix` instance with `elememts`

     - Parameter elements: List of sub-list where each sub-list is a row in the matrix.

     - Throws: `Matrix.InitError`.

     - Returns: A new `Matrix` instance.
     */
    public init(_ elements: [[Complex]]) throws {
        guard let firstRow = elements.first else {
            throw InitError.doNotPassAnEmptyArray
        }

        let columnCount = firstRow.count
        guard (columnCount > 0) else {
            throw InitError.subArraysMustNotBeEmpty
        }

        let sameCountOnEachRow = elements.allSatisfy { $0.count == columnCount }
        guard sameCountOnEachRow else {
            throw InitError.subArraysHaveToHaveSameSize
        }

        let rowCount = elements.count
        let values = Matrix.serializedRowsByColumn(elements,
                                                   rowCount: rowCount,
                                                   columnCount: columnCount)

        self.init(rowCount: rowCount, columnCount: columnCount, values: values)
    }

    // MARK: - Private init methods

    private init(rowCount: Int, columnCount: Int, values: [Complex]) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.values = values
    }

    // MARK: - Internal methods

    func isUnitary(accuracy: Double) -> Bool {
        let identity = try! Matrix.makeIdentity(count: rowCount)

        var matrix = Matrix.multiply(lhs: self, rhs: self, rhsTrans: CblasConjTrans)
        guard matrix.isEqual(identity, accuracy: accuracy) else {
            return false
        }

        matrix = Matrix.multiply(lhs: self, lhsTrans: CblasConjTrans, rhs: self)
        return matrix.isEqual(identity, accuracy: accuracy)
    }

    // MARK: - Internal class methods

    enum MakeMatrixError: Error {
        case passRowCountBiggerThanZero
        case passColumnCountBiggerThanZero
    }

    static func makeMatrix(rowCount: Int,
                           columnCount: Int,
                           value: (Int, Int) -> Complex) throws -> Matrix {
        guard (rowCount > 0) else {
            throw MakeMatrixError.passRowCountBiggerThanZero
        }

        guard (columnCount > 0) else {
            throw MakeMatrixError.passColumnCountBiggerThanZero
        }

        let count = (rowCount * columnCount)
        let values = (0..<count).map { value($0 % rowCount, $0 / rowCount)  }

        return Matrix(rowCount: rowCount, columnCount: columnCount, values: values)
    }

    static func tensorProduct(_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
        var tensor: [Complex] = []

        let tensorRowCount = (lhs.rowCount * rhs.rowCount)
        let tensorColumnCount = (lhs.columnCount * rhs.columnCount)
        tensor.reserveCapacity(tensorRowCount * tensorColumnCount)

        for column in 0..<tensorColumnCount {
            for row in 0..<tensorRowCount {
                let lhsColumn = (column / rhs.columnCount)
                let lhsRow = (row / rhs.rowCount)

                let rhsColumn = (column % rhs.columnCount)
                let rhsRow = (row % rhs.rowCount)

                tensor.append(lhs[lhsRow,lhsColumn] * rhs[rhsRow,rhsColumn])
            }
        }

        return Matrix(rowCount: tensorRowCount, columnCount: tensorColumnCount, values: tensor)
    }
}

// MARK: - CustomStringConvertible methods

extension Matrix: CustomStringConvertible {
    public var description: String {
        var txt = "[\n"
        for row in 0..<rowCount {
            txt += "["
            for column in 0..<columnCount {
                txt += " \(self[row, column]) "
            }
            txt += "]\n"
        }
        txt += "]"

        return txt
    }
}

// MARK: - Equatable methods

extension Matrix: Equatable {}

// MARK: - Sequence methods

extension Matrix: Sequence {
    public typealias Iterator = Array<Complex>.Iterator

    /// Returns iterator that traverses the matrix by column
    public func makeIterator() -> Matrix.Iterator {
        return values.makeIterator()
    }
}

// MARK: - Overloaded operators

extension Matrix {

    // MARK: - Internal types

    enum Transformation {
        case none(_ matrix: Matrix)
        case adjointed(_ matrix: Matrix)
    }

    // MARK: - Internal operators

    static func *(complex: Complex, matrix: Matrix) -> Matrix {
        let columns = matrix.values.map { complex * $0 }

        return Matrix(rowCount: matrix.rowCount, columnCount: matrix.columnCount, values: columns)
    }

    static func *(lhs: Matrix, rhs: Matrix) throws -> Matrix {
        return (try Transformation.none(lhs) * rhs)
    }

    enum ProductError: Error {
        case matricesDoNotHaveValidDimensions
    }

    static func *(lhsTransformation: Transformation, rhs: Matrix) throws -> Matrix {
        var lhs: Matrix!
        var lhsTrans = CblasNoTrans
        var areDimensionsValid = false

        switch lhsTransformation {
        case .none(let matrix):
            lhs = matrix
            lhsTrans = CblasNoTrans
            areDimensionsValid = (matrix.columnCount == rhs.rowCount)
        case .adjointed(let matrix):
            lhs = matrix
            lhsTrans = CblasConjTrans
            areDimensionsValid = (matrix.rowCount == rhs.rowCount)
        }

        guard areDimensionsValid else {
            throw ProductError.matricesDoNotHaveValidDimensions
        }

        return Matrix.multiply(lhs: lhs, lhsTrans: lhsTrans, rhs: rhs)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private methods

    func isEqual(_ matrix: Matrix, accuracy: Double) -> Bool {
        guard ((rowCount == matrix.rowCount) && (columnCount == matrix.columnCount)) else {
            return false
        }

        return values.elementsEqual(matrix.values) {
            let realInRange = (abs($0.real - $1.real) <= accuracy)
            let imagInRange = (abs($0.imag - $1.imag) <= accuracy)

            return (realInRange && imagInRange)
        }
    }

    // MARK: - Private class methods

    static func serializedRowsByColumn(_ rows: [[Complex]],
                                       rowCount: Int,
                                       columnCount: Int) -> [Complex] {
        var elements: [Complex] = []
        elements.reserveCapacity(rowCount * columnCount)

        for column in 0..<columnCount {
            for row in 0..<rowCount {
                elements.append(rows[row][column])
            }
        }

        return elements
    }

    static func multiply(lhs: Matrix,
                         lhsTrans: CBLAS_TRANSPOSE = CblasNoTrans,
                         rhs: Matrix,
                         rhsTrans: CBLAS_TRANSPOSE = CblasNoTrans) -> Matrix {
        let m = (lhsTrans == CblasNoTrans ? lhs.rowCount : lhs.columnCount)
        let n = (rhsTrans == CblasNoTrans ? rhs.columnCount : rhs.rowCount)
        let k = (lhsTrans == CblasNoTrans ? lhs.columnCount : lhs.rowCount)
        var alpha = Complex(1)
        var aBuffer = lhs.values
        let lda = lhs.rowCount
        var bBuffer = rhs.values
        let ldb = rhs.rowCount
        var beta = Complex(0)
        var cBuffer = Array(repeating: Complex(0), count: (m * n))
        let ldc = m

        cblas_zgemm(CblasColMajor,
                    lhsTrans,
                    rhsTrans,
                    Int32(m),
                    Int32(n),
                    Int32(k),
                    &alpha,
                    &aBuffer,
                    Int32(lda),
                    &bBuffer,
                    Int32(ldb),
                    &beta,
                    &cBuffer,
                    Int32(ldc))

        return Matrix(rowCount: m, columnCount: n, values: cBuffer)
    }
}
