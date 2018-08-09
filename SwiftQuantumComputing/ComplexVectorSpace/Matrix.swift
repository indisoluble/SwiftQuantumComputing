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

    public var isHermitian: Bool {
        return (self == self.adjointed())
    }

    public var rowCount: Int {
        return rows.count
    }

    var columnCount: Int {
        return rows.first!.count
    }

    var first: Complex {
        return rows.first!.first!
    }

    subscript(row: Int, column: Int) -> Complex {
        return rows[row][column]
    }

    // MARK: - Private properties

    private let rows: [[Complex]]

    // MARK: - Init methods

    public init?(_ rows: [[Complex]]) {
        guard let firstRow = rows.first else {
            return nil
        }

        let numColumns = firstRow.count
        guard (numColumns > 0) else {
            return nil
        }

        let sameCountOnEachRow = rows.reduce(true) { $0 && ($1.count == numColumns) }
        guard sameCountOnEachRow else {
            return nil
        }

        self.init(validRows: rows)
    }

    private init(validRows: [[Complex]]) {
        self.rows = validRows
    }

    // MARK: - Public methods

    public func isUnitary(accuracy: Double) -> Bool {
        let adjoint = adjointed()
        let lhs = (self * adjoint)!
        let rhs = (adjoint * self)!

        let identity = Matrix.makeIdentity(count: rowCount)!
        let lhsIsIdentity = (lhs.isEqual(identity, accuracy: accuracy))
        let rhsIsIdentity = (rhs.isEqual(identity, accuracy: accuracy))

        return (lhsIsIdentity && rhsIsIdentity)
    }

    public func hermitianEigens() -> [(eigenvalue: Double, eigenvector: Vector)]? {
        guard isHermitian else {
            return nil
        }

        var jobz = Int8(86) // V: Compute eigenvalues and eigenvectors
        var uplo = Int8(76) // L: Lower triangular part

        var n = Int32(rowCount)
        var lda = Int32(rowCount)
        var info = Int32()

        var w = Array(repeating: Double(), count: rowCount)
        var a = transposed().rows.reduce([]) { $0 + $1.map { __CLPK_doublecomplex($0) } }

        // Get optimal workspace
        var tmpWork = __CLPK_doublecomplex()
        var lengthTmpWork = Int32(-1)
        var tmpRWork = Double()
        var lengthTmpRWork = Int32(-1)
        var tmpIWork = Int32()
        var lengthTmpIWork = Int32(-1)

        zheevd_(&jobz, &uplo, &n, &a, &lda, &w, &tmpWork, &lengthTmpWork, &tmpRWork, &lengthTmpRWork, &tmpIWork, &lengthTmpIWork, &info)

        // Compute eigenvalues & eigenvectors
        var lengthWork = Int32(tmpWork.r)
        var work = Array(repeating: __CLPK_doublecomplex(), count: Int(lengthWork))
        var lengthRWork = Int32(tmpRWork)
        var rWork = Array(repeating: Double(), count: Int(lengthRWork))
        var lengthIWork = tmpIWork
        var iWork = Array(repeating: Int32(), count: Int(lengthIWork))

        zheevd_(&jobz, &uplo, &n, &a, &lda, &w, &work, &lengthWork, &rWork, &lengthRWork, &iWork, &lengthIWork, &info)

        // Validate results
        if (info > 0) {
            return nil
        }

        let indexes = stride(from: 0, to: a.count, by: rowCount)
        let columns = indexes.map { a[$0..<($0 + rowCount)].map { Complex($0) } }
        let vectors = columns.map { Vector($0)! }

        return Array(zip(w, vectors))
    }

    func transposed() -> Matrix {
        let initial = Array(repeating: [] as [Complex], count: columnCount)
        let result = rows.reduce(initial) { zip($0, $1).map { $0 + [$1] } }

        return Matrix(validRows: result)
    }

    func conjugated() -> Matrix {
        let result = rows.map { $0.map { $0.conjugated() } }

        return Matrix(validRows: result)
    }

    func adjointed() -> Matrix {
        return conjugated().transposed()
    }

    // MARK: - Public class methods

    public static func makeIdentity(count: Int) -> Matrix? {
        guard (count > 0) else {
            return nil
        }

        let indexes = (0..<count)
        let elements = indexes.map {(rowIndex) -> [Complex] in
            return indexes.map { Complex(rowIndex == $0 ? 1 : 0) }
        }

        return Matrix(elements)
    }

    static func tensorProduct(_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
        let matrices = lhs.rows.map { $0.map{ $0 * rhs } }

        let acc = Array(repeating: [] as [Complex], count: rhs.rowCount)
        let elements = matrices.reduce([]) { $0 +  $1.reduce(acc) { zip($0, $1.rows).map(+) } }

        return Matrix(validRows: elements)
    }
}

// MARK: - CustomStringConvertible methods

extension Matrix: CustomStringConvertible {
    public var description: String {
        return ("[" + rows.map { $0.description }.joined(separator: ",\n") + "]")
    }
}

// MARK: - Equatable methods

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return (lhs.rows == rhs.rows)
    }
}

// MARK: - Overloaded operators

extension Matrix {
    public static prefix func -(matrix: Matrix) -> Matrix {
        let elements = matrix.rows.map { $0.map(-) }

        return Matrix(validRows: elements)
    }

    public static func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.rowCount == rhs.rowCount) else {
            return nil
        }

        guard (lhs.columnCount == rhs.columnCount) else {
            return nil
        }

        let elements = zip(lhs.rows, rhs.rows).map { zip($0, $1).map(+) }

        return Matrix(validRows: elements)
    }

    public static func *(complex: Complex, matrix: Matrix) -> Matrix {
        let elements = matrix.rows.map { $0.map { complex * $0 } }

        return Matrix(validRows: elements)
    }

    public static func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columnCount == rhs.rowCount) else {
            return nil
        }

        let zero = Complex(real: 0, imag: 0)
        let rhsTransposed = rhs.transposed()

        let elements = lhs.rows.map { (row) -> [Complex] in
            return rhsTransposed.rows.map { (column) -> Complex in
                return zip(row, column).map(*).reduce(zero, +)
            }
        }

        return Matrix(validRows: elements)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private methods

    func isEqual(_ matrix: Matrix, accuracy: Double) -> Bool {
        guard ((rowCount == matrix.rowCount) && (columnCount == matrix.columnCount)) else {
            return false
        }

        return zip(self.rows, matrix.rows).reduce(true) {
            let rowInRange = zip($1.0, $1.1).reduce(true) {
                let lhs = $1.0
                let rhs = $1.1

                let realInRange = (abs(lhs.real - rhs.real) <= accuracy)
                let imagInRange = (abs(lhs.imag - rhs.imag) <= accuracy)

                return ($0 && (realInRange && imagInRange))
            }

            return ($0 && rowInRange)
        }
    }
}
