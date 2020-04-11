//
//  RationalTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/03/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

class RationalTests: XCTestCase {

    // MARK: - Tests

    func testDenominatorEqualToZero_init_throwError() {
        // Then
        XCTAssertThrowsError(try Rational(numerator: 1, denominator: 0))
    }

    func testAnyNonZeroDenominator_init_returnInstance() {
        // Then
        XCTAssertNoThrow(try Rational(numerator: 1, denominator: 1))
    }

    func testNegativeDenominator_init_returnExpectedInstance() {
        // When
        let result = try? Rational(numerator: 1, denominator: -1)

        // Then
        XCTAssertEqual(result?.numerator, -1)
        XCTAssertEqual(result?.denominator, 1)
    }

    func testBothNegativeNumeratorAndDenominator_init_returnExpectedInstance() {
        // When
        let result = try? Rational(numerator: -1, denominator: -1)

        // Then
        XCTAssertEqual(result?.numerator, 1)
        XCTAssertEqual(result?.denominator, 1)
    }

    static var allTests = [
        ("testDenominatorEqualToZero_init_throwError",
         testDenominatorEqualToZero_init_throwError),
        ("testAnyNonZeroDenominator_init_returnInstance",
         testAnyNonZeroDenominator_init_returnInstance),
        ("testNegativeDenominator_init_returnExpectedInstance",
         testNegativeDenominator_init_returnExpectedInstance),
        ("testBothNegativeNumeratorAndDenominator_init_returnExpectedInstance",
         testBothNegativeNumeratorAndDenominator_init_returnExpectedInstance)
    ]
}
