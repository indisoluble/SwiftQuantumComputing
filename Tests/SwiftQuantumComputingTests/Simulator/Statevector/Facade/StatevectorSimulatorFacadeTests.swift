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
    let inputBits = "000"
    let register = StatevectorRegisterTestDouble()
    let firstGate = SimulatorGateTestDouble()
    let firstRegister = StatevectorRegisterTestDouble()
    let secondGate = SimulatorGateTestDouble()
    let secondRegister = StatevectorRegisterTestDouble()
    let thirdGate = SimulatorGateTestDouble()
    let thirdRegister = StatevectorRegisterTestDouble()
    let statevector = try! Vector([Complex(0.1), Complex(0.9)])

    // MARK: - Tests

    func testRegisterFactoryThrowsError_statevector_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        // Then
        XCTAssertThrowsError(try simulator.statevector(afterInputting: inputBits, in: [firstGate]))
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
    }

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.statevectorResult = statevector

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertEqual(register.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterThrowsError_statevector_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register

        // Then
        XCTAssertThrowsError(try simulator.statevector(afterInputting: inputBits, in: [firstGate]))

        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 1)
        if let lastApplyingGate = register.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.statevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_statevector_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.statevectorResult = statevector

        // When
        let result = try? simulator.statevector(afterInputting: inputBits, in: [firstGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 1)
        if let lastApplyingGate = register.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.applyingCount, 0)
        XCTAssertEqual(firstRegister.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    func testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_statevector_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.applyingResult = secondRegister

        // Then
        XCTAssertThrowsError(try simulator.statevector(afterInputting: inputBits,
                                                       in: [firstGate, secondGate, thirdGate]))

        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 1)
        if let lastApplyingGate = register.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.applyingCount, 1)
        if let lastApplyingGate = firstRegister.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(secondRegister.applyingCount, 1)
        if let lastApplyingGate = secondRegister.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === thirdGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.statevectorCount, 0)
        XCTAssertEqual(firstRegister.statevectorCount, 0)
        XCTAssertEqual(secondRegister.statevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_statevector_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.applyingResult = secondRegister
        secondRegister.applyingResult = thirdRegister
        thirdRegister.statevectorResult = statevector

        // When
        let result = try? simulator.statevector(afterInputting: inputBits,
                                                in: [firstGate, secondGate, thirdGate])

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 1)
        if let lastApplyingGate = register.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.applyingCount, 1)
        if let lastApplyingGate = firstRegister.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(secondRegister.applyingCount, 1)
        if let lastApplyingGate = secondRegister.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === thirdGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.statevectorCount, 0)
        XCTAssertEqual(firstRegister.statevectorCount, 0)
        XCTAssertEqual(secondRegister.statevectorCount, 0)
        XCTAssertEqual(thirdRegister.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    static var allTests = [
        ("testRegisterFactoryThrowsError_statevector_throwError",
         testRegisterFactoryThrowsError_statevector_throwError),
        ("testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndEmptyCircuit_statevector_applyStatevectorOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndRegisterThrowsError_statevector_throwError",
         testRegisterFactoryReturnsRegisterAndRegisterThrowsError_statevector_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_statevector_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_statevector_applyStatevectorOnExpectedRegister),
        ("testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_statevector_throwError",
         testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_statevector_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_statevector_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_statevector_applyStatevectorOnExpectedRegister)
    ]
}
