//
//  FixedOracleGate+SimulatorOracleMatrixAdapterFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/04/2021.
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

class FixedOracleGate_SimulatorOracleMatrixAdapterFactoryTests: XCTestCase {

    // MARK: - Properties

    let nonUnitaryMatrix = try! Matrix([
        [.zero, .one],
        [.one, .one]
    ])

    // MARK: - Tests

    func testEmptyControls_makeOracleMatrixAdapter_throwException() {
        // Given
        let sut = FixedOracleGate(truthTable: [], controls: [], gate: Gate.not(target: 0))

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeOracleMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateControlsCanNotBeAnEmptyList)
    }

    func testTruthTableBiggerThanControlCount_makeOracleMatrixAdapter_throwException() {
        // Given
        let sut = FixedOracleGate(truthTable: ["11"], controls: [1], gate: Gate.not(target: 0))

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeOracleMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateTruthTableCanNotBeRepresentedWithGivenControlCount)
    }

    func testNonValidTruthTable_makeOracleMatrixAdapter_throwException() {
        // Given
        let sut = FixedOracleGate(truthTable: ["a"], controls: [1], gate: Gate.not(target: 0))

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeOracleMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateTruthTableEntriesHaveToBeNonEmptyStringsComposedOnlyOfZerosAndOnes)
    }

    func testControlledGateThatThrowsError_makeOracleMatrixAdapter_throwException() {
        // Given
        let sut = FixedOracleGate(truthTable: ["0"],
                                  controls: [1],
                                  gate: Gate.matrix(matrix: nonUnitaryMatrix, inputs: [0]))

        // Then
        var error: GateError?
        if case .failure(let e) = sut.makeOracleMatrixAdapter() {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
    }

    func testAnyOracleGate_makeOracleMatrixAdapter_returnExpectedResult() {
        // Given
        let truthTable = ["110", "101"]
        let sut = FixedOracleGate(truthTable: truthTable,
                                  controls: [2, 4, 5],
                                  gate: Gate.not(target: 0))

        // When
        let result = try? sut.makeOracleMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 3)
        XCTAssertEqual(result?.truthTable, truthTable.map({ try! TruthTableEntry(truth: $0) }))
        XCTAssertEqual(result?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
    }

    func testAnyOracleOracleGate_makeOracleMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedOracleGate(truthTable: ["10", "01"],
                                  controls: [2, 4],
                                  gate: Gate.oracle(truthTable: ["11", "00"],
                                                    controls: [5, 3],
                                                    gate: Gate.not(target: 0)))

        // When
        let result = try? sut.makeOracleMatrixAdapter().get()

        // Then
        let truthTable = [
            try! TruthTableEntry(truth: "1011"),
            try! TruthTableEntry(truth: "1000"),
            try! TruthTableEntry(truth: "0111"),
            try! TruthTableEntry(truth: "0100")
        ]

        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, truthTable)
        XCTAssertEqual(result?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
    }

    func testOracleOracleGateWithEmptyFirstTruthTable_makeOracleMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedOracleGate(truthTable: [],
                                  controls: [2, 4],
                                  gate: Gate.oracle(truthTable: ["11", "00"],
                                                    controls: [5, 3],
                                                    gate: Gate.not(target: 0)))

        // When
        let result = try? sut.makeOracleMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, [])
        XCTAssertEqual(result?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
    }

    func testOracleOracleGateWithEmptySecondTruthTable_makeOracleMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedOracleGate(truthTable: ["10", "01"],
                                  controls: [2, 4],
                                  gate: Gate.oracle(truthTable: [],
                                                    controls: [5, 3],
                                                    gate: Gate.not(target: 0)))

        // When
        let result = try? sut.makeOracleMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, [])
        XCTAssertEqual(result?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
    }

    func testOracleOracleGateWithBothTruthTablesEmpty_makeOracleMatrixAdapter_returnExpectedResult() {
        // Given
        let sut = FixedOracleGate(truthTable: [],
                                  controls: [2, 4],
                                  gate: Gate.oracle(truthTable: [],
                                                    controls: [5, 3],
                                                    gate: Gate.not(target: 0)))

        // When
        let result = try? sut.makeOracleMatrixAdapter().get()

        // Then
        XCTAssertEqual(result?.controlCount, 4)
        XCTAssertEqual(result?.truthTable, [])
        XCTAssertEqual(result?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
    }

    static var allTests = [
        ("testEmptyControls_makeOracleMatrixAdapter_throwException",
         testEmptyControls_makeOracleMatrixAdapter_throwException),
        ("testTruthTableBiggerThanControlCount_makeOracleMatrixAdapter_throwException",
         testTruthTableBiggerThanControlCount_makeOracleMatrixAdapter_throwException),
        ("testNonValidTruthTable_makeOracleMatrixAdapter_throwException",
         testNonValidTruthTable_makeOracleMatrixAdapter_throwException),
        ("testControlledGateThatThrowsError_makeOracleMatrixAdapter_throwException",
         testControlledGateThatThrowsError_makeOracleMatrixAdapter_throwException),
        ("testAnyOracleGate_makeOracleMatrixAdapter_returnExpectedResult",
         testAnyOracleGate_makeOracleMatrixAdapter_returnExpectedResult),
        ("testAnyOracleOracleGate_makeOracleMatrixAdapter_returnExpectedResult",
         testAnyOracleOracleGate_makeOracleMatrixAdapter_returnExpectedResult),
        ("testOracleOracleGateWithEmptyFirstTruthTable_makeOracleMatrixAdapter_returnExpectedResult",
         testOracleOracleGateWithEmptyFirstTruthTable_makeOracleMatrixAdapter_returnExpectedResult),
        ("testOracleOracleGateWithEmptySecondTruthTable_makeOracleMatrixAdapter_returnExpectedResult",
         testOracleOracleGateWithEmptySecondTruthTable_makeOracleMatrixAdapter_returnExpectedResult),
        ("testOracleOracleGateWithBothTruthTablesEmpty_makeOracleMatrixAdapter_returnExpectedResult",
         testOracleOracleGateWithBothTruthTablesEmpty_makeOracleMatrixAdapter_returnExpectedResult)
    ]
}
