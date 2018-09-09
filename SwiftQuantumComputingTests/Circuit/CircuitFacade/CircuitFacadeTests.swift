//
//  CircuitFacadeTests.swift
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

class CircuitFacadeTests: XCTestCase {

    // MARK: - Properties

    let register = CircuitRegisterTestDouble()
    let factory = CircuitRegisterGateFactoryTestDouble()
    let circuitDescription = CircuitDescriptionTestDouble()
    let matrix = Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                         [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])!
    let describer = CircuitGateDescribableTestDouble()

    // MARK: - Tests

    func testAnyCircuit_qubitCount_forwardCallToRegister() {
        // Given
        let expectedQubitCount = 10
        register.qubitCountResult = expectedQubitCount
        
        let circuit = CircuitFacade(register: register,
                                    factory: factory,
                                    circuitDescription: circuitDescription)

        // When
        let qubitCount = circuit.qubitCount

        // Then
        XCTAssertEqual(register.qubitCountCount, 1)
        XCTAssertEqual(qubitCount, expectedQubitCount)
    }

    func testCircuitWithFactoryThatReturnNil_applyingGate_returnNil() {
        // Given
        factory.makeGateResult = nil

        let circuit = CircuitFacade(register: register,
                                    factory: factory,
                                    circuitDescription: circuitDescription)

        let gate = CircuitGate(matrix: matrix, describer: describer)
        let inputs = [0, 1]

        // When
        let nextCircuit = circuit.applyingGate(gate, inputs: inputs)

        // Then
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertEqual(circuitDescription.applyingDescriberCount, 0)
        XCTAssertNil(nextCircuit)
    }

    func testCircuitWithRegisterThatReturnNil_applyingGate_returnNil() {
        // Given
        let registerGate = RegisterGate(matrix: matrix)!
        factory.makeGateResult = registerGate

        register.applyingResult = nil

        let circuit = CircuitFacade(register: register,
                                    factory: factory,
                                    circuitDescription: circuitDescription)

        let gate = CircuitGate(matrix: matrix, describer: describer)
        let inputs = [0, 1]

        // When
        let nextCircuit = circuit.applyingGate(gate, inputs: inputs)

        // Then
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(circuitDescription.applyingDescriberCount, 0)
        XCTAssertNil(nextCircuit)
    }

    func testAnyCircuit_applyingGate_executeExpectedMethodsOnDependenciesAndReturnExpectedData() {
        // Given
        let registerGate = RegisterGate(matrix: matrix)!
        factory.makeGateResult = registerGate

        let nextRegister = CircuitRegisterTestDouble()
        register.applyingResult = nextRegister

        let nextDescription = CircuitDescriptionTestDouble()
        circuitDescription.applyingDescriberResult = nextDescription

        let circuit = CircuitFacade(register: register,
                                    factory: factory,
                                    circuitDescription: circuitDescription)

        let gate = CircuitGate(matrix: matrix, describer: describer)
        let inputs = [0, 1]

        // When
        let nextCircuit = circuit.applyingGate(gate, inputs: inputs)

        // Then
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertEqual(circuitDescription.applyingDescriberCount, 1)
        let lastApplyingDescriberDescriber = circuitDescription.lastApplyingDescriberDescriber as? CircuitGateDescribableTestDouble
        XCTAssertTrue(lastApplyingDescriberDescriber === describer)
        XCTAssertEqual(circuitDescription.lastApplyingDescriberInputs, inputs)
        let resultRegister = nextCircuit?.register as? CircuitRegisterTestDouble
        XCTAssertTrue(resultRegister === nextRegister)
        let resultFactory = nextCircuit?.factory as? CircuitRegisterGateFactoryTestDouble
        XCTAssertTrue(resultFactory === factory)
        let resultCircuitDescription = nextCircuit?.circuitDescription as? CircuitDescriptionTestDouble
        XCTAssertTrue(resultCircuitDescription === nextDescription)
    }

    func testAnyCircuit_measure_forwardCallToRegisterAndReturnExpectedData() {
        // Given
        let expectedMeasures = [Double(10), Double(20)]
        register.measureResult = expectedMeasures

        let circuit = CircuitFacade(register: register,
                                    factory: factory,
                                    circuitDescription: circuitDescription)

        let qubits = [0, 1]

        // When
        let measures = circuit.measure(qubits: qubits[0], qubits[1])

        // Then
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(register.lastMeasureQubits, qubits)
        XCTAssertEqual(measures, expectedMeasures)
    }
}
