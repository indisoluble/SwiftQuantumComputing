//
//  BackendFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/12/2018.
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

class BackendFacadeTests: XCTestCase {

    // MARK: - Properties

    let register = BackendRegisterTestDouble()
    let factory = BackendRegisterGateFactoryTestDouble()
    let firstGate = BackendGateTestDouble()
    let secondGate = BackendGateTestDouble()
    let thirdGate = BackendGateTestDouble()
    let matrix = Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                         [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])!
    let qubits = [0, 1, 2]
    let measurement = [0.1, 0.9]

    // MARK: - Tests

    func testAnyBackendAndEmptyCircuit_measureQubits_applyMeasureOnInitialRegister() {
        // Given
        let backend = BackendFacade(factory: factory)

        register.measureResult = measurement

        // When
        let result = backend.measure(qubits: qubits, in: (register: register, gates: []))

        // Then
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(register.lastMeasureQubits, qubits)
        XCTAssertEqual(result, measurement)
    }

    func testAnyBackendAndOneGate_measureQubits_applyMeasureOnExpectedRegister() {
        // Given
        let backend = BackendFacade(factory: factory)

        let registerGate = RegisterGate(matrix: matrix)
        factory.makeGateResult = registerGate

        let nextRegister = BackendRegisterTestDouble()
        register.applyingResult = nextRegister

        nextRegister.measureResult = measurement

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = backend.measure(qubits: qubits, in: (register: register, gates: [firstGate]))

        // Then
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertEqual(nextRegister.measureCount, 1)
        XCTAssertEqual(nextRegister.lastMeasureQubits, qubits)
        XCTAssertEqual(result, measurement)
    }

    func testAnyBackendAndGateReturnsMatrixToNil_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(factory: factory)

        firstGate.extractMatrixResult = nil
        firstGate.extractInputsResult = [0, 2]

        // When
        let result = backend.measure(qubits: qubits, in: (register: register, gates: [firstGate]))

        // Then
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(factory.makeGateCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testFactoryReturnsNilAndOneGate_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(factory: factory)

        factory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = backend.measure(qubits: qubits, in: (register: register, gates: [firstGate]))

        // Then
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testRegisterReturnsNilAndOneGate_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(factory: factory)

        let registerGate = RegisterGate(matrix: matrix)
        factory.makeGateResult = registerGate

        register.applyingResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = backend.measure(qubits: qubits, in: (register: register, gates: [firstGate]))

        // Then
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(factory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(factory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertNil(result)
    }

    func testFactoryReturnsNilAndThreeGates_measureQubits_secondAndThirdGatesAreNotUsed() {
        // Given
        let backend = BackendFacade(factory: factory)

        factory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        _ = backend.measure(qubits: qubits,
                            in: (register: register, gates: [firstGate, secondGate, thirdGate]))

        // Then
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(factory.makeGateCount, 1)
        XCTAssertEqual(secondGate.extractCount, 0)
        XCTAssertEqual(thirdGate.extractCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
    }
}
