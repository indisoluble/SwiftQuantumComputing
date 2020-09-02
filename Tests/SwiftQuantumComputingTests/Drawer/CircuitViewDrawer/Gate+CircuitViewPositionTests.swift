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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Gate_CircuitViewPositionTests: XCTestCase {

    // MARK: - Properties

    let matrix = try! Matrix([[.zero, Complex(imaginary:-1)], [.i, .zero]])

    // MARK: - Tests

    func testControlledNotGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .not(target: qubitCount), controls: [3])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
    }

    func testControlledNotGateWithControlOutOfRange_makeLayer_throwError() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .not(target: 1), controls: [qubitCount])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
    }

    func testControlledNotGate_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .not(target: 1), controls: [3])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.control(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledNotGateWithControlBelowTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .not(target: 3), controls: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.control(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .down),
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
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
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
            CircuitViewPosition.hadamard(connected: .none),
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
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
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
            CircuitViewPosition.not(connected: .none),
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
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
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
            CircuitViewPosition.matrix(connected: .none, showText: true),
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
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
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
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
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
            CircuitViewPosition.phaseShift(radians: radians, connected: .none),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithTargetEqualToOneOfTheControls_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], controls: [0, 2], gate: .not(target: 0))

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsAlsoControls(gate: gate))
    }

    func testOracleGateWithTargetOutOfRange_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], controls: [0, 2], gate: .not(target: qubitCount))

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
    }

    func testOracleGateWithoutControls_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = Gate.oracle(truthTable: [], controls: [], gate: .not(target: 0))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.not(connected: .none),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlOnTopOfTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], controls: [3], gate: .not(target: 1))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlOnTopOfTargetAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], controls: [2], gate: .not(target: 1))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not(connected: .up),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlBelowTarget_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], controls: [1], gate: .not(target: 3))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneControlBelowTargetAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.oracle(truthTable: [], controls: [1], gate: .not(target: 2))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.not(connected: .down),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithTwoControlsTargetInTheMiddleAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [6, 4]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 5))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithThreeControlsTargetInTheMiddleAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [6, 4, 3]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 5))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [1, 7, 3]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 5))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsMoreSeparatedAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 12
        let controls = [1, 10, 4]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 7))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMoreControlsAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [4, 1, 8, 3]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 6))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithEvenMoreControlsAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 12
        let controls = [10, 4, 1, 2, 9, 5]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 7))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithALotMoreControlsAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 15
        let controls = [1, 2, 6, 3, 11, 5, 7, 13, 12]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 9))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithALotMoreControlsAndMoreSeparatedAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 18
        let controls = [1, 2, 3, 6, 7, 8, 14, 15, 16]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 11))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithOneTooManyControlsAndMoreSeparatedAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 19
        let controls = [17, 16, 15, 9, 8, 7, 5, 3, 2, 1]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 12))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithTwoTooManyControlsAndMoreSeparatedAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 20
        let controls = [18, 17, 16, 10, 9, 8, 6, 5, 3, 2, 1]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 13))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithThreeTooManyControlsAndMoreSeparatedAndTargetInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 21
        let controls = [19, 18, 17, 11, 10, 9, 7, 6, 5, 3, 2, 1]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 14))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [1, 5, 3]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 7))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.not(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateWithMultipleControlsAndTargetBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let controls = [3, 7, 5]
        let gate = Gate.oracle(truthTable: [], controls: controls, gate: .not(target: 1))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .both),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.oracle(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithoutInputs_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: []), controls: [0])

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
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [0, 2]), controls: [0])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsAlsoControls(gate: gate))
    }

    func testControlledMatrixGateWithControlOutOfRange_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [0, 2]),
                                   controls: [qubitCount])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
    }

    func testControlledMatrixGateWithOneInputOnTopOfControl_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let inputs = [3]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.control(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.matrix(connected: .down, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithOneInputOnTopOfControlAndNoGap_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let inputs = [2]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.control(connected: .up),
            CircuitViewPosition.matrix(connected: .down, showText: true),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithOneInputBelowControl_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [1]), controls: [3])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix(connected: .up, showText: true),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.control(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithOneInputBelowControlAndNoGap_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [1]), controls: [2])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix(connected: .up, showText: true),
            CircuitViewPosition.control(connected: .down),
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithTwoInputsControlInTheMiddleAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [7, 5]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [6])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix(connected: .up, showText: false),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrix(connected: .down, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithThreeInputsNoGapsAndControlNextToTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [7, 4, 5]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [6])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixTop(connectedUp: true, showText: false),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrix(connected: .down, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithTwoInputsOneGapAndControlNextToTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [7, 4]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [6])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrix(connected: .down, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithThreeInputsNoGapsAndControlNextToBottom_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [7, 6, 4]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [5])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix(connected: .up, showText: false),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixBottom(connectedDown: true),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithTWoInputsOneGapAndControlNextToBottom_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [7, 4]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [5])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrix(connected: .up, showText: false),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [1, 7, 3]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [5])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsMoreSeparatedAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 12
        let inputs = [1, 10, 4]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [7])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMoreInputsAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let inputs = [4, 1, 8, 3]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [6])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithEvenMoreInputsAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 12
        let inputs = [10, 4, 1, 2, 9, 5]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [7])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithALotMoreInputsAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 15
        let inputs = [1, 2, 6, 3, 11, 5, 7, 13, 12]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [9])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithALotMoreInputsAndMoreSeparatedAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 18
        let inputs = [1, 2, 3, 6, 7, 8, 14, 15, 16]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [11])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithOneTooManyInputsAndMoreSeparatedAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 19
        let inputs = [17, 16, 15, 9, 8, 7, 5, 3, 2, 1]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [12])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithTwoTooManyInputsAndMoreSeparatedAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 20
        let inputs = [18, 17, 16, 10, 9, 8, 6, 5, 3, 2, 1]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [13])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithThreeTooManyInputsAndMoreSeparatedAndControlInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 21
        let inputs = [19, 18, 17, 11, 10, 9, 7, 6, 5, 3, 2, 1]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [14])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixGap(connected: .up),
            CircuitViewPosition.control(connected: .both),
            CircuitViewPosition.matrixGap(connected: .down),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [1, 5, 3]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [7])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.matrixBottom(connectedDown: false),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixTop(connectedUp: true, showText: true),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.control(connected: .down),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndControlBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [3, 7, 5]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.control(connected: .up),
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.matrixBottom(connectedDown: true),
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixMiddle,
            CircuitViewPosition.matrixGap(connected: .none),
            CircuitViewPosition.matrixTop(connectedUp: false, showText: true),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }


    // Test with only ONE qubit
    // 2 controls inside matrix and ONE gap between 2 controls
}
