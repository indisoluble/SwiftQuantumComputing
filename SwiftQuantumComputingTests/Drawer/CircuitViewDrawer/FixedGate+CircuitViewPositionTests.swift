//
//  FixedGate+CircuitViewPositionTests.swift
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

class FixedGate_CircuitViewPositionTests: XCTestCase {

    // MARK: - Properties

    let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                              [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])

    // MARK: - Tests

    func testControlledNotGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = FixedGate.controlledNot(target: 1, control: 3)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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

    func testHadamardGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.hadamard(target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.hadamard,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testNotGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.not(target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testZeroQubitMatrixGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.matrix(matrix: matrix, inputs: [])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testSingleQubitMatrixGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.matrix(matrix: matrix, inputs: [1])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
        let gate = FixedGate.matrix(matrix: matrix, inputs: inputs)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixMiddleConnected,
            CircuitViewPosition.matrixMiddleUnconnected,
            CircuitViewPosition.matrixTop(inputs: inputs),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testPhaseShiftGate_makeLayer_returnExpectedPositions() {
        // Given
        let radians = 0.1
        let qubitCount = 3
        let gate = FixedGate.phaseShift(radians: radians, target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.phaseShift(radians: radians),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithoutControls_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.oracle(truthTable: [], target: 0, controls: [])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithTargetEqualToOneOfTheControls_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.oracle(truthTable: [], target: 0, controls: [0, 2])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithTargetOutOfRange_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = FixedGate.oracle(truthTable: [], target: qubitCount, controls: [0, 2])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlOnTopOfTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = FixedGate.oracle(truthTable: [], target: 1, controls: [3])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
        let gate = FixedGate.oracle(truthTable: [], target: 3, controls: [1])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
        let gate = FixedGate.oracle(truthTable: [], target: 5, controls: controls)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
        let gate = FixedGate.oracle(truthTable: [], target: 7, controls: controls)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
        let gate = FixedGate.oracle(truthTable: [], target: 1, controls: controls)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

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
}
