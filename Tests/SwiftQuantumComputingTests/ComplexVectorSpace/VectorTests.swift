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

    func testEmptyArray_init_throwException() {
        // Then
        XCTAssertThrowsError(try Vector([]))
    }

    func testAnyVector_count_returnExpectedValue() {
        // Given
        let elements = [Complex.zero, Complex.zero, Complex.zero]
        let vector = try! Vector(elements)

        // Then
        XCTAssertEqual(vector.count, elements.count)
    }

    func testAnyVector_squaredNorm_returnExpectedValue() {
        // Given
        let vector = try! Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: 2)])

        // Then
        XCTAssertEqual(vector.squaredNorm, 10)
    }

    func testAnyVector_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex(real: 10, imag: 10)
        let vector = try! Vector([Complex.zero, expectedValue, Complex.zero])

        // Then
        XCTAssertEqual(vector[1], expectedValue)
    }

    func testAnyVector_loop_returnExpectedSequence() {
        // Given
        let elements = [Complex.one, Complex.zero, Complex(2)]
        let vector = try! Vector(elements)

        // When
        let sequence = vector.map { $0 }

        // Then
        XCTAssertEqual(sequence, elements)
    }

    func testCountEqualToZero_makeVector_throwException() {
        // Then
        var error: Vector.MakeVectorError?
        if case .failure(let e) = Vector.makeVector(count: 0, value: { _ in Complex.zero }) {
            error = e
        }
        XCTAssertEqual(error, .passCountBiggerThanZero)
    }

    func testValidCount_makeVector_returnExpectedVector() {
        // Given
        let count = 3

        // When
        let result = try! Vector.makeVector(count: count, value: { Complex($0) }).get()

        // Then
        let expectedResult = try! Vector((0..<count).map { Complex($0) })
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithDifferentDimensions_innerProduct_throwException() {
        // Given
        let lhs = try! Vector([Complex.zero, Complex.zero])
        let rhs = try! Vector([Complex.zero, Complex.zero, Complex.zero])

        // Then
        var error: Vector.InnerProductError?
        if case .failure(let e) = Vector.innerProduct(lhs, rhs) {
            error = e
        }
        XCTAssertEqual(error, .vectorsDoNotHaveSameCount)
    }

    func testTwoVector_innerProduct_returnExpectedValue() {
        // Given
        let lhs = try! Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: -1)])
        let rhs = try! Vector([Complex(real: 3, imag: -2), Complex(real: 1, imag: 1)])

        // When
        let result = try? Vector.innerProduct(lhs, rhs).get()

        // Then
        let expectedResult = Complex(real: 2, imag: -2)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithDifferentDimensions_multiply_throwException() {
        // Given
        let lhs = try! Vector([Complex.zero, Complex.zero])
        let rhs = try! Vector([Complex.zero, Complex.zero, Complex.zero])

        // Then
        var error: Vector.VectorByVectorError?
        if case .failure(let e) = lhs * rhs {
            error = e
        }
        XCTAssertEqual(error, .vectorCountsDoNotMatch)
    }

    func testTwoVector_multiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector(
            [Complex(real: 3, imag: 2), Complex(real: 0, imag: 0), Complex(real: 5, imag: -6)]
        )
        let rhs = try! Vector(
            [Complex(real: 5, imag: 0), Complex(real: 0, imag: 0), Complex(real: 7, imag: -4)]
        )

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = Complex(real: 26, imag: -52)
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithColumnCountDifferentThanRowCountInVector_multiply_throwException() {
        // Given
        let lhs = try! Matrix([[Complex.zero, Complex.zero]])
        let rhs = try! Vector([Complex.zero, Complex.zero, Complex.zero])

        // Then
        var error: Vector.MatrixByVectorError?
        if case .failure(let e) = lhs * rhs {
            error = e
        }
        XCTAssertEqual(error, .matrixColumnCountDoesNotMatchVectorCount)
    }

    func testMatrixWithColumnCountEqualToRowCountInVector_multiply_returnExpectedMatrix() {
        // Given
        let lhsElements = [
            [Complex(real: 3, imag: 2), Complex(real: 0, imag: 0), Complex(real: 5, imag: -6)],
            [Complex(real: 1, imag: 0), Complex(real: 4, imag: 2), Complex(real: 0, imag: 1)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements = [
            Complex(real: 5, imag: 0), Complex(real: 0, imag: 0), Complex(real: 7, imag: -4)
        ]
        let rhs = try! Vector(rhsElements)

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = try! Vector([Complex(real: 26, imag: -52), Complex(real: 9, imag: 7)])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyArray_init_throwException",
         testEmptyArray_init_throwException),
        ("testAnyVector_count_returnExpectedValue",
         testAnyVector_count_returnExpectedValue),
        ("testAnyVector_squaredNorm_returnExpectedValue",
         testAnyVector_squaredNorm_returnExpectedValue),
        ("testAnyVector_subscript_returnExpectedValue",
         testAnyVector_subscript_returnExpectedValue),
        ("testCountEqualToZero_makeVector_throwException",
         testCountEqualToZero_makeVector_throwException),
        ("testValidCount_makeVector_returnExpectedVector",
         testValidCount_makeVector_returnExpectedVector),
        ("testTwoVectorWithDifferentDimensions_innerProduct_throwException",
         testTwoVectorWithDifferentDimensions_innerProduct_throwException),
        ("testTwoVector_innerProduct_returnExpectedValue",
         testTwoVector_innerProduct_returnExpectedValue),
        ("testTwoVectorWithDifferentDimensions_multiply_throwException",
         testTwoVectorWithDifferentDimensions_multiply_throwException),
        ("testTwoVector_multiply_returnExpectedValue",
         testTwoVector_multiply_returnExpectedValue),
        ("testMatrixWithColumnCountDifferentThanRowCountInVector_multiply_throwException",
         testMatrixWithColumnCountDifferentThanRowCountInVector_multiply_throwException),
        ("testMatrixWithColumnCountEqualToRowCountInVector_multiply_returnExpectedMatrix",
         testMatrixWithColumnCountEqualToRowCountInVector_multiply_returnExpectedMatrix)
    ]
}
