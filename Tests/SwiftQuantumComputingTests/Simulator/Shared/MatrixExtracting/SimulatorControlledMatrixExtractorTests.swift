//
//  SimulatorControlledMatrixExtractorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/02/2021.
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

class SimulatorControlledMatrixExtractorTests: XCTestCase {

    // MARK: - Properties

    let nonUnitaryMatrix = try! Matrix([
        [.zero, .one],
        [.one, .one]
    ])
    let validMatrix = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero],
        [.zero, .zero, .zero, .one],
        [.zero, .zero, .one, .zero]
    ])
    let validQubitCount = 3
    let extendedValidQubitCount = 6
    let validInputs = [2, 1]
    let extendedValidInputs = [5, 2, 1]

    // MARK: - Tests

    func testGateControlledWithGateThatThrowException_extractComponents_throwException() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: nonUnitaryMatrix, inputs: [0]),
                                   controls: [1])
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // Then
        var error: GateError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
    }

    func testGateControlledWithEmptyControls_extractComponents_throwException() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: validMatrix, inputs: validInputs),
                                   controls: [])
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // Then
        var error: GateError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateControlsCanNotBeAnEmptyList)
    }

    func testGateOracleWithEmptyControls_extractComponents_throwException() {
        // Given
        let gate = Gate.oracle(truthTable: [""], controls: [], target: 0)
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // Then
        var error: GateError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateControlsCanNotBeAnEmptyList)
    }

    func testGateControlledWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.controlled(gate: .not(target: 1), controls: [2])
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // When
        var matrix: AnySimulatorControlledMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(matrix?.controlCount, 1)
        XCTAssertEqual(matrix?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
        XCTAssertEqual(matrix?.count, 4)
        XCTAssertEqual(inputs, validInputs)
    }

    func testGateControlledWithNotGateAndTwoControls_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.controlled(gate: .not(target: 1), controls: [5, 2])
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // When
        var matrix: AnySimulatorControlledMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(matrix?.controlCount, 2)
        XCTAssertEqual(matrix?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
        XCTAssertEqual(matrix?.count, 8)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    func testTwoGatesControlledWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.controlled(gate: .controlled(gate: .not(target: 1), controls: [2]),
                                   controls: [5])
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)

        // When
        var matrix: AnySimulatorControlledMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(matrix?.controlCount, 2)
        XCTAssertEqual(matrix?.controlledCountableMatrix.expandedRawMatrix(), Matrix.makeNot())
        XCTAssertEqual(matrix?.count, 8)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    static var allTests = [
        ("testGateControlledWithGateThatThrowException_extractComponents_throwException",
         testGateControlledWithGateThatThrowException_extractComponents_throwException),
        ("testGateControlledWithEmptyControls_extractComponents_throwException",
         testGateControlledWithEmptyControls_extractComponents_throwException),
        ("testGateOracleWithEmptyControls_extractComponents_throwException",
         testGateOracleWithEmptyControls_extractComponents_throwException),
        ("testGateControlledWithNotGate_extractComponents_returnExpectedValues",
         testGateControlledWithNotGate_extractComponents_returnExpectedValues),
        ("testGateControlledWithNotGateAndTwoControls_extractComponents_returnExpectedValues",
         testGateControlledWithNotGateAndTwoControls_extractComponents_returnExpectedValues),
        ("testTwoGatesControlledWithNotGate_extractComponents_returnExpectedValues",
         testTwoGatesControlledWithNotGate_extractComponents_returnExpectedValues)
    ]
}
