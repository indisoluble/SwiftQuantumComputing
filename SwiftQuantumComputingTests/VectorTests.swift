//
//  VectorTests.swift
//  SwiftQuantumComputingTests
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class VectorTests: XCTestCase {

    // MARK: - Tests

    func testEmptyArray_init_returnNil() {
        // Then
        XCTAssertNil(Vector([]))
    }

    func testAnyVector_squaredNorm_returnExpectedValue() {
        // Given
        let vector = Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: 2)])!

        // Then
        XCTAssertEqual(vector.squaredNorm, 10)
    }

    func testAnyVector_norm_returnExpectedValue() {
        // Given
        let vector = Vector([Complex(real: 2, imag: 1), Complex(real: 1, imag: -1)])!

        // Then
        let expectedValue = sqrt(7)
        XCTAssertEqual(vector.norm, expectedValue, accuracy: 0.001)
    }

    func testAnyVector_count_returnExpectecValue() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let elements = [complex, complex, complex]
        let vector = Vector(elements)!

        // Then
        XCTAssertEqual(vector.count, elements.count)
    }

    func testAnyVector_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex(real: 10, imag: 10)
        let complex = Complex(real: 0, imag: 0)
        let vector = Vector([complex, expectedValue, complex])!

        // Then
        XCTAssertEqual(vector[1], expectedValue)
    }

    func testNonNormalizedVector_normalized_returnExpectedVector() {
        // Given
        let vector = Vector([Complex(real: 2, imag: -3), Complex(real: 1, imag: 2)])!

        // Then
        let expectedVector = Vector([Complex(real: (2 / sqrt(18)), imag: -(3 / sqrt(18))),
                                     Complex(real: (1 / sqrt(18)), imag: (2 / sqrt(18)))])
        XCTAssertEqual(vector.normalized(), expectedVector)
    }

    func testTwoVectorWithDifferentDimensions_innerProduct_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let lhs = Vector([complex, complex])!
        let rhs = Vector([complex, complex, complex])!

        // Then
        XCTAssertNil(Vector.innerProduct(lhs, rhs))
    }

    func testTwoVector_innerProduct_returnExpectedValue() {
        // Given
        let lhs = Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: -1)])!
        let rhs = Vector([Complex(real: 3, imag: -2), Complex(real: 1, imag: 1)])!

        // When
        let result = Vector.innerProduct(lhs, rhs)

        // Then
        let expectedResult = Complex(real: 2, imag: -2)
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithColumnCountDifferentThanRowCountInVector_multiply_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let lhs = Matrix([[complex, complex]])!
        let rhs = Vector([complex, complex, complex])!

        // Then
        XCTAssertNil(lhs * rhs)
    }

    func testMatrixWithColumnCountEqualToRowCountInVector_multiply_returnExpectedMatrix() {
        // Given
        let lhsElements = [
            [Complex(real: 3, imag: 2), Complex(real: 0, imag: 0), Complex(real: 5, imag: -6)],
            [Complex(real: 1, imag: 0), Complex(real: 4, imag: 2), Complex(real: 0, imag: 1)]
        ]
        let lhs = Matrix(lhsElements)!

        let rhsElements = [
            Complex(real: 5, imag: 0), Complex(real: 0, imag: 0), Complex(real: 7, imag: -4)
        ]
        let rhs = Vector(rhsElements)!

        // When
        let result = (lhs * rhs)

        // Then
        let expectedResult = Vector([Complex(real: 26, imag: -52), Complex(real: 9, imag: 7)])
        XCTAssertEqual(result, expectedResult)
    }
}
