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

import ComplexModule
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
    public var first: Complex<Double> {
        return values.first!
    }

    /// Use [row, column] to access elements in the matrix
    public subscript(row: Int, column: Int) -> Complex<Double> {
        return values[(column * rowCount) + row]
    }

    // MARK: - Private properties

    private let values: ArraySlice<Complex<Double>>

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
    public init(_ elements: [[Complex<Double>]]) throws {
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

    private init(rowCount: Int, columnCount: Int, values: [Complex<Double>]) {
        self.init(rowCount: rowCount, columnCount: columnCount, values: ArraySlice(values))
    }

    private init(rowCount: Int, columnCount: Int, values: ArraySlice<Complex<Double>>) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.values = values
    }

    // MARK: - Internal methods

    func isApproximatelyEqual(to matrix: Matrix, absoluteTolerance: Double) -> Bool {
        guard ((rowCount == matrix.rowCount) && (columnCount == matrix.columnCount)) else {
            return false
        }

        return values.elementsEqual(matrix.values) {
            return $0.isApproximatelyEqual(to: $1, absoluteTolerance: absoluteTolerance)
        }
    }

    func isApproximatelyUnitary(absoluteTolerance: Double) -> Bool {
        let identity = try! Matrix.makeIdentity(count: rowCount).get()

        var matrix = Matrix.multiply(lhs: self, rhs: self, rhsTrans: CblasConjTrans)
        guard matrix.isApproximatelyEqual(to: identity, absoluteTolerance: absoluteTolerance) else {
            return false
        }

        matrix = Matrix.multiply(lhs: self, lhsTrans: CblasConjTrans, rhs: self)
        return matrix.isApproximatelyEqual(to: identity, absoluteTolerance: absoluteTolerance)
    }

    enum MakeSliceError: Error {
        case startColumnOutOfRange
        case columnCountOutOfRange
    }

    func makeSlice(startColumn: Int, columnCount: Int) -> Result<Matrix, MakeSliceError> {
        guard startColumn >= 0 && startColumn < self.columnCount else {
            return .failure(.startColumnOutOfRange)
        }

        guard columnCount > 0 && (startColumn + columnCount) <= self.columnCount else {
            return .failure(.columnCountOutOfRange)
        }

        let startIndex = values.startIndex + (startColumn * rowCount)
        let endIndex = startIndex + (columnCount * rowCount)
        let slice = values[startIndex..<endIndex]

        return .success(Matrix(rowCount: rowCount, columnCount: columnCount, values: slice))
    }

    // MARK: - Internal class methods

    enum MakeMatrixError: Error {
        case passRowCountBiggerThanZero
        case passColumnCountBiggerThanZero
        case passMaxConcurrencyBiggerThanZero
    }

    static func makeMatrix(rowCount: Int,
                           columnCount: Int,
                           maxConcurrency: Int = 1,
                           value: (Int, Int) -> Complex<Double>) -> Result<Matrix, MakeMatrixError> {
        guard rowCount > 0 else {
            return .failure(.passRowCountBiggerThanZero)
        }

        guard columnCount > 0 else {
            return .failure(.passColumnCountBiggerThanZero)
        }

        guard maxConcurrency > 0 else {
            return .failure(.passMaxConcurrencyBiggerThanZero)
        }

        let count = (rowCount * columnCount)
        let actualConcurrency = (maxConcurrency > count ? count : maxConcurrency)
        let use_value: (Int, (Int, Int) -> Complex<Double>) -> Complex<Double> = { index, value in
            value(index % rowCount, index / rowCount)
        }

        var values: [Complex<Double>]!
        if actualConcurrency == 1 {
            values = (0..<count).lazy.map { use_value($0, value) }
        } else {
            values = Array(unsafeUninitializedCapacity: count) { buffer, actualCount in
                actualCount = count

                let baseAddress = buffer.baseAddress!
                DispatchQueue.concurrentPerform(iterations: actualConcurrency) { iteration in
                    for index in stride(from: iteration, to: count, by: actualConcurrency) {
                        (baseAddress + index).initialize(to: use_value(index, value))
                    }
                }
            }
        }
        let matrix = Matrix(rowCount: rowCount, columnCount: columnCount, values: values)

        return .success(matrix)
    }

    static func makeMatrix(rowCount: Int,
                           columnCount: Int,
                           maxConcurrency: Int = 1,
                           rowValues: (Int) -> Vector,
                           customValue: (Int, Int, Vector) -> Complex<Double>) -> Result<Matrix, MakeMatrixError> {
        guard rowCount > 0 else {
            return .failure(.passRowCountBiggerThanZero)
        }

        guard columnCount > 0 else {
            return .failure(.passColumnCountBiggerThanZero)
        }

        guard maxConcurrency > 0 else {
            return .failure(.passMaxConcurrencyBiggerThanZero)
        }

        let count = rowCount * columnCount
        let actualConcurrency = (maxConcurrency > rowCount ? rowCount : maxConcurrency)

        let values: [Complex<Double>] = Array(unsafeUninitializedCapacity: count) { buffer, actualCount in
            actualCount = count

            let baseAddress = buffer.baseAddress!
            DispatchQueue.concurrentPerform(iterations: actualConcurrency) { iteration in
                for rowIndex in stride(from: iteration, to: rowCount, by: actualConcurrency) {
                    let row = rowValues(rowIndex)

                    for colIndex in 0..<columnCount {
                        let actualAddress = baseAddress + colIndex * rowCount + rowIndex

                        actualAddress.initialize(to: customValue(rowIndex, colIndex, row))
                    }
                }
            }
        }
        let matrix = Matrix(rowCount: rowCount, columnCount: columnCount, values: values)

        return .success(matrix)
    }
}

// MARK: - Hashable methods

extension Matrix: Hashable {}

// MARK: - Sequence methods

extension Matrix: Sequence {
    public typealias Iterator = ArraySlice<Complex<Double>>.Iterator

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
        case transposed(_ matrix: Matrix)
    }

    // MARK: - Internal operators

    enum AddError: Error {
        case matricesDoNotHaveSameRowCount
        case matricesDoNotHaveSameColumnCount
    }

    static func +(lhs: Matrix, rhs: Matrix) -> Result<Matrix, AddError> {
        guard lhs.rowCount == rhs.rowCount else {
            return .failure(.matricesDoNotHaveSameRowCount)
        }

        guard lhs.columnCount == rhs.columnCount else {
            return .failure(.matricesDoNotHaveSameColumnCount)
        }

        let N = Int32(lhs.values.count)
        var alpha = Complex<Double>.one
        let inc = Int32(1)
        var Y = Array(rhs.values)

        lhs.values.withUnsafeBytes { X in
            cblas_zaxpy(N, &alpha, X.baseAddress!, inc, &Y, inc)
        }

        let matrix = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount, values: Y)

        return .success(matrix)
    }

    static func *(complex: Complex<Double>, matrix: Matrix) -> Matrix {
        let N = Int32(matrix.values.count)
        var alpha = complex
        var X = Array(matrix.values)
        let incX = Int32(1)

        cblas_zscal(N, &alpha, &X, incX)

        return Matrix(rowCount: matrix.rowCount, columnCount: matrix.columnCount, values: X)
    }

    static func *(lhs: Matrix, rhs: Matrix) -> Result<Matrix, ProductError> {
        return Transformation.none(lhs) * rhs
    }

    enum ProductError: Error {
        case matricesDoNotHaveValidDimensions
    }

    static func *(lhsTransformation: Transformation, rhs: Matrix) -> Result<Matrix, ProductError> {
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
        case .transposed(let matrix):
            lhs = matrix
            lhsTrans = CblasTrans
            areDimensionsValid = (matrix.rowCount == rhs.rowCount)
        }

        guard areDimensionsValid else {
            return .failure(.matricesDoNotHaveValidDimensions)
        }

        let matrix = Matrix.multiply(lhs: lhs, lhsTrans: lhsTrans, rhs: rhs)

        return .success(matrix)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private class methods

    static func serializedRowsByColumn(_ rows: [[Complex<Double>]],
                                       rowCount: Int,
                                       columnCount: Int) -> [Complex<Double>] {
        var elements: [Complex<Double>] = []
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
        var alpha = Complex<Double>.one
        let lda = lhs.rowCount
        let ldb = rhs.rowCount
        var beta = Complex<Double>.zero
        let ldc = m

        let capacity = m * n
        let values = Array<Complex<Double>>(unsafeUninitializedCapacity: capacity) { cBuffer, actualCount in
            actualCount = capacity

            lhs.values.withUnsafeBytes { aBuffer in
                rhs.values.withUnsafeBytes { bBuffer in
                    cblas_zgemm(CblasColMajor,
                                lhsTrans,
                                rhsTrans,
                                Int32(m),
                                Int32(n),
                                Int32(k),
                                &alpha,
                                aBuffer.baseAddress!,
                                Int32(lda),
                                bBuffer.baseAddress!,
                                Int32(ldb),
                                &beta,
                                cBuffer.baseAddress!,
                                Int32(ldc))
                }
            }
        }

        return Matrix(rowCount: m, columnCount: n, values: values)
    }
}
