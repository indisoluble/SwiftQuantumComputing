//
//  TwoLevelDecompositionSolverTests.swift
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class TwoLevelDecompositionSolverTests: XCTestCase {

    // MARK: - Tests

    func testGateThatThrowsError_decomposeGate_throwError() {
        // Given
        let gateWithRepeatedInputs = Gate.matrix(matrix: Matrix.makeNot(), inputs: [0, 0])
        let qubitCount = 2

        // Then
        var error: GateError?
        if case .failure(let e) = TwoLevelDecompositionSolver.decomposeGate(gateWithRepeatedInputs,
                                                                            restrictedToCircuitQubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateInputsAreNotUnique)
    }

    func testSingleQubitGate_decomposeGate_returnSameGate() {
        // Given
        let gate = Gate.not(target: 0)
        let qubitCount = 2

        // When
        let result = try? TwoLevelDecompositionSolver.decomposeGate(gate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testTwoQubitControlledGate_decomposeGate_returnSameGate() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: .makeNot(), inputs: [0]), controls: [1])
        let qubitCount = 5

        // When
        let result = try? TwoLevelDecompositionSolver.decomposeGate(gate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testTwoQubitOracleGate_decomposeGate_returnExpectedGates() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"], controls: [1], gate: .matrix(matrix: .makeNot(), inputs: [0]))
        let qubitCount = 5

        // When
        let result = try? TwoLevelDecompositionSolver.decomposeGate(gate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

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
        let qubitCount = 10

        // When
        let result = try? TwoLevelDecompositionSolver.decomposeGate(gate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        XCTAssertEqual(result, [gate])
    }

    func testMultiQubitOracleGate_decomposeGate_returnExpectedGates() {
        // Given
        let gate = Gate.oracle(truthTable: ["10100"],
                               controls: [8, 9, 1, 5, 2],
                               gate: .matrix(matrix: .makeNot(), inputs: [4]))
        let qubitCount = 10

        // When
        let result = try? TwoLevelDecompositionSolver.decomposeGate(gate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

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
        let circuitFactory = MainCircuitFactory()
        let qubitCount = 2

        let gates: [Gate] = [
            .phaseShift(radians: 0.1, target: 0),
            .phaseShift(radians: 0.4, target: 1)
        ]
        let matrix = try! circuitFactory.makeCircuit(gates: gates).unitary().get()
        let almostControlledGate = Gate.matrix(matrix: matrix, inputs: [1, 0])
        let unitary = try! circuitFactory.makeCircuit(gates: [almostControlledGate]).unitary(withQubitCount: qubitCount).get()

        // When
        let result = try! TwoLevelDecompositionSolver.decomposeGate(almostControlledGate,
                                                                    restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        let expectedUnitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()

        XCTAssertEqual(expectedUnitary, unitary)
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
         testAlmostControlledGate_decomposeGate_returnGatesThatProduceSameUnitary)
    ]
}
