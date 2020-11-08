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
            LineHorizontalCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            HadamardCircuitViewPosition(connected: .none).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testHadamardGateAndOnlyOneQubit_makeLayer_returnExpectedPosition() {
        // Given
        let qubitCount = 1
        let gate = Gate.hadamard(target: 0)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [HadamardCircuitViewPosition(connected: .none).any()]
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
            LineHorizontalCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .none).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .none, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            PhaseShiftCircuitViewPosition(radians: radians, connected: .none).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testRotationGateWithTargetOutOfRange_makeLayer_throwError() {
        // Given
        let axis = Gate.Axis.x
        let radians = 0.1
        let qubitCount = 3
        let gate = Gate.rotation(axis: axis, radians: radians, target: qubitCount)

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithOneOrMoreInputsOrControlsOutOfRange(gate: gate))
    }

    func testRotationGate_makeLayer_returnExpectedPositions() {
        // Given
        let axis = Gate.Axis.x
        let radians = 0.1
        let qubitCount = 3
        let gate = Gate.rotation(axis: axis, radians: radians, target: 1)

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            RotationCircuitViewPosition(axis: axis, radians: radians, connected: .none).any(),
            LineHorizontalCircuitViewPosition().any()
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
            NotCircuitViewPosition(connected: .none).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            NotCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            NotCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            NotCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            NotCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithMultipleControlsAndInputsOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [1, 5, 3]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [7, 8]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: true).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithMultipleControlsAndInputsBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [4, 8, 6]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [2, 1]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixTopCircuitViewPosition(connectedUp: true, showText: true).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithMultipleControlsInTheMiddleAndInputsAboveAndBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [4, 6, 5]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [2, 8]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithMultipleControlsInTheMiddleInputsAboveAndBelowAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [4, 6, 5]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [3, 7]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithInputBetweenControls_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 12
        let controls = [4, 6, 10]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [3, 7, 5]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .both, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .both, showText: true).any(),
            CrossedLinesCircuitViewPosition().any(),
            CrossedLinesCircuitViewPosition().any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithInputBetweenControlsAndNoGaps_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 11
        let controls = [4, 6, 8]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [3, 7, 5]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .both, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .both, showText: true).any(),
            OracleCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testOracleGateControllingMatrixWithMultipleControlsInTheMiddleInputsAboveAndBelowAndOneGapBetweenControls_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 10
        let controls = [4, 6]
        let gate = Gate.oracle(truthTable: [],
                               controls: controls,
                               gate: .matrix(matrix: matrix, inputs: [3, 7]))

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .both).any(),
            OracleCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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

    func testControlledMatrixGateWithRepeatedInputs_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [1, 1]), controls: [0])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithRepeatedInputs(gate: gate))
    }

    func testControlledMatrixGateWithRepeatedControls_makeLayer_throwException() {
        // Given
        let qubitCount = 3
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [0]), controls: [1, 1])

        // Then
        var error: DrawCircuitError?
        if case .failure(let e) = gate.makeLayer(qubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateWithRepeatedControls(gate: gate))
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
            LineHorizontalCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .up).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: true).any(),
            CrossedLinesCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: true).any(),
            ControlCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixTopCircuitViewPosition(connectedUp: true, showText: false).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixCircuitViewPosition(connected: .down, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixBottomCircuitViewPosition(connectedDown: true).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            LineHorizontalCircuitViewPosition().any(),
            MatrixCircuitViewPosition(connected: .up, showText: false).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithConsecutiveControlsInTheMiddle_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 21
        let inputs = [19, 18, 17, 11, 10, 9, 7, 6, 5, 3, 2, 1]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs),
                                   controls: [15, 14, 13])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            MatrixGapCircuitViewPosition(connected: .down).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
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
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: true, showText: true).any(),
            CrossedLinesCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .down).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndTwoControlsOnTop_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [1, 5, 3]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [7, 8])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            LineHorizontalCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: false).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: true, showText: true).any(),
            CrossedLinesCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .both).any(),
            ControlCircuitViewPosition(connected: .down).any()
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
            LineHorizontalCircuitViewPosition().any(),
            ControlCircuitViewPosition(connected: .up).any(),
            CrossedLinesCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: true).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testControlledMatrixGateWithMultipleInputsAndTwoControlsBelow_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 9
        let inputs = [3, 7, 5]
        let gate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: inputs), controls: [0, 1])

        // When
        let positions = try? gate.makeLayer(qubitCount: qubitCount).get()

        // Then
        let expectedPositions = [
            ControlCircuitViewPosition(connected: .up).any(),
            ControlCircuitViewPosition(connected: .both).any(),
            CrossedLinesCircuitViewPosition().any(),
            MatrixBottomCircuitViewPosition(connectedDown: true).any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixMiddleCircuitViewPosition().any(),
            MatrixGapCircuitViewPosition(connected: .none).any(),
            MatrixTopCircuitViewPosition(connectedUp: false, showText: true).any(),
            LineHorizontalCircuitViewPosition().any()
        ]
        XCTAssertEqual(positions, expectedPositions)
    }
}
