//
//  Gate+CircuitViewPositionTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 16/09/2018.
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

class Gate_CircuitViewPositionTests: XCTestCase {

    // MARK: - Properties

    let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                              [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])

    // MARK: - Tests

    func testControlledNotGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledNot(target: qubitCount, control: 3)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testControlledNotGateWithControlOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledNot(target: 1, control: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testControlledNotGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledNot(target: 1, control: 3)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlledNotUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledNotGateWithControlBelowTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledNot(target: 3, control: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlledNotDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testHadamardGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 3
        let gate = Gate.hadamard(target: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testHadamardGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = Gate.hadamard(target: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.hadamard,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testNotGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 3
        let gate = Gate.not(target: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testNotGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = Gate.not(target: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testZeroQubitMatrixGate_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.matrix(matrix: matrix, inputs: [])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithEmptyInputList(gate: gate))
    }

    func testSingleQubitMatrixGateWithInputOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 3
        let gate = Gate.matrix(matrix: matrix, inputs: [qubitCount])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testSingleQubitMatrixGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = Gate.matrix(matrix: matrix, inputs: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testMultiQubitMatrixGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 7
        let inputs = [1, 5, 3]
        let gate = Gate.matrix(matrix: matrix, inputs: inputs)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connected: false),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixTop(inputs: inputs, connected: false),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testPhaseShiftGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let radians = 0.1
        let qubitCount = 3
        let gate = Gate.phaseShift(radians: radians, target: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testPhaseShiftGate_makeLayer_returnExpectedPositions() {
        // Given
        let radians = 0.1
        let qubitCount = 3
        let gate = Gate.phaseShift(radians: radians, target: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.phaseShift(radians: radians),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithoutControls_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], target: 0, controls: [])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithEmptyInputList(gate: gate))
    }

    func testOracleGateWithTargetEqualToOneOfTheControls_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], target: 0, controls: [0, 2])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateTargetIsAlsoAControl(gate: gate))
    }

    func testOracleGateWithTargetOutOfRange_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], target: qubitCount, controls: [0, 2])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testOracleGateWithOneControlOnTopOfTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], target: 1, controls: [3])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlledNotUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracleDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlBelowTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], target: 3, controls: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracleUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlledNotDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [1, 7, 3]
        let gate = Gate.oracle(truthTable: [], target: 5, controls: controls)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracleBottom(connected: false),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.controlledNot,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.oracleTop(controls: controls, connected: false),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [1, 5, 3]
        let gate = Gate.oracle(truthTable: [], target: 7, controls: controls)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracleBottom(connected: false),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.oracleTop(controls: controls, connected: true),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlledNotDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [3, 7, 5]
        let gate = Gate.oracle(truthTable: [], target: 1, controls: controls)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlledNotUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracleBottom(connected: true),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.oracleTop(controls: controls, connected: false),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithoutInputs_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: [], control: 0)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithEmptyInputList(gate: gate))
    }

    func testControlledMatrixGateWithControlEqualToOneOfTheInputs_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: [0, 2], control: 0)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateControlIsAlsoAnInput(gate: gate))
    }

    func testControlledMatrixGateWithControlOutOfRange_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: [0, 2], control: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOutOfRange(gate: gate))
    }

    func testControlledMatrixGateWithOneInputOnTopOfControl_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: [3], control: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.matrixDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithOneInputBelowControl_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: [1], control: 3)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [1, 7, 3]
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: inputs, control: 5)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connected: false),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.control,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixTop(inputs: inputs, connected: false),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [1, 5, 3]
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: inputs, control: 7)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connected: false),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixTop(inputs: inputs, connected: true),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [3, 7, 5]
        let gate = Gate.controlledMatrix(matrix: matrix, inputs: inputs, control: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.matrixBottom(connected: true),
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixTop(inputs: inputs, connected: false),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }
}
