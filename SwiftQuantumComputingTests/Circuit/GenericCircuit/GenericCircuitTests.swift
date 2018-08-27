//
//  GenericCircuitTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 23/08/2018.
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

class GenericCircuitTests: XCTestCase {

    // MARK: - Properties

    let register = CircuitRegisterTestDouble()
    let factory = CircuitGateFactoryTestDouble()

    // MARK: - Tests

    func testAnyGenericCircuit_qubitCount_forwardCallToRegister() {
        // Given
        let expectedQubitCount = 10
        register.qubitCountResult = expectedQubitCount
        
        let circuit = GenericCircuit(register: register, factory: factory)

        // When
        let qubitCount = circuit.qubitCount

        // Then
        XCTAssertEqual(register.qubitCountCount, 1)
        XCTAssertEqual(qubitCount, expectedQubitCount)
    }

    func testAnyGenericCircuit_applyingGate_executeExpectedMethodsOnDependenciesAndReturnExpectedData() {
        // Given
        let matrix = Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                             [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])!
        let gate = RegisterGate(matrix: matrix)!
        factory.makeGateResult = gate

        let nextRegister = CircuitRegisterTestDouble()
        register.applyingResult = nextRegister

        let circuit = GenericCircuit(register: register, factory: factory)

        let inputs = [0, 1]

        // When
        let nextCircuit = circuit.applyingGate(builtWith: matrix, inputs: inputs)

        // Then
        let expectedCircuit = GenericCircuit(register: nextRegister, factory: factory)

        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, gate)
        XCTAssertEqual(nextCircuit, expectedCircuit)
    }

    func testAnyGenericCircuit_measure_forwardCallToRegisterAndReturnExpectedData() {
        // Given
        let expectedMeasures = [Double(10), Double(20)]
        register.measureResult = expectedMeasures

        let circuit = GenericCircuit(register: register, factory: factory)

        let qubits = [0, 1]

        // When
        let measures = circuit.measure(qubits: qubits[0], qubits[1])

        // Then
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(register.lastMeasureQubits, qubits)
        XCTAssertEqual(measures, expectedMeasures)
    }
}
