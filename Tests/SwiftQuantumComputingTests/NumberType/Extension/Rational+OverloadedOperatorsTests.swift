//
//  Rational+OverloadedOperatorsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/03/2020.
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

class Rational_OverloadedOperatorsTests: XCTestCase {

    // MARK: - Tests

    func testFactorialWithSameDenominator_subtraction_returnExpectedResult() {
        // Then
        XCTAssertEqual(try! Rational(numerator: 10, denominator: 3) - Rational(numerator: 5, denominator: 3),
                       try! Rational(numerator: 5, denominator: 3))
        XCTAssertEqual(try! Rational(numerator: 5, denominator: 3) - Rational(numerator: 10, denominator: 3),
                       try! Rational(numerator: -5, denominator: 3))
        XCTAssertEqual(try! Rational(numerator: 10, denominator: 3) - Rational(numerator: -5, denominator: 3),
                       try! Rational(numerator: 15, denominator: 3))
        XCTAssertEqual(try! Rational(numerator: -10, denominator: 3) - Rational(numerator: 5, denominator: 3),
                       try! Rational(numerator: -15, denominator: 3))
    }

    func testFactorialWithDifferentDenominator_subtraction_returnExpectedResult() {
        // Then
        XCTAssertEqual(try! Rational(numerator: 5, denominator: 2) - Rational(numerator: 7, denominator: 3),
                       try! Rational(numerator: 1, denominator: 6))
        XCTAssertEqual(try! Rational(numerator: 7, denominator: 3) - Rational(numerator: 5, denominator: 2),
                       try! Rational(numerator: -1, denominator: 6))
        XCTAssertEqual(try! Rational(numerator: 5, denominator: 2) - Rational(numerator: -7, denominator: 3),
                       try! Rational(numerator: 29, denominator: 6))
        XCTAssertEqual(try! Rational(numerator: -7, denominator: 3) - Rational(numerator: 5, denominator: 2),
                       try! Rational(numerator: -29, denominator: 6))
    }

    func testFactorialWithSameDenominator_smallerThan_returnExpectedResult() {
        // Then
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: 10, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 10, denominator: 2) < Rational(numerator: 5, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 2) < Rational(numerator: -1, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: -1, denominator: 2) < Rational(numerator: -10, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 2) < Rational(numerator: 5, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: -10, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: 5, denominator: 2))
    }

    func testFactorialWithDifferentDenominator_smallerThan_returnExpectedResult() {
        // Then
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: 10, denominator: 3))
        XCTAssertFalse(try! Rational(numerator: 10, denominator: 3) < Rational(numerator: 5, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 3) < Rational(numerator: -1, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: -1, denominator: 2) < Rational(numerator: -10, denominator: 3))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 3) < Rational(numerator: 5, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: -10, denominator: 3))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) < Rational(numerator: 10, denominator: 4))
    }

    func testFactorialWithSameDenominator_smallerThanOrEqual_returnExpectedResult() {
        // Then
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: 10, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 10, denominator: 2) <= Rational(numerator: 5, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 2) <= Rational(numerator: -1, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: -1, denominator: 2) <= Rational(numerator: -10, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 2) <= Rational(numerator: 5, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: -10, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: 5, denominator: 2))
    }

    func testFactorialWithDifferentDenominator_smallerThanOrEqual_returnExpectedResult() {
        // Then
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: 10, denominator: 3))
        XCTAssertFalse(try! Rational(numerator: 10, denominator: 3) <= Rational(numerator: 5, denominator: 2))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 3) <= Rational(numerator: -1, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: -1, denominator: 2) <= Rational(numerator: -10, denominator: 3))
        XCTAssertTrue(try! Rational(numerator: -10, denominator: 3) <= Rational(numerator: 5, denominator: 2))
        XCTAssertFalse(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: -10, denominator: 3))
        XCTAssertTrue(try! Rational(numerator: 5, denominator: 2) <= Rational(numerator: 10, denominator: 4))
    }

    static var allTests = [
        ("testFactorialWithSameDenominator_subtraction_returnExpectedResult",
         testFactorialWithSameDenominator_subtraction_returnExpectedResult),
        ("testFactorialWithDifferentDenominator_subtraction_returnExpectedResult",
         testFactorialWithDifferentDenominator_subtraction_returnExpectedResult),
        ("testFactorialWithSameDenominator_smallerThan_returnExpectedResult",
         testFactorialWithSameDenominator_smallerThan_returnExpectedResult),
        ("testFactorialWithDifferentDenominator_smallerThan_returnExpectedResult",
         testFactorialWithDifferentDenominator_smallerThan_returnExpectedResult),
        ("testFactorialWithSameDenominator_smallerThanOrEqual_returnExpectedResult",
         testFactorialWithSameDenominator_smallerThanOrEqual_returnExpectedResult),
        ("testFactorialWithDifferentDenominator_smallerThanOrEqual_returnExpectedResult",
         testFactorialWithDifferentDenominator_smallerThanOrEqual_returnExpectedResult)
    ]
}
