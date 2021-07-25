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

    let registerFactory = StatevectorTimeEvolutionFactoryTestDouble()
    let statevectorFactory = CircuitStatevectorFactoryTestDouble()
    let initialCircuitStatevector = CircuitStatevectorTestDouble()
    let register = StatevectorTimeEvolutionTestDouble()
    let firstGate = Gate.hadamard(target: 0)
    let firstRegister = StatevectorTimeEvolutionTestDouble()
    let secondGate = Gate.phaseShift(radians: 0, target: 0)
    let secondRegister = StatevectorTimeEvolutionTestDouble()
    let thirdGate = Gate.not(target: 0)
    let thirdRegister = StatevectorTimeEvolutionTestDouble()
    let statevector = try! Vector([Complex(0.1), Complex(0.9)])
    let finalStateVector = CircuitStatevectorTestDouble()

    // MARK: - Tests

    func testRegisterFactoryReturnsRegisterAndEmptyCircuit_applyState_applyStatevectorOnInitialRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register
        register.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [], to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 0)
        XCTAssertEqual(register.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
        XCTAssertTrue(result as AnyObject? === finalStateVector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register

        // Then
        var error: StatevectorError?
        if case .failure(let e) = simulator.apply(circuit: [firstGate],
                                                  to: initialCircuitStatevector) {
            error = e
        }
        XCTAssertEqual(error,
                       .gateThrowedError(gate: firstGate,
                                         error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        XCTAssertTrue(register.lastSimulatorApplyingGate == firstGate)
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegister_applyState_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [firstGate], to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        XCTAssertTrue(register.lastSimulatorApplyingGate == firstGate)
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
        XCTAssertTrue(result as AnyObject? === finalStateVector)
    }

    func testRegisterFactoryReturnsRegisterAndRegisterReturnsAnotherRegisterAndStatevectorFactoryThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register
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
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        XCTAssertTrue(register.lastSimulatorApplyingGate == firstGate)
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevector)
    }

    func testRegisterFactoryReturnsRegisterRegisterReturnsSecondRegisterButSecondThrowsError_applyState_throwError() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.simulatorApplyingResult = secondRegister

        // Then
        var error: StatevectorError?
        if case .failure(let e) = simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                                  to: initialCircuitStatevector) {
            error = e
        }
        XCTAssertEqual(error,
                       .gateThrowedError(gate: thirdGate,
                                         error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        XCTAssertTrue(register.lastSimulatorApplyingGate == firstGate)
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 1)
        XCTAssertTrue(firstRegister.lastSimulatorApplyingGate == secondGate)
        XCTAssertEqual(secondRegister.simulatorApplyingCount, 1)
        XCTAssertTrue(secondRegister.lastSimulatorApplyingGate == thirdGate)
        XCTAssertEqual(register.measureCount, 0)
        XCTAssertEqual(firstRegister.measureCount, 0)
        XCTAssertEqual(secondRegister.measureCount, 0)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 0)
    }

    func testRegisterFactoryReturnsRegisterAndRegistersDoTheSame_applyState_applyStatevectorOnExpectedRegister() {
        // Given
        let simulator = StatevectorSimulatorFacade(timeEvolutionFactory: registerFactory,
                                                   statevectorFactory: statevectorFactory)

        registerFactory.makeTimeEvolutionStateResult = register
        register.simulatorApplyingResult = firstRegister
        firstRegister.simulatorApplyingResult = secondRegister
        secondRegister.simulatorApplyingResult = thirdRegister
        thirdRegister.measureResult = statevector

        statevectorFactory.makeStatevectorResult = finalStateVector

        // When
        let result = try? simulator.apply(circuit: [firstGate, secondGate, thirdGate],
                                          to: initialCircuitStatevector).get()

        // Then
        XCTAssertEqual(registerFactory.makeTimeEvolutionStateCount, 1)
        XCTAssertEqual(register.simulatorApplyingCount, 1)
        XCTAssertTrue(register.lastSimulatorApplyingGate == firstGate)
        XCTAssertEqual(firstRegister.simulatorApplyingCount, 1)
        XCTAssertTrue(firstRegister.lastSimulatorApplyingGate == secondGate)
        XCTAssertEqual(secondRegister.simulatorApplyingCount, 1)
        XCTAssertTrue(secondRegister.lastSimulatorApplyingGate == thirdGate)
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
