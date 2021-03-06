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

import ComplexModule
import XCTest

// MARK: - Main body

class ComplexTests: XCTestCase {

    // MARK: - Tests

    func testAnyInt_init_returnExpectedComplexNumber() {
        // Given
        let number = 10

        // Then
        XCTAssertEqual(Complex<Double>(number), Complex<Double>(Double(number), 0))
    }

    func testAnyDouble_init_returnExpectedComplexNumber() {
        // Given
        let number = Double(10)

        // Then
        XCTAssertEqual(Complex<Double>(number), Complex<Double>(number, 0))
    }

    func testAnyComplexNumber_conjugated_returnExpectecValue() {
        // Given
        let complex = Complex<Double>(2, 1)

        // When
        let result = complex.conjugate

        // Then
        let expectedResult = Complex<Double>(2, -1)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_add_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex<Double>(3, -1)
        let rhs = Complex<Double>(1, 4)

        // When
        let result = (lhs + rhs)

        // Then
        let expectedResult = Complex<Double>(4, 3)
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoComplexNumbers_multiply_returnExpectedCompleNumber() {
        // Given
        let lhs = Complex<Double>(3, -1)
        let rhs = Complex<Double>(1, 4)

        // When
        let result = (lhs * rhs)

        // Then
        let expectedResult = Complex<Double>(7, 11)
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyComplexNumber_squaredModulus_returnExpectecValue() {
        // Given
        let complex = Complex<Double>(2, 1)

        // When
        let result = complex.lengthSquared

        // Then
        XCTAssertEqual(result, 5)
    }

    static var allTests = [
        ("testAnyInt_init_returnExpectedComplexNumber",
         testAnyInt_init_returnExpectedComplexNumber),
        ("testAnyDouble_init_returnExpectedComplexNumber",
         testAnyDouble_init_returnExpectedComplexNumber),
        ("testAnyComplexNumber_conjugated_returnExpectecValue",
         testAnyComplexNumber_conjugated_returnExpectecValue),
        ("testTwoComplexNumbers_add_returnExpectedCompleNumber",
         testTwoComplexNumbers_add_returnExpectedCompleNumber),
        ("testTwoComplexNumbers_multiply_returnExpectedCompleNumber",
         testTwoComplexNumbers_multiply_returnExpectedCompleNumber),
        ("testAnyComplexNumber_squaredModulus_returnExpectecValue",
         testAnyComplexNumber_squaredModulus_returnExpectecValue)
    ]
}
