//
//  TwoLevelDecompositionSolverFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/10/2020.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class TwoLevelDecompositionSolverFacadeTests: XCTestCase {

    // MARK: - Properties

    let dummySut = TwoLevelDecompositionSolverFacade(singleQubitGateDecomposer: DummySingleQubitGateDecompositionSolver())
    let cosSinSut = TwoLevelDecompositionSolverFacade(singleQubitGateDecomposer: CosineSineDecompositionSolver())

    // MARK: - Tests

    func testGateThatThrowsError_decomposeGate_throwError() {
        // Given
        let gateWithRepeatedInputs = Gate.matrix(matrix: Matrix.makeNot(), inputs: [0, 0])

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = dummySut.decomposeGate(gateWithRepeatedInputs) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputsAreNotUnique)
    }

    func testSingleQubitGate_decomposeGate_returnSameGate() {
        // Given
        let gate = Gate.not(target: 0)

        // When
        let result = try? dummySut.decomposeGate(gate).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testTwoQubitControlledGate_decomposeGate_returnSameGate() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: .makeNot(), inputs: [0]), controls: [1])

        // When
        let result = try? dummySut.decomposeGate(gate).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testTwoQubitOracleGate_decomposeGate_returnExpectedGates() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"],
                               controls: [1],
                               gate: .matrix(matrix: .makeNot(), inputs: [0]))

        // When
        let result = try? dummySut.decomposeGate(gate).get()

        // Then
        let expectedResult: [Gate] = [
            .not(target: 1),
            .controlled(gate: .matrix(matrix: .makeNot(), inputs: [0]), controls: [1]),
            .not(target: 1)
        ]
        XCTAssertEqual(result, expectedResult)
    }

    func testMultiQubitControlledGate_decomposeGate_returnSameGate() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: .makeNot(), inputs: [4]),
                                   controls: [8, 9, 1, 5, 2])

        // When
        let result = try? dummySut.decomposeGate(gate).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testMultiQubitOracleGate_decomposeGate_returnExpectedGates() {
        // Given
        let gate = Gate.oracle(truthTable: ["10100"],
                               controls: [8, 9, 1, 5, 2],
                               gate: .matrix(matrix: .makeNot(), inputs: [4]))

        // When
        let result = try? dummySut.decomposeGate(gate).get()

        // Then
        let expectedResult: [Gate] = [
            .not(target: 9),
            .not(target: 5),
            .not(target: 2),
            .controlled(gate: .matrix(matrix: .makeNot(), inputs: [4]), controls: [8, 9, 1, 5, 2]),
            .not(target: 9),
            .not(target: 5),
            .not(target: 2)
        ]
        XCTAssertEqual(result, expectedResult)
    }

    func testAlmostControlledGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        // matrix = [.phaseShift(radians: 0.1, target: 0), .phaseShift(radians: 0.4, target: 1)]
        let unitary = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, Complex(0.9950041652780257, 0.09983341664682815), .zero, .zero],
            [.zero, .zero, Complex(0.9210609940028851, 0.3894183423086505), .zero],
            [.zero, .zero, .zero, Complex(0.8775825618903728, 0.479425538604203)]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testAlmostControlledGateWithNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [-.one, .zero, .zero, .zero],
            [.zero, Complex(-0.9950041652780257, 0.09983341664682815), .zero, .zero],
            [.zero, .zero, Complex(0.9210609940028851, -0.3894183423086505), .zero],
            [.zero, .zero, .zero, Complex(-0.8775825618903728, -0.479425538604203)]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixWithNonZeroValuesOnePositionToTheRight_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [.zero, .one, .zero, .zero],
            [.zero, .zero, Complex(0.9950041652780257, 0.09983341664682815), .zero],
            [.zero, .zero, .zero, Complex(0.9210609940028851, 0.3894183423086505)],
            [Complex(0.8775825618903728, 0.479425538604203), .zero, .zero, .zero]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixWithNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [.zero, .zero, .zero, .one],
            [Complex(0.9950041652780257, 0.09983341664682815), .zero, .zero, .zero],
            [.zero, Complex(0.9210609940028851, 0.3894183423086505), .zero, .zero],
            [.zero, .zero, Complex(0.8775825618903728, 0.479425538604203), .zero]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixWithAlmostAllNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [Complex(0.9950041652780257, 0.09983341664682815), .zero, .zero, .zero],
            [.zero, Complex(0.9210609940028851, 0.3894183423086505), .zero, .zero],
            [.zero, .zero, Complex(0.8775825618903728, 0.479425538604203), .zero],
            [.zero, .zero, .zero, .one],
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixWithOppositeDiagonalPopulated_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [.zero, .zero, .zero, .one],
            [.zero, .zero, Complex(0.9950041652780257, 0.09983341664682815), .zero],
            [.zero, Complex(0.9210609940028851, 0.3894183423086505), .zero, .zero],
            [Complex(0.8775825618903728, 0.479425538604203), .zero, .zero, .zero]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMatrixWithOppositeDiagonalPopulatedAndNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        let unitary = try! Matrix([
            [.zero, .zero, .zero, -.one],
            [.zero, .zero, Complex(-0.9950041652780257, 0.09983341664682815), .zero],
            [.zero, Complex(0.9210609940028851, -0.3894183423086505), .zero, .zero],
            [Complex(-0.8775825618903728, -0.479425538604203), .zero, .zero, .zero]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(unitary, dummyUnitary)
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testMoreDenselyPopulatedMatrix_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        // matrix = [.hadamard(target: 0), .phaseShift(radians: 0.4, target: 1)]
        let unitary = try! Matrix([
            [Complex(0.7071067811865475, 0.0), Complex(0.7071067811865475, 0.0), .zero, .zero],
            [Complex(0.7071067811865475, 0.0), Complex(-0.7071067811865475, 0.0), .zero, .zero],
            [.zero, .zero, Complex(0.6512884747458619, 0.27536035056487096), Complex(0.6512884747458619, 0.27536035056487096)],
            [.zero, .zero, Complex(0.6512884747458619, 0.27536035056487096), Complex(-0.6512884747458619, -0.27536035056487096)]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertTrue(unitary.isApproximatelyEqual(to: dummyUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testHadamardMatrix_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let qubitCount = 2
        // matrix = [.hadamard(target: 0), .hadamard(target: 1)]
        let unitary = try! Matrix([
            [Complex(0.4999999999999999, 0.0), Complex(0.4999999999999999, 0.0),
             Complex(0.4999999999999999, 0.0), Complex(0.4999999999999999, 0.0)],
            [Complex(0.4999999999999999, 0.0), Complex(-0.4999999999999999, 0.0),
             Complex(0.4999999999999999, 0.0), Complex(-0.4999999999999999, 0.0)],
            [Complex(0.4999999999999999, 0.0), Complex(0.4999999999999999, 0.0),
             Complex(-0.4999999999999999, 0.0), Complex(-0.4999999999999999, 0.0)],
            [Complex(0.4999999999999999, 0.0), Complex(-0.4999999999999999, 0.0),
             Complex(-0.4999999999999999, 0.0), Complex(0.4999999999999999, 0.0)]
        ])
        let gate = Gate.matrix(matrix: unitary, inputs: [1, 0])

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let circuitFactory = MainCircuitFactory()
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertTrue(unitary.isApproximatelyEqual(to: dummyUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testHadamardMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let circuitFactory = MainCircuitFactory()

        let gates: [Gate] = [
            .hadamard(target: 0),
            .hadamard(target: 1)
        ]
        let matrix = try! circuitFactory.makeCircuit(gates: gates).unitary().get()

        let qubitCount = 3
        let gate = Gate.matrix(matrix: matrix, inputs: [2, 0])
        let unitary = try! circuitFactory.makeCircuit(gates: [gate]).unitary(withQubitCount: qubitCount).get()

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertTrue(unitary.isApproximatelyEqual(to: dummyUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testHadamardPhaseShiftMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let circuitFactory = MainCircuitFactory()

        let gates: [Gate] = [
            .hadamard(target: 0),
            .phaseShift(radians: 0.4, target: 1)
        ]
        let matrix = try! circuitFactory.makeCircuit(gates: gates).unitary().get()

        let qubitCount = 3
        let gate = Gate.matrix(matrix: matrix, inputs: [2, 0])
        let unitary = try! circuitFactory.makeCircuit(gates: [gate]).unitary(withQubitCount: qubitCount).get()

        // When
        let dummyResult = try! dummySut.decomposeGate(gate,
                                                      restrictedToCircuitQubitCount: qubitCount).get()
        let cosSinResult = try! cosSinSut.decomposeGate(gate,
                                                        restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let dummyUnitary = try! circuitFactory.makeCircuit(gates: dummyResult).unitary(withQubitCount: qubitCount).get()
        let cosSinUnitary = try! circuitFactory.makeCircuit(gates: cosSinResult).unitary(withQubitCount: qubitCount).get()

        XCTAssertTrue(unitary.isApproximatelyEqual(to: dummyUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
        XCTAssertTrue(unitary.isApproximatelyEqual(to: cosSinUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    static var allTests = [
        ("testGateThatThrowsError_decomposeGate_throwError",
         testGateThatThrowsError_decomposeGate_throwError),
        ("testSingleQubitGate_decomposeGate_returnSameGate",
         testSingleQubitGate_decomposeGate_returnSameGate),
        ("testTwoQubitControlledGate_decomposeGate_returnSameGate",
         testTwoQubitControlledGate_decomposeGate_returnSameGate),
        ("testTwoQubitOracleGate_decomposeGate_returnExpectedGates",
         testTwoQubitOracleGate_decomposeGate_returnExpectedGates),
        ("testMultiQubitControlledGate_decomposeGate_returnSameGate",
         testMultiQubitControlledGate_decomposeGate_returnSameGate),
        ("testMultiQubitOracleGate_decomposeGate_returnExpectedGates",
         testMultiQubitOracleGate_decomposeGate_returnExpectedGates),
        ("testAlmostControlledGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testAlmostControlledGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testAlmostControlledGateWithNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary",
         testAlmostControlledGateWithNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMatrixWithNonZeroValuesOnePositionToTheRight_decomposeGate_returnGatesThatProduceSameUnitary",
         testMatrixWithNonZeroValuesOnePositionToTheRight_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMatrixWithNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary",
         testMatrixWithNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMatrixWithAlmostAllNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary",
         testMatrixWithAlmostAllNonZeroValuesOnePositionToTheLeft_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMatrixWithOppositeDiagonalPopulated_decomposeGate_returnGatesThatProduceSameUnitary",
         testMatrixWithOppositeDiagonalPopulated_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMatrixWithOppositeDiagonalPopulatedAndNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary",
         testMatrixWithOppositeDiagonalPopulatedAndNegativeValues_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testMoreDenselyPopulatedMatrix_decomposeGate_returnGatesThatProduceSameUnitary",
         testMoreDenselyPopulatedMatrix_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testHadamardMatrix_decomposeGate_returnGatesThatProduceSameUnitary",
         testHadamardMatrix_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testHadamardMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary",
         testHadamardMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testHadamardPhaseShiftMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary",
         testHadamardPhaseShiftMatrixInAThreeQubitCircuit_decomposeGate_returnGatesThatProduceSameUnitary)
    ]
}
