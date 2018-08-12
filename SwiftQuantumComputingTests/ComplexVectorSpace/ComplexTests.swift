//
//  ComplexTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 24/07/2018.
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
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class ComplexTests: XCTestCase {

    // MARK: - Tests

    func testAnyInt_init_returnExpectedComplexNumber() {
        // Given
        let number = 10

        // Then
        XCTAssertEqual(Complex(number), Complex(real: Double(number), imag: 0))
    }

    func testAnyDouble_init_returnExpectedComplexNumber() {
        // Given
        let number = Double(10)

        // Then
        XCTAssertEqual(Complex(number), Complex(real: number, imag: 0))
    }

    func testAnyPolarNumber_init_returnExpectedComplexNumber() {
        // Given
        let polar = Polar(magnitude: sqrt(2), phase: (Double.pi / 4))

        // When
        let result = Complex(polar)

        // Then
        let expectedResult = Complex(real: 1, imag: 1)
        XCTAssertEqual(result.real, expectedResult.real, accuracy: 0.001)
        XCTAssertEqual(result.imag, expectedResult.imag, accuracy: 0.001)
    }

    func testAnyDoubleComplex_init_returnExpectedComplexNumber() {
        // Given
        let doubleComplex = __CLPK_doublecomplex(r: 10, i: 10)

        // When
        let complex = Complex(doubleComplex)

        // Then
        let expectedComplex = Complex(real: 10, imag: 10)
        XCTAssertEqual(complex, expectedComplex)
    }

    func testNotOneByOneMatrix_init_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = Matrix([[complex, complex], [complex, complex]])!

        // Then
        XCTAssertNil(Complex(matrix))
    }

    func testOneByOneMatrix_init_returnExpectedComplexNumber() {
        // Given
        let expectedValue = Complex(real: 10, imag: 10)
        let matrix = Matrix([[expectedValue]])!

        // Then
        XCTAssertEqual(Complex(matrix), expectedValue)
    }

    func testAnyComplexNumber_squaredModulus_returnExpectecValue() {
        // Given
        let complex = Complex(real: 2, imag: 1)

        // When
        let result = complex.squaredModulus

        // Then
        XCTAssertEqual(result, 5)
    }

    func testAnyComplexNumber_modulus_returnExpectecValue() {
        // Given
        let complex = Complex(real: 2, imag: 1)

        // When
        let result = complex.modulus

        // Then
        XCTAssertEqual(result, sqrt(5))
    }

    func testAnyComplexNumber_conjugated_returnExpectecValue() {
        // Given
        let complex = Complex(real: 2, imag: 1)

        // When
        let result = complex.conjugated()

        // Then
        let expectedResult = Complex(real: 2, imag: -1)
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyComplexNumber_unaryMinus_returnExpectedCompleNumber() {
        // Given
        let complex = Complex(real: 1, imag: 1)

        // When
        let result = -complex

        // Then
        let expectedResult = Complex(real: -1, imag: -1)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_add_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex(real: 3, imag: -1)
        let rhs = Complex(real: 1, imag: 4)

        // When
        let result = (lhs + rhs)

        // Then
        let expectedResult = Complex(real: 4, imag: 3)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_subtract_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex(real: 3, imag: -1)
        let rhs = Complex(real: 1, imag: 4)

        // When
        let result = (lhs - rhs)

        // Then
        let expectedResult = Complex(real: 2, imag: -5)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_multiply_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex(real: 3, imag: -1)
        let rhs = Complex(real: 1, imag: 4)

        // When
        let result = (lhs * rhs)

        // Then
        let expectedResult = Complex(real: 7, imag: 11)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_divide_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex(real: -2, imag: 1)
        let rhs = Complex(real: 1, imag: 2)

        // When
        let result = (lhs / rhs)

        // Then
        let expectedResult = Complex(real: 0, imag: 1)
        XCTAssertEqual(result, expectedResult)
    }
}
