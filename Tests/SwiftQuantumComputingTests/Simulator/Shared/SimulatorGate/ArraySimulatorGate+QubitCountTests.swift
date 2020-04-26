//
//  ArraySimulatorGate+QubitCountTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/11/2019.
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

class ArraySimulatorGate_QubitCountTests: XCTestCase {

    // MARK: - Properties

    let matrix = try! Matrix([
        [Complex.one, Complex.zero, Complex.zero, Complex.zero],
        [Complex.zero, Complex.one, Complex.zero, Complex.zero],
        [Complex.zero, Complex.zero, Complex.zero, Complex.one],
        [Complex.zero, Complex.zero, Complex.one, Complex.zero]
    ])
    let truthTable = [""]

    // MARK: - Tests

    func testEmptyCircuit_qubitCount_returnOne() {
        // Given
        let circuit: [SimulatorGate] = []

        // Then
        XCTAssertEqual(circuit.qubitCount(), 1)
    }

    func testCircuitWithSingleQubitGates_qubitCount_returnExpectedValue() {
        // Given
        let maxIndex = 10
        let circuit: [SimulatorGate] = [
            Gate.hadamard(target: 0),
            Gate.not(target: 2),
            Gate.phaseShift(radians: 0, target: 1),
            Gate.not(target: 2),
            Gate.hadamard(target: maxIndex),
            Gate.phaseShift(radians: 0, target: 5),
        ]

        // Then
        XCTAssertEqual(circuit.qubitCount(), maxIndex + 1)
    }

    func testCircuitWithMultiQubitGates_qubitCount_returnExpectedValue() {
        // Given
        let maxIndex = 10
        let circuit: [SimulatorGate] = [
            Gate.controlledMatrix(matrix: matrix, inputs: [1, 3, 6], control: 2),
            Gate.controlledNot(target: 0, control: 1),
            Gate.controlledNot(target: 1, control: 0),
            Gate.matrix(matrix: matrix, inputs: [1, 3, 6]),
            Gate.matrix(matrix: matrix, inputs: [6, 3, 1]),
            Gate.oracle(truthTable: truthTable, target: 2, controls: [maxIndex, 7]),
            Gate.oracle(truthTable: truthTable, target: 7, controls: [2])
        ]

        // Then
        XCTAssertEqual(circuit.qubitCount(), maxIndex + 1)
    }

    func testCircuitWithOnlyOneMatrixGateWithoutInputs_qubitCount_returnOne() {
        // Given
        let circuit: [SimulatorGate] = [Gate.matrix(matrix: matrix, inputs: [])]

        // Then
        XCTAssertEqual(circuit.qubitCount(), 1)
    }

    func testCircuitWithMatrixGateWithoutInputsAndOtherGates_qubitCount_returnExpectedValue() {
        // Given
        let maxIndex = 10
        let circuit: [SimulatorGate] = [
            Gate.matrix(matrix: matrix, inputs: []),
            Gate.oracle(truthTable: truthTable, target: 2, controls: [maxIndex, 7])
        ]

        // Then
        XCTAssertEqual(circuit.qubitCount(), maxIndex + 1)
    }

    func testCircuitWithOnlyOneOracleGateWithoutControls_qubitCount_returnExpectedValue() {
        // Given
        let maxIndex = 10
        let circuit: [SimulatorGate] = [
            Gate.oracle(truthTable: truthTable, target: maxIndex, controls: [])
        ]

        // Then
        XCTAssertEqual(circuit.qubitCount(), maxIndex + 1)
    }

    func testCircuitWithOnlyOneOracleGateWithoutControlsAndOtherGates_qubitCount_returnExpectedValue() {
        // Given
        let maxIndex = 10
        let circuit: [SimulatorGate] = [
            Gate.oracle(truthTable: truthTable, target: 2, controls: []),
            Gate.matrix(matrix: matrix, inputs: [1, maxIndex, 6])
        ]

        // Then
        XCTAssertEqual(circuit.qubitCount(), maxIndex + 1)
    }

    static var allTests = [
        ("testEmptyCircuit_qubitCount_returnOne",
         testEmptyCircuit_qubitCount_returnOne),
        ("testCircuitWithSingleQubitGates_qubitCount_returnExpectedValue",
         testCircuitWithSingleQubitGates_qubitCount_returnExpectedValue),
        ("testCircuitWithMultiQubitGates_qubitCount_returnExpectedValue",
         testCircuitWithMultiQubitGates_qubitCount_returnExpectedValue),
        ("testCircuitWithOnlyOneMatrixGateWithoutInputs_qubitCount_returnOne",
         testCircuitWithOnlyOneMatrixGateWithoutInputs_qubitCount_returnOne),
        ("testCircuitWithMatrixGateWithoutInputsAndOtherGates_qubitCount_returnExpectedValue",
         testCircuitWithMatrixGateWithoutInputsAndOtherGates_qubitCount_returnExpectedValue),
        ("testCircuitWithOnlyOneOracleGateWithoutControls_qubitCount_returnExpectedValue",
         testCircuitWithOnlyOneOracleGateWithoutControls_qubitCount_returnExpectedValue),
        ("testCircuitWithOnlyOneOracleGateWithoutControlsAndOtherGates_qubitCount_returnExpectedValue",
         testCircuitWithOnlyOneOracleGateWithoutControlsAndOtherGates_qubitCount_returnExpectedValue)
    ]
}
