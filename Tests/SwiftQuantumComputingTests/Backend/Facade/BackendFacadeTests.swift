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

    let registerFactory = BackendRegisterFactoryTestDouble()
    let gateFactory = BackendRegisterGateFactoryTestDouble()
    let inputBits = "000"
    let register = BackendRegisterTestDouble()
    let firstGate = BackendGateTestDouble()
    let secondGate = BackendGateTestDouble()
    let thirdGate = BackendGateTestDouble()
    let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                              [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])
    let qubits = [0, 1, 2]
    let measurement = [0.1, 0.9]

    // MARK: - Tests

    func testRegisterFactoryThrowsError_measureQubits_throwError() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        // Then
        XCTAssertThrowsError(try backend.measure(qubits: qubits,
                                                 in: (inputBits: inputBits, gates: [firstGate])))
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_measureQubits_applyMeasureOnInitialRegister() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register
        register.measureResult = measurement

        // When
        let result = try? backend.measure(qubits: qubits, in: (inputBits: inputBits, gates: []))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(register.lastMeasureQubits, qubits)
        XCTAssertEqual(result, measurement)
    }

    func testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_measureQubits_applyMeasureOnInitialRegister() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register
        register.measureResult = measurement

        // When
        let result = try? backend.measure(qubits: qubits,
                                          in: (inputBits: inputBits, gates: [firstGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertNil(result)
    }

    func testRegisterFactoryReturnsRegisterAndOneGate_measureQubits_applyMeasureOnExpectedRegister() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        let registerGate = try! RegisterGate(matrix: matrix)
        gateFactory.makeGateResult = registerGate

        let nextRegister = BackendRegisterTestDouble()
        register.applyingResult = nextRegister

        nextRegister.measureResult = measurement

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? backend.measure(qubits: qubits,
                                          in: (inputBits: inputBits, gates: [firstGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertEqual(nextRegister.measureCount, 1)
        XCTAssertEqual(nextRegister.lastMeasureQubits, qubits)
        XCTAssertEqual(result, measurement)
    }

    func testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        firstGate.extractMatrixResult = nil
        firstGate.extractInputsResult = [0, 2]

        // When
        let result = try? backend.measure(qubits: qubits,
                                          in: (inputBits: inputBits, gates: [firstGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testGateFactoryReturnsNilAndOneGate_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        gateFactory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? backend.measure(qubits: qubits,
                                          in: (inputBits: inputBits, gates: [firstGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testRegisterReturnsNilAndOneGate_measureQubits_returnNil() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        let registerGate = try! RegisterGate(matrix: matrix)
        gateFactory.makeGateResult = registerGate

        register.applyingResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? backend.measure(qubits: qubits,
                                          in: (inputBits: inputBits, gates: [firstGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertNil(result)
    }

    func testGateFactoryReturnsNilAndThreeGates_measureQubits_secondAndThirdGatesAreNotUsed() {
        // Given
        let backend = BackendFacade(registerFactory: registerFactory, gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        gateFactory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        _ = try? backend.measure(qubits: qubits,
                                 in: (inputBits: inputBits,
                                      gates: [firstGate, secondGate, thirdGate]))

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(secondGate.extractCount, 0)
        XCTAssertEqual(thirdGate.extractCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
    }

    static var allTests = [
        ("testRegisterFactoryThrowsError_measureQubits_throwError",
         testRegisterFactoryThrowsError_measureQubits_throwError),
        ("testRegisterFactoryReturnsRegisterAndEmptyCircuit_measureQubits_applyMeasureOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndEmptyCircuit_measureQubits_applyMeasureOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_measureQubits_applyMeasureOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_measureQubits_applyMeasureOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndOneGate_measureQubits_applyMeasureOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndOneGate_measureQubits_applyMeasureOnExpectedRegister),
        ("testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_measureQubits_returnNil",
         testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_measureQubits_returnNil),
        ("testGateFactoryReturnsNilAndOneGate_measureQubits_returnNil",
         testGateFactoryReturnsNilAndOneGate_measureQubits_returnNil),
        ("testRegisterReturnsNilAndOneGate_measureQubits_returnNil",
         testRegisterReturnsNilAndOneGate_measureQubits_returnNil),
        ("testGateFactoryReturnsNilAndThreeGates_measureQubits_secondAndThirdGatesAreNotUsed",
         testGateFactoryReturnsNilAndThreeGates_measureQubits_secondAndThirdGatesAreNotUsed)
    ]
}
