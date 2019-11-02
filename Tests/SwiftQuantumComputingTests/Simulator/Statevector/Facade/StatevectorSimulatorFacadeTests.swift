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
    let initialStatevector = try! Vector([Complex(1), Complex(0), Complex(0), Complex(0),
                                          Complex(0), Complex(0), Complex(0), Complex(0)])
    let register = StatevectorRegisterTestDouble()
    let firstGate = SimulatorGateTestDouble()
    let firstRegister = StatevectorRegisterTestDouble()
    let secondGate = SimulatorGateTestDouble()
    let secondRegister = StatevectorRegisterTestDouble()
    let thirdGate = SimulatorGateTestDouble()
    let thirdRegister = StatevectorRegisterTestDouble()
    let statevector = try! Vector([Complex(0.1), Complex(0.9)])

    // MARK: - Tests

    func testRegisterFactoryThrowsError_apply_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        // Then
        XCTAssertThrowsError(try simulator.apply(circuit: [firstGate], to: initialStatevector))
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
    }

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_apply_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.statevectorResult = statevector

        // When
        let result = try? simulator.apply(circuit: [], to: initialStatevector)

        // Then
        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 0)
        XCTAssertEqual(register.statevectorCount, 1)
        XCTAssertEqual(result, statevector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterThrowsError_apply_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register

        // Then
        XCTAssertThrowsError(try simulator.apply(circuit: [firstGate], to: initialStatevector))

        XCTAssertEqual(registerFactory.makeRegisterCount, 1)
        XCTAssertEqual(register.applyingCount, 1)
        if let lastApplyingGate = register.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.statevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_apply_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.statevectorResult = statevector

        // When
        let result = try? simulator.apply(circuit: [firstGate], to: initialStatevector)

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

    func testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_apply_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.applyingResult = secondRegister

        // Then
        XCTAssertThrowsError(try simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                                 to: initialStatevector))

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

    func testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_apply_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory)

        registerFactory.makeRegisterResult = register
        register.applyingResult = firstRegister
        firstRegister.applyingResult = secondRegister
        secondRegister.applyingResult = thirdRegister
        thirdRegister.statevectorResult = statevector

        // When
        let result = try? simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                          to: initialStatevector)

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
        ("testRegisterFactoryThrowsError_apply_throwError",
         testRegisterFactoryThrowsError_apply_throwError),
        ("testRegisterFactoryReturnsRegisterAndEmptyCircuit_apply_applyStatevectorOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndEmptyCircuit_apply_applyStatevectorOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndRegisterThrowsError_apply_throwError",
         testRegisterFactoryReturnsRegisterAndRegisterThrowsError_apply_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_apply_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_apply_applyStatevectorOnExpectedRegister),
        ("testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_apply_throwError",
         testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_apply_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_apply_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_apply_applyStatevectorOnExpectedRegister)
    ]
}
