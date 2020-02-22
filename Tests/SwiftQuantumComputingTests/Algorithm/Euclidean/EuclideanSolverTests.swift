//
//  EuclideanSolverTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/02/2020.
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

class EuclideanSolverTests: XCTestCase {

    // MARK: - Tests

    func testAIsZero_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(10, 0), 10)
    }

    func testAIsNegative_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(-1071, 462), 21)
    }

    func testBIsZero_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(0, 10), 10)
    }

    func testBIsNegative_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(1071, -462), -21)
    }

    func testSimpleValues_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(9, 3), 3)
    }

    func testAnyValues_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(1071, 462), 21)
    }

    func testAnyValuesSwapped_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(462, 1071), 21)
    }

    func testAnyNegativeValues_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(-1071, -462), -21)
    }

    func testAnyNegativeValuesSwapped_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(-462, -1071), -21)
    }

    func testOtherValues_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(252, 105), 21)
    }

    func testOtherValuesSwapped_findGreatestCommonDivisor_returnExpectedValue() {
        // Then
        XCTAssertEqual(EuclideanSolver.findGreatestCommonDivisor(105, 252), 21)
    }

    static var allTests = [
        ("testAIsZero_findGreatestCommonDivisor_returnExpectedValue",
         testAIsZero_findGreatestCommonDivisor_returnExpectedValue),
        ("testAIsNegative_findGreatestCommonDivisor_returnExpectedValue",
         testAIsNegative_findGreatestCommonDivisor_returnExpectedValue),
        ("testBIsZero_findGreatestCommonDivisor_returnExpectedValue",
         testBIsZero_findGreatestCommonDivisor_returnExpectedValue),
        ("testBIsNegative_findGreatestCommonDivisor_returnExpectedValue",
         testBIsNegative_findGreatestCommonDivisor_returnExpectedValue),
        ("testSimpleValues_findGreatestCommonDivisor_returnExpectedValue",
         testSimpleValues_findGreatestCommonDivisor_returnExpectedValue),
        ("testAnyValues_findGreatestCommonDivisor_returnExpectedValue",
         testAnyValues_findGreatestCommonDivisor_returnExpectedValue),
        ("testAnyValuesSwapped_findGreatestCommonDivisor_returnExpectedValue",
         testAnyValuesSwapped_findGreatestCommonDivisor_returnExpectedValue),
        ("testAnyNegativeValues_findGreatestCommonDivisor_returnExpectedValue",
         testAnyNegativeValues_findGreatestCommonDivisor_returnExpectedValue),
        ("testAnyNegativeValuesSwapped_findGreatestCommonDivisor_returnExpectedValue",
         testAnyNegativeValuesSwapped_findGreatestCommonDivisor_returnExpectedValue),
        ("testOtherValues_findGreatestCommonDivisor_returnExpectedValue",
         testOtherValues_findGreatestCommonDivisor_returnExpectedValue),
        ("testOtherValuesSwapped_findGreatestCommonDivisor_returnExpectedValue",
         testOtherValuesSwapped_findGreatestCommonDivisor_returnExpectedValue)
    ]
}
