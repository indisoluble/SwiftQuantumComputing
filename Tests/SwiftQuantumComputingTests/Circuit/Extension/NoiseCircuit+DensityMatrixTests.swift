//
//  NoiseCircuit+DensityMatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/08/2021.
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

class NoiseCircuit_DensityMatrixTests: XCTestCase {

    // MARK: - Properties

    let circuit = NoiseCircuitTestDouble()

    // MARK: - Tests

    func testEmptyCircuit_densityMatrix_produceExpectedMatrix() {
        // Given
        circuit.quantumOperatorsResult = []

        // When
        _ = circuit.densityMatrix()

        // Then
        let expectedInitialDensityMatrix = try! Matrix([[.one, .zero], [.zero, .zero]])

        XCTAssertEqual(circuit.quantumOperatorsCount, 1)
        XCTAssertEqual(circuit.circuitDensityMatrixCount, 1)
        XCTAssertEqual(circuit.lastCircuitDensityMatrixInitialState?.densityMatrix,
                       expectedInitialDensityMatrix)
    }

    func testCircuitWithKnownQubitCount_densityMatrix_produceExpectedMatrix() {
        // Given
        let gates = [Gate.not(target: 0).quantumOperator, Gate.hadamard(target: 2).quantumOperator]

        circuit.quantumOperatorsResult = gates

        // When
        _ = circuit.densityMatrix()

        // Then
        let expectedInitialDensityMatrix = try! Matrix([
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
        ])

        XCTAssertEqual(circuit.quantumOperatorsCount, 1)
        XCTAssertEqual(circuit.circuitDensityMatrixCount, 1)
        XCTAssertEqual(circuit.lastCircuitDensityMatrixInitialState?.densityMatrix,
                       expectedInitialDensityMatrix)
    }

    static var allTests = [
        ("testEmptyCircuit_densityMatrix_produceExpectedMatrix",
         testEmptyCircuit_densityMatrix_produceExpectedMatrix),
        ("testCircuitWithKnownQubitCount_densityMatrix_produceExpectedMatrix",
         testCircuitWithKnownQubitCount_densityMatrix_produceExpectedMatrix)
    ]
}
