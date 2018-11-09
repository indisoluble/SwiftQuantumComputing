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

import Accelerate
import Foundation

// MARK: - Main body

public struct Matrix {

    // MARK: - Internal properties

    let rowCount: Int
    let columnCount: Int

    var isSquare: Bool {
        return (rowCount == columnCount)
    }

    var first: Complex {
        return elements.first!
    }

    subscript(row: Int, column: Int) -> Complex {
        return elements[(column * rowCount) + row]
    }

    // MARK: - Private properties

    private let elements: [Complex]

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init?(_ rows: [[Complex]]) {
        guard let firstRow = rows.first else {
            os_log("init failed: do not pass an empty array", log: Matrix.logger, type: .debug)

            return nil
        }

        let columnCount = firstRow.count
        guard (columnCount > 0) else {
            os_log("init failed: sub-arrays must not be empty", log: Matrix.logger, type: .debug)

            return nil
        }

        let sameCountOnEachRow = rows.reduce(true) { $0 && ($1.count == columnCount) }
        guard sameCountOnEachRow else {
            os_log("init failed: sub-arrays have to have same size",
                   log: Matrix.logger,
                   type: .debug)

            return nil
        }

        let rowCount = rows.count
        let elements = Matrix.serializedRowsByColumn(rows,
                                                     rowCount: rowCount,
                                                     columnCount: columnCount)

        self.init(rowCount: rowCount, columnCount: columnCount, elements: elements)
    }

    // MARK: - Private init methods

    private init(rowCount: Int, columnCount: Int, elements: [Complex]) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.elements = elements
    }

    // MARK: - Internal methods

    func isUnitary(accuracy: Double) -> Bool {
        let identity = Matrix.makeIdentity(count: rowCount)!

        var matrix = Matrix.multiply(lhs: self, rhs: self, rhsTrans: CblasConjTrans)
        guard matrix.isEqual(identity, accuracy: accuracy) else {
            return false
        }

        matrix = Matrix.multiply(lhs: self, lhsTrans: CblasConjTrans, rhs: self)
        return matrix.isEqual(identity, accuracy: accuracy)
    }

    // MARK: - Internal class methods

    static func makeIdentity(count: Int) -> Matrix? {
        guard (count > 0) else {
            os_log("makeIdentity failed: pass count bigger than 0",
                   log: Matrix.logger,
                   type: .debug)

            return nil
        }

        var columns = Array(repeating: Complex(0), count: count * count)
        for i in 0..<count {
            columns[(i * count) + i] = Complex(1)
        }

        return Matrix(rowCount: count, columnCount: count, elements: columns)
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

        return Matrix(rowCount: tensorRowCount, columnCount: tensorColumnCount, elements: tensor)
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

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return (lhs.elements == rhs.elements)
    }
}

// MARK: - Overloaded operators

extension Matrix {

    // MARK: - Types

    enum Transformation {
        case none(_ matrix: Matrix)
        case adjointed(_ matrix: Matrix)
    }

    // MARK: - Internal operators

    static func *(complex: Complex, matrix: Matrix) -> Matrix {
        let columns = matrix.elements.map { complex * $0 }

        return Matrix(rowCount: matrix.rowCount, columnCount: matrix.columnCount, elements: columns)
    }

    static func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        return (Transformation.none(lhs) * rhs)
    }

    static func *(lhsTransformation: Transformation, rhs: Matrix) -> Matrix? {
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
            os_log("* failed: matrices do not have valid dimensions",
                   log: Matrix.logger,
                   type: .debug)

            return nil
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

        return elements.elementsEqual(matrix.elements) {
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
        var aBuffer = lhs.elements
        let lda = lhs.rowCount
        var bBuffer = rhs.elements
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

        return Matrix(rowCount: m, columnCount: n, elements: cBuffer)
    }
}
