//
//  Vector.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/08/2018.
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

import ComplexModule
import Foundation

// MARK: - Main body

/// Swift representation of a complex vector
public struct Vector {

    // MARK: - Public properties

    /// Number of elements in the vector
    public var count: Int {
        return matrix.rowCount
    }

    /// Returns first element
    public var first: Complex<Double> {
        return matrix.first
    }

    /// Use [index] to access elements in the vector
    public subscript(index: Int) -> Complex<Double> {
        return matrix[index,0]
    }

    // MARK: - Internal properties

    var squaredNorm: Double {
        return try! Vector.innerProduct(self, self).get().real
    }

    // MARK: - Private properties

    private let matrix: Matrix

    // MARK: - Public init methods

    /// Errors throwed by `Vector.init()`
    public enum InitError: Error {
        /// Throwed when no `Complex` element is provided to initialize a new vector
        case doNotPassAnEmptyArray
    }

    /**
     Initializes a new `Vector` instance with `elements`.

     - Parameter elements: List of `Complex` values.

     - Throws: `Vector.InitError`.

     - Returns: A new `Vector` instance.
     */
    public init(_ elements: [Complex<Double>]) throws {
        let rows = elements.map { [$0] }

        var matrix: Matrix!
        do {
            matrix = try Matrix(rows)
        } catch Matrix.InitError.doNotPassAnEmptyArray {
            throw InitError.doNotPassAnEmptyArray
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        self.init(matrix: matrix)
    }

    // MARK: - Private init methods

    private init(matrix: Matrix) {
        self.matrix = matrix
    }

    // MARK: - Internal class methods

    enum MakeVectorError: Error {
        case passCountBiggerThanZero
        case passMaxConcurrencyBiggerThanZero
    }

    static func makeVector(count: Int,
                           maxConcurrency: Int = 1,
                           value: (Int) -> Complex<Double>) -> Result<Vector, MakeVectorError> {
        guard count > 0 else {
            return .failure(.passCountBiggerThanZero)
        }

        guard maxConcurrency > 0 else {
            return .failure(.passMaxConcurrencyBiggerThanZero)
        }

        let matrix = try! Matrix.makeMatrix(rowCount: count,
                                            columnCount: 1,
                                            maxConcurrency: maxConcurrency,
                                            value: { r, c in value(r) }).get()

        return .success(Vector(matrix: matrix))
    }

    enum InnerProductError: Error {
        case vectorsDoNotHaveSameCount
    }

    static func innerProduct(_ lhs: Vector,
                             _ rhs: Vector) -> Result<Complex<Double>, InnerProductError> {
        switch Matrix.Transformation.adjointed(lhs.matrix) * rhs.matrix {
        case .success(let matrix):
            return .success(matrix.first)
        case .failure(.matricesDoNotHaveValidDimensions):
            return .failure(.vectorsDoNotHaveSameCount)
        }
    }
}

// MARK: - CustomStringConvertible methods

extension Vector: CustomStringConvertible {
    public var description: String {
        return matrix.description
    }
}

// MARK: - Hashable methods

extension Vector: Hashable {}

// MARK: - Sequence methods

extension Vector: Sequence {
    public typealias Iterator = ArraySlice<Complex<Double>>.Iterator

    public func makeIterator() -> Vector.Iterator {
        return matrix.makeIterator()
    }
}

// MARK: - Overloaded operators

extension Vector {

    // MARK: - Internal types

    enum VectorByVectorError: Error {
        case vectorCountsDoNotMatch
    }

    enum MatrixByVectorError: Error {
        case matrixColumnCountDoesNotMatchVectorCount
    }

    enum VectorByMatrixError: Error {
        case matrixRowCountDoesNotMatchVectorCount
    }

    // MARK: - Internal operators

    static func *(lhs: Vector, rhs: Vector) -> Result<Complex<Double>, VectorByVectorError> {
        switch Matrix.Transformation.transposed(lhs.matrix) * rhs.matrix {
        case .success(let matrix):
            return .success(matrix.first)
        case .failure(.matricesDoNotHaveValidDimensions):
            return .failure(.vectorCountsDoNotMatch)
        }
    }

    static func *(lhs: Matrix, rhs: Vector) -> Result<Vector, MatrixByVectorError> {
        switch lhs * rhs.matrix {
        case .success(let matrix):
            return .success(Vector(matrix: matrix))
        case .failure(.matricesDoNotHaveValidDimensions):
            return .failure(.matrixColumnCountDoesNotMatchVectorCount)
        }
    }

    static func *(lhs: Vector, rhs: Matrix) -> Result<Vector, VectorByMatrixError> {
        switch Matrix.Transformation.transposed(lhs.matrix) * rhs {
        case .success(let matrix):
            return .success(Vector(matrix: matrix.transposed()))
        case .failure(.matricesDoNotHaveValidDimensions):
            return .failure(.matrixRowCountDoesNotMatchVectorCount)
        }
    }
}
