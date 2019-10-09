//
//  StatevectorSimulatorFacadeTests.swift
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

class StatevectorSimulatorFacadeTests: XCTestCase {

    // MARK: - Properties

    let registerFactory = StatevectorRegisterFactoryTestDouble()
    let gateFactory = StatevectorRegisterGateFactoryTestDouble()
    let inputBits = "000"
    let register = StatevectorRegisterTestDouble()
    let firstGate = StatevectorGateTestDouble()
    let secondGate = StatevectorGateTestDouble()
    let thirdGate = StatevectorGateTestDouble()
    let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                              [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])
    let statevector = try! Vector([Complex(0.1), Complex(0.9)])

    // MARK: - Tests

    func testRegisterFactoryThrowsError_statevector_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        // Then
        XCTAssertThrowsError(try simulator.statevector(afterInputting: inputBits, in: [firstGate]))
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register
        register.statevectorResult = statevector

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    func testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_statevector_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register
        register.statevectorResult = statevector

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertEqual(register.statevectorCount, 0)
        XCTAssertNil(result)
    }

    func testRegisterFactoryReturnsRegisterAndOneGate_statevector_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        let registerGate = try! RegisterGate(matrix: matrix)
        gateFactory.makeGateResult = registerGate

        let nextRegister = StatevectorRegisterTestDouble()
        register.applyingResult = nextRegister

        nextRegister.statevectorResult = statevector

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 1)
        XCTAssertEqual(register.lastApplyingGate, registerGate)
        XCTAssertEqual(nextRegister.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    func testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_statevector_returnNil() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        firstGate.extractMatrixResult = nil
        firstGate.extractInputsResult = [0, 2]

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testGateFactoryReturnsNilAndOneGate_statevector_returnNil() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        gateFactory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertNil(result)
    }

    func testRegisterReturnsNilAndOneGate_statevector_returnNil() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        let registerGate = try! RegisterGate(matrix: matrix)
        gateFactory.makeGateResult = registerGate

        register.applyingResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

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

    func testGateFactoryReturnsNilAndThreeGates_statevector_secondAndThirdGatesAreNotUsed() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   gateFactory: gateFactory)

        registerFactory.makeRegisterResult = register

        gateFactory.makeGateResult = nil

        let inputs = [0, 2]
        firstGate.extractMatrixResult = matrix
        firstGate.extractInputsResult = inputs

        // When
        _ = try? simulator.statevector(afterInputting: inputBits,
                                       in: [firstGate, secondGate, thirdGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(firstGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(secondGate.extractCount, 0)
        XCTAssertEqual(thirdGate.extractCount, 0)
        XCTAssertEqual(register.applyingCount, 0)
    }

    static var allTests = [
        ("testRegisterFactoryThrowsError_statevector_throwError",
         testRegisterFactoryThrowsError_statevector_throwError),
        ("testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_statevector_applyStatevectorOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndOneGateUnableToExtractMatrix_statevector_applyStatevectorOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndOneGate_statevector_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndOneGate_statevector_applyStatevectorOnExpectedRegister),
        ("testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_statevector_returnNil",
         testRegisterFactoryReturnsRegisterAndGateReturnsMatrixToNil_statevector_returnNil),
        ("testGateFactoryReturnsNilAndOneGate_statevector_returnNil",
         testGateFactoryReturnsNilAndOneGate_statevector_returnNil),
        ("testRegisterReturnsNilAndOneGate_statevector_returnNil",
         testRegisterReturnsNilAndOneGate_statevector_returnNil),
        ("testGateFactoryReturnsNilAndThreeGates_statevector_secondAndThirdGatesAreNotUsed",
         testGateFactoryReturnsNilAndThreeGates_statevector_secondAndThirdGatesAreNotUsed)
    ]
}
