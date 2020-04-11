//
//  ContinuedFractionsSolverTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/03/2020.
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

class ContinuedFractionsSolverTests: XCTestCase {

    // MARK: - Properties

    let value = try! Rational(numerator: 15, denominator: 11)

    // MARK: - Tests

    func testZeroValue_findApproximation_throwError() {
        // Given
        let limit = try! Rational(numerator: 1, denominator: 1)

        // Then
        XCTAssertThrowsError(try ContinuedFractionsSolver.findApproximation(of: Rational.zero,
                                                                            differenceBelowOrEqual: limit))
    }

    func testZeroLimit_findApproximation_throwError() {
        // Then
        XCTAssertThrowsError(try ContinuedFractionsSolver.findApproximation(of: value,
                                                                            differenceBelowOrEqual: Rational.zero))
    }

    func testBigEnoughLimit_findApproximation_returnFirstConvergent() {
        // Given
        let limit = try! Rational(numerator: 41, denominator: 110)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        let expectedResult = try! Rational(numerator: 1, denominator: 1)
        XCTAssertEqual(result, expectedResult)
    }

    func testSmallEnoughLimit_findApproximation_returnSecondConvergent() {
        // Given
        let limit = try! Rational(numerator: 31, denominator: 220)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        let expectedResult = try! Rational(numerator: 3, denominator: 2)
        XCTAssertEqual(result, expectedResult)
    }

    func testSmallEnoughLimit_findApproximation_returnThirdConvergent() {
        // Given
        let limit = try! Rational(numerator: 11, denominator: 330)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        let expectedResult = try! Rational(numerator: 4, denominator: 3)
        XCTAssertEqual(result, expectedResult)
    }

    func testEvenSmallerLimit_findApproximation_returnThirdConvergent() {
        // Given
        let limit = try! Rational(numerator: 1, denominator: 33)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        let expectedResult = try! Rational(numerator: 4, denominator: 3)
        XCTAssertEqual(result, expectedResult)
    }

    func testSmallEnoughLimit_findApproximation_returnForthConvergent() {
        // Given
        let limit = try! Rational(numerator: 1, denominator: 330)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        XCTAssertEqual(result, value)
    }

    func testDivisibleValue_findApproximation_returnExpectedResult() {
        // Given
        let value = try! Rational(numerator: 4, denominator: 2)
        let limit = try! Rational(numerator: 1, denominator: 1)

        // When
        let result = try! ContinuedFractionsSolver.findApproximation(of: value,
                                                                     differenceBelowOrEqual: limit)

        // Then
        let expectedResult = try! Rational(numerator: 2, denominator: 1)
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testZeroValue_findApproximation_throwError",
         testZeroValue_findApproximation_throwError),
        ("testZeroLimit_findApproximation_throwError",
         testZeroLimit_findApproximation_throwError),
        ("testBigEnoughLimit_findApproximation_returnFirstConvergent",
         testBigEnoughLimit_findApproximation_returnFirstConvergent),
        ("testBigEnoughLimit_findApproximation_returnSecondConvergent",
         testSmallEnoughLimit_findApproximation_returnSecondConvergent),
        ("testSmallEnoughLimit_findApproximation_returnThirdConvergent",
         testSmallEnoughLimit_findApproximation_returnThirdConvergent),
        ("testEvenSmallerLimit_findApproximation_returnThirdConvergent",
         testEvenSmallerLimit_findApproximation_returnThirdConvergent),
        ("testSmallEnoughLimit_findApproximation_returnForthConvergent",
         testSmallEnoughLimit_findApproximation_returnForthConvergent),
        ("testDivisibleValue_findApproximation_returnExpectedResult",
         testDivisibleValue_findApproximation_returnExpectedResult)
    ]
}
