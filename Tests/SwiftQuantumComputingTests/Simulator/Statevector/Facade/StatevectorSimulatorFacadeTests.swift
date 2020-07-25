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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class StatevectorSimulatorFacadeTests: XCTestCase {

    // MARK: - Properties

    let registerFactory = StatevectorRegisterFactoryTestDouble()
    let statevectorFactory = CircuitStatevectorFactoryTestDouble()
    let initialCircuitStatevector = CircuitStatevectorTestDouble()
    let register = StatevectorRegisterTestDouble()
    let firstGate = SimulatorGateTestDouble()
    let firstRegister = StatevectorRegisterTestDouble()
    let secondGate = SimulatorGateTestDouble()
    let secondRegister = StatevectorRegisterTestDouble()
    let thirdGate = SimulatorGateTestDouble()
    let thirdRegister = StatevectorRegisterTestDouble()
    let statevector = try! Vector([Complex(0.1), Complex(0.9)])
    let finalStateVector = CircuitStatevectorTestDouble()

    // MARK: - Tests

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_applyState_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeRegisterStateResult = register
        register.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [], to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 0)
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
        XCTAssertTrue(result as AnyObject? === finalStateVector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeRegisterStateResult = register

        // Then
        var error: StatevectorError?
        if case .failure(let e) = simulator.apply(circuit: [firstGate],
                                                  to: initialCircuitStatevector) {
            error = e
        }
        XCTAssertEqual(error,
                       .gateThrowedError(gate: firstGate.gate,
                                         error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        if let lastApplyingGate = register.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_applyState_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeRegisterStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [firstGate], to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        if let lastApplyingGate = register.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
        XCTAssertTrue(result as AnyObject? === finalStateVector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegisterAndStatevectorFactoryThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeRegisterStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.measureResult = statevector

        statevectorFactory.makeStatevectorError = .vectorAdditionOfSquareModulusIsNotEqualToOne

        // Then
        var error: StatevectorError?
        if case .failure(let e) = simulator.apply(circuit: [firstGate],
                                                  to: initialCircuitStatevector) {
            error = e
        }
        XCTAssertEqual(error, .resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne)
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        if let lastApplyingGate = register.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
    }

    func testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        firstGate.gateResult = .hadamard(target: 0)
        secondGate.gateResult = .phaseShift(radians: 0, target: 0)
        thirdGate.gateResult = .not(target: 0)

        registerFactory.makeRegisterStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.simulatorApplyingResult = secondRegister

        // Then
        var error: StatevectorError?
        if case .failure(let e) = simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                                  to: initialCircuitStatevector) {
            error = e
        }
        XCTAssertEqual(error,
                       .gateThrowedError(gate: thirdGate.gate,
                                         error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        if let lastApplyingGate = register.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 1)
        if let lastApplyingGate = firstRegister.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(secondRegister.simulatorApplyingCount, 1)
        if let lastApplyingGate = secondRegister.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === thirdGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 0)
        XCTAssertEqual(secondRegister.measureCount, 0)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_applyState_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(registerFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeRegisterStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.simulatorApplyingResult = secondRegister
        secondRegister.simulatorApplyingResult = thirdRegister
        thirdRegister.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                          to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeRegisterStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        if let lastApplyingGate = register.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === firstGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 1)
        if let lastApplyingGate = firstRegister.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(secondRegister.simulatorApplyingCount, 1)
        if let lastApplyingGate = secondRegister.lastSimulatorApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === thirdGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 0)
        XCTAssertEqual(secondRegister.measureCount, 0)
        XCTAssertEqual(thirdRegister.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
        XCTAssertTrue(result as AnyObject? === finalStateVector)
    }

    static var allTests = [
        ("testRegisterFactoryReturnsRegisterAndEmptyCircuit_applyState_applyStatevectorOnInitialRegister",
         testRegisterFactoryReturnsRegisterAndEmptyCircuit_applyState_applyStatevectorOnInitialRegister),
        ("testRegisterFactoryReturnsRegisterAndRegisterThrowsError_applyState_throwError",
         testRegisterFactoryReturnsRegisterAndRegisterThrowsError_applyState_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_applyState_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_applyState_applyStatevectorOnExpectedRegister),
        ("testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegisterAndStatevectorFactoryThrowsError_applyState_throwError",
         testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegisterAndStatevectorFactoryThrowsError_applyState_throwError),
        ("testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_applyState_throwError",
         testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_applyState_throwError),
        ("testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_applyState_applyStatevectorOnExpectedRegister",
         testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_applyState_applyStatevectorOnExpectedRegister)
    ]
}
