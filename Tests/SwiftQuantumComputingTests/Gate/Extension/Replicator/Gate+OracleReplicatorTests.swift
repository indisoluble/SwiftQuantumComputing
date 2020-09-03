//
//  Gate+OracleReplicatorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/12/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

class Gate_OracleReplicatorTests: XCTestCase {

    // MARK: - Tests

    func testEmptyTargets_oracle_returnEmptyList() {
        // Given
        let truthTable: [Gate.ExtendedTruth] = [("111", "01"), ("000", "10")]
        let targets: [Int] = []
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        XCTAssertEqual(gates, [])
    }

    func testTwoExtTruthTableWithAllBitDeactivated_oracle_returnExpectedList() {
        // Given
        let truthTable: [Gate.ExtendedTruth] = [("111", "00"), ("000", "00")]
        let targets = [3, 1]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        XCTAssertEqual(gates, [])
    }

    func testTwoExtTruthTableWithOnlyOneBitActivatedEach_oracle_returnExpectedList() {
        // Given
        let oneTruth = "111"
        let otherTruth = "000"
        let truthTable: [Gate.ExtendedTruth] = [(oneTruth, "01"), (otherTruth, "10")]
        let targetZero = 1
        let targetOne = 3
        let targets = [targetOne, targetZero]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [oneTruth], controls: controls, gate: .not(target: targetZero)),
            Gate.oracle(truthTable: [otherTruth], controls: controls, gate: .not(target: targetOne))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testTwoExtTruthTableButOnlyOneWithBitActivated_oracle_returnExpectedList() {
        // Given
        let otherTruth = "000"
        let truthTable: [Gate.ExtendedTruth] = [("", "00"), (otherTruth, "10")]
        let targetOne = 3
        let targets = [targetOne, 1]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [otherTruth], controls: controls, gate: .not(target: targetOne))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testRepeatedTargets_oracle_returnListWithOraclesAppliedToSameTarget() {
        // Given
        let oneTruth = "111"
        let otherTruth = "000"
        let truthTable: [Gate.ExtendedTruth] = [(oneTruth, "01"), (otherTruth, "10")]
        let target = 3
        let targets = [target, target]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [oneTruth], controls: controls, gate: .not(target: target)),
            Gate.oracle(truthTable: [otherTruth], controls: controls, gate: .not(target: target))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testExtTruthTableWithActivationSorterThanControls_oracle_returnExpectedList() {
        // Given
        let truth = "111"
        let truthTable: [Gate.ExtendedTruth] = [(truth, "1")]
        let target = 1
        let targets = [5, 3, target]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [truth], controls: controls, gate: .not(target: target))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testExtTruthTableWithActivationWithIncorrectBit_oracle_returnExpectedList() {
        // Given
        let truth = "111"
        let truthTable: [Gate.ExtendedTruth] = [(truth, "A1")]
        let target = 1
        let targets = [3, target]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [truth], controls: controls, gate: .not(target: target))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testVariedExtTruthTables_oracle_returnExpectedList() {
        // Given
        let oneTruth = "111"
        let otherTruth = "000"
        let anotherTruth = "010"
        let truthTable: [Gate.ExtendedTruth] = [
            (oneTruth, "001"),
            (otherTruth, "110"),
            (anotherTruth, "011")
        ]
        let targetZero = 1
        let targetOne = 3
        let targetTwo = 5
        let targets = [targetTwo, targetOne, targetZero]
        let controls: [Int] = []

        // When
        let gates = Gate.oracle(truthTable: truthTable, controls: controls, targets: targets)

        // Then
        let expectedGates = [
            Gate.oracle(truthTable: [oneTruth, anotherTruth],
                        controls: controls,
                        gate: .not(target: targetZero)),
            Gate.oracle(truthTable: [otherTruth, anotherTruth],
                        controls: controls,
                        gate: .not(target: targetOne)),
            Gate.oracle(truthTable: [otherTruth],
                        controls: controls,
                        gate: .not(target: targetTwo))
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    static var allTests = [
        ("testEmptyTargets_oracle_returnEmptyList",
         testEmptyTargets_oracle_returnEmptyList),
        ("testTwoExtTruthTableWithAllBitDeactivated_oracle_returnExpectedList",
         testTwoExtTruthTableWithAllBitDeactivated_oracle_returnExpectedList),
        ("testTwoExtTruthTableWithOnlyOneBitActivatedEach_oracle_returnExpectedList",
         testTwoExtTruthTableWithOnlyOneBitActivatedEach_oracle_returnExpectedList),
        ("testTwoExtTruthTableButOnlyOneWithBitActivated_oracle_returnExpectedList",
         testTwoExtTruthTableButOnlyOneWithBitActivated_oracle_returnExpectedList),
        ("testRepeatedTargets_oracle_returnListWithOraclesAppliedToSameTarget",
         testRepeatedTargets_oracle_returnListWithOraclesAppliedToSameTarget),
        ("testExtTruthTableWithActivationSorterThanControls_oracle_returnExpectedList",
         testExtTruthTableWithActivationSorterThanControls_oracle_returnExpectedList),
        ("testExtTruthTableWithActivationWithIncorrectBit_oracle_returnExpectedList",
         testExtTruthTableWithActivationWithIncorrectBit_oracle_returnExpectedList),
        ("testVariedExtTruthTables_oracle_returnExpectedList",
         testVariedExtTruthTables_oracle_returnExpectedList)
    ]
}
