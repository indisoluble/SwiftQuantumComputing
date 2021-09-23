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

import ComplexModule
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
        let elements: [Complex<Double>] = [.zero, .zero, .zero]
        let vector = try! Vector(elements)

        // Then
        XCTAssertEqual(vector.count, elements.count)
    }

    func testAnyVector_first_returnExpectedValue() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let elements: [Complex<Double>] = [expectedValue, .zero, .zero]
        let vector = try! Vector(elements)

        // Then
        XCTAssertEqual(vector.first, expectedValue)
    }

    func testAnyVector_squaredNorm_returnExpectedValue() {
        // Given
        let vector = try! Vector([Complex(1, 1), Complex(2, 2)])

        // Then
        XCTAssertEqual(vector.squaredNorm, 10)
    }

    func testAnyVector_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let vector = try! Vector([Complex.zero, expectedValue, Complex.zero])

        // Then
        XCTAssertEqual(vector[1], expectedValue)
    }

    func testAnyVector_loop_returnExpectedSequence() {
        // Given
        let elements: [Complex<Double>] = [.one, .zero, Complex(2)]
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

    func testZeroMaxConcurrency_makeVector_throwException() {
        // Then
        var error: Vector.MakeVectorError?
        if case .failure(let e) = Vector.makeVector(count: 3,
                                                    maxConcurrency: 0,
                                                    value: { _ in Complex.zero }) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
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

    func testEvenNumberOfElementsAndEvenMaxConcurrency_makeVector_returnExpectedVector() {
        // Given
        let count = 6
        let maxConcurrency = 2

        // When
        let result = try! Vector.makeVector(count: count,
                                            maxConcurrency: maxConcurrency,
                                            value: { Complex($0) }).get()

        // Then
        let expectedResult = try! Vector((0..<count).map { Complex($0) })
        XCTAssertEqual(result, expectedResult)
    }

    func testEvenNumberOfElementsAndOddMaxConcurrency_makeVector_returnExpectedVector() {
        // Given
        let count = 6
        let maxConcurrency = 3

        // When
        let result = try! Vector.makeVector(count: count,
                                            maxConcurrency: maxConcurrency,
                                            value: { Complex($0) }).get()

        // Then
        let expectedResult = try! Vector((0..<count).map { Complex($0) })
        XCTAssertEqual(result, expectedResult)
    }

    func testValidCountAndMaxConcurrencyBiggerThanNumberOfElements_makeVector_returnExpectedVector() {
        // Given
        let count = 6
        let maxConcurrency = 100

        // When
        let result = try! Vector.makeVector(count: count,
                                            maxConcurrency: maxConcurrency,
                                            value: { Complex($0) }).get()

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
        let lhs = try! Vector([Complex(1, 1), Complex(2, -1)])
        let rhs = try! Vector([Complex(3, -2), Complex(1, 1)])

        // When
        let result = try? Vector.innerProduct(lhs, rhs).get()

        // Then
        let expectedResult = Complex(2, -2)
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
        let lhs = try! Vector([Complex(3, 2), .zero, Complex(5, -6)])
        let rhs = try! Vector([Complex(5), .zero, Complex(7, -4)])

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = Complex<Double>(26, -52)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithSameDimensionsAndNoTransformation_multiply_throwException() {
        // Given
        let lhs = try! Vector([.zero, .zero])
        let rhs = try! Vector([.zero, .zero])

        // Then
        var error: Vector.VectorByVectorError?
        if case .failure(let e) = lhs * Vector.Transformation.none(rhs) {
            error = e
        }
        XCTAssertEqual(error, .vectorCountsDoNotMatch)
    }

    func testOneVectorAnotherVectorWithOneValueAndNoTransformation_multiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector([.zero, .one, Complex(2), Complex(3, -3)])
        let rhs = try! Vector([Complex(-1, -1)])

        // When
        let result = try? (lhs * Vector.Transformation.none(rhs)).get()

        // Then
        let expectedResult = try! Matrix([[.zero],
                                          [Complex(-1, -1)],
                                          [Complex(-2, -2)],
                                          [Complex(-6)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithSameDimensions_transposedMultiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector([.zero, .one])
        let rhs = try! Vector([Complex(2), Complex(3)])

        // When
        let result = try? (lhs * Vector.Transformation.transposed(rhs)).get()

        // Then
        let expectedResult = try! Matrix([[.zero, .zero],
                                          [Complex(2), Complex(3)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithDifferentDimensions_transposedMultiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector([Complex(3, 2), Complex(-5, 1)])
        let rhs = try! Vector([Complex(2, -4), .one, Complex(3)])

        // When
        let result = try? (lhs * Vector.Transformation.transposed(rhs)).get()

        // Then
        let expectedResult = try! Matrix([[Complex(14, -8), Complex(3, 2), Complex(9, 6)],
                                          [Complex(-6, 22), Complex(-5, 1), Complex(-15, 3)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithSameDimensions_adjointedMultiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector([.zero, .one])
        let rhs = try! Vector([Complex(2), .i])

        // When
        let result = try? (lhs * Vector.Transformation.adjointed(rhs)).get()

        // Then
        let expectedResult = try! Matrix([[.zero, .zero],
                                          [Complex(2), -.i]])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoVectorWithDifferentDimensions_adjointedMultiply_returnExpectedValue() {
        // Given
        let lhs = try! Vector([Complex(3, 2), Complex(-5, 1)])
        let rhs = try! Vector([Complex(2, 4), .one, Complex(3)])

        // When
        let result = try? (lhs * Vector.Transformation.adjointed(rhs)).get()

        // Then
        let expectedResult = try! Matrix([[Complex(14, -8), Complex(3, 2), Complex(9, 6)],
                                          [Complex(-6, 22), Complex(-5, 1), Complex(-15, 3)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithColumnCountDifferentThanRowCountInVector_multiplyMatrixByVector_throwException() {
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

    func testMatrixWithColumnCountEqualToRowCountInVector_multiplyMatrixByVector_returnExpectedVector() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), .zero, Complex(5, -6)],
            [.one, Complex(4, 2), .i]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements: [Complex<Double>] = [Complex(5), .zero, Complex(7, -4)]
        let rhs = try! Vector(rhsElements)

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = try! Vector([Complex(26, -52), Complex(9, 7)])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInVector_multiplyVectorByMatrix_throwException() {
        // Given
        let lhs = try! Vector([Complex.zero, Complex.zero, Complex.zero])
        let rhs = try! Matrix([[Complex.zero, Complex.zero]])

        // Then
        var error: Vector.VectorByMatrixError?
        if case .failure(let e) = lhs * rhs {
            error = e
        }
        XCTAssertEqual(error, .matrixRowCountDoesNotMatchVectorCount)
    }

    func testMatrixWithRowCountEqualToRowCountInVector_multiplyVectorByMatrix_returnExpectedVector() {
        // Given
        let lhsElements: [Complex<Double>] = [Complex(5), .zero, Complex(7, -4)]
        let lhs = try! Vector(lhsElements)

        let rhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), .one],
            [.zero, Complex(4, 2)],
            [Complex(5, -6), .i]
        ]
        let rhs = try! Matrix(rhsElements)

        // When
        let result = try? (lhs * rhs).get()

        // Then
        let expectedResult = try! Vector([Complex(26, -52), Complex(9, 7)])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyArray_init_throwException",
         testEmptyArray_init_throwException),
        ("testAnyVector_count_returnExpectedValue",
         testAnyVector_count_returnExpectedValue),
        ("testAnyVector_first_returnExpectedValue",
         testAnyVector_first_returnExpectedValue),
        ("testAnyVector_squaredNorm_returnExpectedValue",
         testAnyVector_squaredNorm_returnExpectedValue),
        ("testAnyVector_subscript_returnExpectedValue",
         testAnyVector_subscript_returnExpectedValue),
        ("testCountEqualToZero_makeVector_throwException",
         testCountEqualToZero_makeVector_throwException),
        ("testZeroMaxConcurrency_makeVector_throwException",
         testZeroMaxConcurrency_makeVector_throwException),
        ("testValidCount_makeVector_returnExpectedVector",
         testValidCount_makeVector_returnExpectedVector),
        ("testEvenNumberOfElementsAndEvenMaxConcurrency_makeVector_returnExpectedVector",
         testEvenNumberOfElementsAndEvenMaxConcurrency_makeVector_returnExpectedVector),
        ("testEvenNumberOfElementsAndOddMaxConcurrency_makeVector_returnExpectedVector",
         testEvenNumberOfElementsAndOddMaxConcurrency_makeVector_returnExpectedVector),
        ("testValidCountAndMaxConcurrencyBiggerThanNumberOfElements_makeVector_returnExpectedVector",
         testValidCountAndMaxConcurrencyBiggerThanNumberOfElements_makeVector_returnExpectedVector),
        ("testTwoVectorWithDifferentDimensions_innerProduct_throwException",
         testTwoVectorWithDifferentDimensions_innerProduct_throwException),
        ("testTwoVector_innerProduct_returnExpectedValue",
         testTwoVector_innerProduct_returnExpectedValue),
        ("testTwoVectorWithDifferentDimensions_multiply_throwException",
         testTwoVectorWithDifferentDimensions_multiply_throwException),
        ("testTwoVector_multiply_returnExpectedValue",
         testTwoVector_multiply_returnExpectedValue),
        ("testTwoVectorWithSameDimensionsAndNoTransformation_multiply_throwException",
         testTwoVectorWithSameDimensionsAndNoTransformation_multiply_throwException),
        ("testOneVectorAnotherVectorWithOneValueAndNoTransformation_multiply_returnExpectedValue",
         testOneVectorAnotherVectorWithOneValueAndNoTransformation_multiply_returnExpectedValue),
        ("testTwoVectorWithSameDimensions_transposedMultiply_returnExpectedValue",
         testTwoVectorWithSameDimensions_transposedMultiply_returnExpectedValue),
        ("testTwoVectorWithDifferentDimensions_transposedMultiply_returnExpectedValue",
         testTwoVectorWithDifferentDimensions_transposedMultiply_returnExpectedValue),
        ("testTwoVectorWithSameDimensions_adjointedMultiply_returnExpectedValue",
         testTwoVectorWithSameDimensions_adjointedMultiply_returnExpectedValue),
        ("testTwoVectorWithDifferentDimensions_adjointedMultiply_returnExpectedValue",
         testTwoVectorWithDifferentDimensions_adjointedMultiply_returnExpectedValue),
        ("testMatrixWithColumnCountDifferentThanRowCountInVector_multiplyMatrixByVector_throwException",
         testMatrixWithColumnCountDifferentThanRowCountInVector_multiplyMatrixByVector_throwException),
        ("testMatrixWithColumnCountEqualToRowCountInVector_multiplyMatrixByVector_returnExpectedVector",
         testMatrixWithColumnCountEqualToRowCountInVector_multiplyMatrixByVector_returnExpectedVector),
        ("testMatrixWithRowCountDifferentThanRowCountInVector_multiplyVectorByMatrix_throwException",
         testMatrixWithRowCountDifferentThanRowCountInVector_multiplyVectorByMatrix_throwException),
        ("testMatrixWithRowCountEqualToRowCountInVector_multiplyVectorByMatrix_returnExpectedVector",
         testMatrixWithRowCountEqualToRowCountInVector_multiplyVectorByMatrix_returnExpectedVector)
    ]
}
