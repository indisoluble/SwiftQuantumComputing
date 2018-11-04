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

    // MARK: - Public properties

    public let rowCount: Int
    public let columnCount: Int

    public var isSquare: Bool {
        return (rowCount == columnCount)
    }

    public var first: Complex {
        return columns.first!
    }

    public subscript(row: Int, column: Int) -> Complex {
        return columns[(column * rowCount) + row]
    }

    // MARK: - Private properties

    private let columns: [Complex]

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Init methods

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

        let columns = Matrix.serializedByColumn(rows: rows, columnCount: columnCount)

        self.init(rowCount: rows.count, columnCount: columnCount, columns: columns)
    }

    private init(rowCount: Int, columnCount: Int, columns: [Complex]) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.columns = columns
    }

    // MARK: - Public methods

    public func isUnitary(accuracy: Double) -> Bool {
        let identity = Matrix.makeIdentity(count: rowCount)!

        var matrix = Matrix.multiply(lhs: self, rhs: self, rhsTrans: CblasConjTrans)
        guard matrix.isEqual(identity, accuracy: accuracy) else {
            return false
        }

        matrix = Matrix.multiply(lhs: self, lhsTrans: CblasConjTrans, rhs: self)
        return matrix.isEqual(identity, accuracy: accuracy)
    }

    public func transposed() -> Matrix {
        var result: [Complex] = []
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                result.append(self[row, column])
            }
        }

        return Matrix(rowCount: columnCount, columnCount: rowCount, columns: result)
    }

    public func conjugated() -> Matrix {
        let result = columns.map { $0.conjugated() }

        return Matrix(rowCount: rowCount, columnCount: columnCount, columns: result)
    }

    public func adjointed() -> Matrix {
        return conjugated().transposed()
    }

    // MARK: - Public class methods

    public static func makeIdentity(count: Int) -> Matrix? {
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

        return Matrix(rowCount: count, columnCount: count, columns: columns)
    }

    public static func tensorProduct(_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
        var tensor: [Complex] = []
        let tensorRowCount = (lhs.rowCount * rhs.rowCount)
        let tensorColumnCount = (lhs.columnCount * rhs.columnCount)

        for column in 0..<tensorColumnCount {
            for row in 0..<tensorRowCount {
                let lhsColumn = (column / rhs.columnCount)
                let lhsRow = (row / rhs.rowCount)

                let rhsColumn = (column % rhs.columnCount)
                let rhsRow = (row % rhs.rowCount)

                tensor.append(lhs[lhsRow, lhsColumn] * rhs[rhsRow, rhsColumn])
            }
        }

        return Matrix(rowCount: tensorRowCount, columnCount: tensorColumnCount, columns: tensor)
    }
}

// MARK: - CustomStringConvertible methods

extension Matrix: CustomStringConvertible {
    public var description: String {
        var txt = "["
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
        return (lhs.columns == rhs.columns)
    }
}

// MARK: - Overloaded operators

extension Matrix {
    public static func *(complex: Complex, matrix: Matrix) -> Matrix {
        let elements = matrix.columns.map { complex * $0 }

        return Matrix(rowCount: matrix.rowCount, columnCount: matrix.columnCount, columns: elements)
    }

    public static func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columnCount == rhs.rowCount) else {
            os_log("* failed: left matrix column count have to be equal to right matrix row count",
                   log: Matrix.logger,
                   type: .debug)

            return nil
        }

        return multiply(lhs: lhs, rhs: rhs)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private methods

    func isEqual(_ matrix: Matrix, accuracy: Double) -> Bool {
        guard ((rowCount == matrix.rowCount) && (columnCount == matrix.columnCount)) else {
            return false
        }

        return zip(self.columns, matrix.columns).reduce(true) {
            let lhs = $1.0
            let rhs = $1.1

            let realInRange = (abs(lhs.real - rhs.real) <= accuracy)
            let imagInRange = (abs(lhs.imag - rhs.imag) <= accuracy)

            return ($0 && (realInRange && imagInRange))
        }
    }

    // MARK: - Private class methods

    static func serializedByColumn(rows: [[Complex]], columnCount: Int) -> [Complex] {
        let initial = Array(repeating: [] as [Complex], count: columnCount)
        let groupedByColumn = rows.reduce(initial) { zip($0, $1).map { $0 + [$1] } }

        let serialized = groupedByColumn.reduce([], +)

        return serialized
    }

    static func multiply(lhs: Matrix,
                         lhsTrans: CBLAS_TRANSPOSE = CblasNoTrans,
                         rhs: Matrix,
                         rhsTrans: CBLAS_TRANSPOSE = CblasNoTrans) -> Matrix {
        var alpha = Complex(1)
        var aBuffer = lhs.columns
        var bBuffer = rhs.columns
        var beta = Complex(0)
        var cBuffer = Array(repeating: Complex(0), count: lhs.rowCount * rhs.columnCount)

        cblas_zgemm(CblasColMajor,
                    lhsTrans,
                    rhsTrans,
                    Int32(lhs.rowCount),
                    Int32(rhs.columnCount),
                    Int32(lhs.columnCount),
                    &alpha,
                    &aBuffer,
                    Int32(lhs.rowCount),
                    &bBuffer,
                    Int32(rhs.rowCount),
                    &beta,
                    &cBuffer,
                    Int32(lhs.rowCount))

        return Matrix(rowCount: lhs.rowCount, columnCount: rhs.columnCount, columns: cBuffer)
    }
}
