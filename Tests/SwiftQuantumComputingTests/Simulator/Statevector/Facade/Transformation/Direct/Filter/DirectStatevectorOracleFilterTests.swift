//
//  DirectStatevectorOracleFilterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/04/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class DirectStatevectorOracleFilterTests: XCTestCase {

    // MARK: - Properties

    let trueEntry = try! TruthTableEntry(repeating: "1", count: 1)
    let trueTwoEntry = try! TruthTableEntry(repeating: "1", count: 2)
    let falseEntry = try! TruthTableEntry(repeating: "0", count: 1)
    let falseTwoEntry = try! TruthTableEntry(repeating: "0", count: 2)
    let falseTrueEntry = try! TruthTableEntry(truth: "01", truthCount: 2)

    // MARK: - Tests

    func testNoControlsNoTruthTableAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [], truthTable: [])

        // Then
        XCTAssertFalse(Array(0..<8).allSatisfy { sut.shouldCalculateStatevectorValueAtPosition($0) })
    }

    func testControl2TruthTableTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2], truthTable: [trueEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    func testControl2TruthTableTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2], truthTable: [trueEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(3))
    }

    func testControl2TruthTableFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2], truthTable: [falseEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    func testControl2TruthTableFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2], truthTable: [falseEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(10))
    }

    func testControl2And0TruthTableTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [trueTwoEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl2And0TruthTableTrueAndTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [trueTwoEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    func testControl2And0TruthTableFalseAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTwoEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl2And0TruthTableFalseAndFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTwoEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(10))
    }

    func testControl2And0TruthTableFalseAndTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTrueEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(3))
    }

    func testControl2And0TruthTableFalseAndTrueAndPosition1_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTrueEntry])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(1))
    }

    func testControl2And0TruthTableFalseAndTrueAndPosition2_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTrueEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(2))
    }

    func testControl2And0TruthTableFalseAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [2, 0], truthTable: [falseTrueEntry])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl1And2And0TruthTableFalseAndTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [1, 2, 0],
                                                truthTable: [try! TruthTableEntry(truth: "011")])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [1, 2, 0],
                                                truthTable: [try! TruthTableEntry(truth: "010")])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [1, 2, 0],
                                                truthTable: [try! TruthTableEntry(truth: "010")])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    func testControl1And2And0TwoTruthTablesAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorOracleFilter(gateControls: [1, 2, 0],
                                                truthTable: [try! TruthTableEntry(truth: "010"),
                                                             try! TruthTableEntry(truth: "011")])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    static var allTests = [
        ("testNoControlsNoTruthTableAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testNoControlsNoTruthTableAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2TruthTableTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2TruthTableTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2TruthTableTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2TruthTableTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2TruthTableFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2TruthTableFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2TruthTableFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2TruthTableFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0TruthTableTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2And0TruthTableTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0TruthTableTrueAndTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2And0TruthTableTrueAndTrueAndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2And0TruthTableFalseAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2And0TruthTableFalseAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2And0TruthTableFalseAndFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2And0TruthTableFalseAndFalseAndPosition10_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0TruthTableFalseAndTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2And0TruthTableFalseAndTrueAndPosition3_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0TruthTableFalseAndTrueAndPosition1_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2And0TruthTableFalseAndTrueAndPosition1_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0TruthTableFalseAndTrueAndPosition2_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2And0TruthTableFalseAndTrueAndPosition2_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2And0TruthTableFalseAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2And0TruthTableFalseAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl1And2And0TruthTableFalseAndTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl1And2And0TruthTableFalseAndTrueAndTrueAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition5_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl1And2And0TruthTableFalseAndTrueAndFalseAndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl1And2And0TwoTruthTablesAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl1And2And0TwoTruthTablesAndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue)
    ]
}
