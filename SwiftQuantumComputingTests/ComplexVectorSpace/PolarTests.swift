//
//  PolarTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 25/07/2018.
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

class PolarTests: XCTestCase {

    // MARK: - Tests

    func testAnyComplexNumber_init_returnExpectedPolar() {
        // Given
        let complex = Complex(real: 1, imag: 1)

        // When
        let result = Polar(complex)

        // Then
        let expectedResult = Polar(magnitude: sqrt(2), phase: (Double.pi / 4))
        XCTAssertEqual(result.magnitude, expectedResult.magnitude)
        XCTAssertEqual(result.phase, expectedResult.phase)
    }

    func testTwoEqualPolarNumbersWithOneBigPositivePhase_normalized_returnEqualPolarNumbers() {
        // Given
        let p1 = Polar(magnitude: 10, phase: Double.pi)
        let p2 = Polar(magnitude: 10, phase: (Double.pi + (5 * 2 * Double.pi)))

        // When
        let normalizedP1 = p1.normalized()
        let normalizedP2 = p2.normalized()

        // Then
        XCTAssertEqual(normalizedP1.magnitude, normalizedP2.magnitude)
        XCTAssertEqual(normalizedP1.phase, normalizedP2.phase, accuracy: 0.001)
    }

    func testTwoEqualPolarNumbersWithOneNegativePhase_normalized_returnEqualPolarNumbers() {
        // Given
        let p1 = Polar(magnitude: 10, phase: ((3 / 2) * Double.pi))
        let p2 = Polar(magnitude: 10, phase: ((-1 / 2) * Double.pi))

        // When
        let normalizedP1 = p1.normalized()
        let normalizedP2 = p2.normalized()

        // Then
        XCTAssertEqual(normalizedP1.magnitude, normalizedP2.magnitude)
        XCTAssertEqual(normalizedP1.phase, normalizedP2.phase, accuracy: 0.001)
    }

    func testTwoPolarNumbers_multiply_returnExpectedPolarNumber() {
        // Given
        let lhs = Polar(magnitude: 5, phase: 1)
        let rhs = Polar(magnitude: 5, phase: 1)

        // When
        let result = (lhs * rhs)

        // Then
        let expectedResult = Polar(magnitude: 25, phase: 2)
        XCTAssertEqual(result.magnitude, expectedResult.magnitude)
        XCTAssertEqual(result.phase, expectedResult.phase)
    }

    func testTwoPolarNumbers_divide_returnExpectedPolarNumber() {
        // Given
        let lhs = Polar(magnitude: 4, phase: 6)
        let rhs = Polar(magnitude: 2, phase: 2)

        // When
        let result = (lhs / rhs)

        // Then
        let expectedResult = Polar(magnitude: 2, phase: 4)
        XCTAssertEqual(result.magnitude, expectedResult.magnitude)
        XCTAssertEqual(result.phase, expectedResult.phase)
    }
}
