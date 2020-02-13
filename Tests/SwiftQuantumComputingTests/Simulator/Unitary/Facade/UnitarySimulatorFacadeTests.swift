//
//  UnitarySimulatorFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

class UnitarySimulatorFacadeTests: XCTestCase {

    // MARK: - Properties

    let gateFactory = UnitaryGateFactoryTestDouble()
    let qubitCount = 1
    let firstSimulatorGate = SimulatorGateTestDouble()
    let secondSimulatorGate = SimulatorGateTestDouble()
    let thirdSimulatorGate = SimulatorGateTestDouble()
    let firstUnitaryGate = UnitaryGateTestDouble()
    let secondUnitaryGate = UnitaryGateTestDouble()
    let thirdUnitaryGate = UnitaryGateTestDouble()

    // MARK: - Tests

    func testEmptyCircuit_unitary_throwError() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        // Then
        XCTAssertThrowsError(try simulator.unitary(with: [], qubitCount: qubitCount))
        XCTAssertEqual(gateFactory.makeGateCount, 0)
    }

    func testNonEmptyCircuitAndGateFactoryThatThrowsError_unitary_throwError() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        let circuit = [firstSimulatorGate]

        // Then
        XCTAssertThrowsError(try simulator.unitary(with: circuit, qubitCount: qubitCount))
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        if let lastMakeGateSimulatorGate = gateFactory.lastMakeGateSimulatorGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastMakeGateSimulatorGate === firstSimulatorGate)
        } else {
            XCTAssert(false)
        }
    }

    func testOneGateCircuitAndGateFactoryThatReturnsGate_unitary_returnExpectedMatrix() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        gateFactory.applyingResult = firstUnitaryGate

        let expectedResult = Matrix.makeControlledNot()
        firstUnitaryGate.unitaryResult = expectedResult

        let circuit = [firstSimulatorGate]

        // When
        let result = try? simulator.unitary(with: circuit, qubitCount: qubitCount)

        // Then
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        if let lastMakeGateSimulatorGate = gateFactory.lastMakeGateSimulatorGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastMakeGateSimulatorGate === firstSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstUnitaryGate.applyingCount, 0)
        XCTAssertEqual(firstUnitaryGate.unitaryCount, 1)
        XCTAssertEqual(result, expectedResult)
    }

    func testOneGateCircuitAndGateFactoryThatReturnsGateWhichUnitaryThrowsError_unitary_throwError() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        gateFactory.applyingResult = firstUnitaryGate

        let circuit = [firstSimulatorGate]

        // Then
        XCTAssertThrowsError(try simulator.unitary(with: circuit, qubitCount: qubitCount))
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        if let lastMakeGateSimulatorGate = gateFactory.lastMakeGateSimulatorGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastMakeGateSimulatorGate === firstSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstUnitaryGate.applyingCount, 0)
        XCTAssertEqual(firstUnitaryGate.unitaryCount, 1)
    }

    func testTwoGatesCircuitFactoryThatReturnsUnitaryAndUnitaryThatThrowsError_unitary_throwError() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        gateFactory.applyingResult = firstUnitaryGate

        let circuit = [firstSimulatorGate, secondSimulatorGate]

        // Then
        XCTAssertThrowsError(try simulator.unitary(with: circuit, qubitCount: qubitCount))
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        if let lastMakeGateSimulatorGate = gateFactory.lastMakeGateSimulatorGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastMakeGateSimulatorGate === firstSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstUnitaryGate.applyingCount, 1)
        if let lastApplyingGate = firstUnitaryGate.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondSimulatorGate)
        } else {
            XCTAssert(false)
        }
    }

    func testThreeGatesCircuitFactoryThatReturnsUnitaryAndUnitariesThatDoTheSame_unitary_returnExpectedMatrix() {
        // Given
        let simulator = UnitarySimulatorFacade(gateFactory: gateFactory)

        gateFactory.applyingResult = firstUnitaryGate
        firstUnitaryGate.applyingResult = secondUnitaryGate
        secondUnitaryGate.applyingResult = thirdUnitaryGate

        let expectedResult = Matrix.makeControlledNot()
        thirdUnitaryGate.unitaryResult = expectedResult

        let circuit = [firstSimulatorGate, secondSimulatorGate, thirdSimulatorGate]

        // When
        let result = try? simulator.unitary(with: circuit, qubitCount: qubitCount)

        // Then
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        if let lastMakeGateSimulatorGate = gateFactory.lastMakeGateSimulatorGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastMakeGateSimulatorGate === firstSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(firstUnitaryGate.applyingCount, 1)
        if let lastApplyingGate = firstUnitaryGate.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === secondSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(secondUnitaryGate.applyingCount, 1)
        if let lastApplyingGate = secondUnitaryGate.lastApplyingGate as? SimulatorGateTestDouble {
            XCTAssertTrue(lastApplyingGate === thirdSimulatorGate)
        } else {
            XCTAssert(false)
        }
        XCTAssertEqual(thirdUnitaryGate.applyingCount, 0)
        XCTAssertEqual(thirdUnitaryGate.unitaryCount, 1)
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyCircuit_unitary_throwError",
         testEmptyCircuit_unitary_throwError),
        ("testNonEmptyCircuitAndGateFactoryThatThrowsError_unitary_throwError",
         testNonEmptyCircuitAndGateFactoryThatThrowsError_unitary_throwError),
        ("testOneGateCircuitAndGateFactoryThatReturnsGate_unitary_returnExpectedMatrix",
         testOneGateCircuitAndGateFactoryThatReturnsGate_unitary_returnExpectedMatrix),
        ("testOneGateCircuitAndGateFactoryThatReturnsGateWhichUnitaryThrowsError_unitary_throwError",
         testOneGateCircuitAndGateFactoryThatReturnsGateWhichUnitaryThrowsError_unitary_throwError),
        ("testTwoGatesCircuitFactoryThatReturnsUnitaryAndUnitaryThatThrowsError_unitary_throwError",
         testTwoGatesCircuitFactoryThatReturnsUnitaryAndUnitaryThatThrowsError_unitary_throwError),
        ("testThreeGatesCircuitFactoryThatReturnsUnitaryAndUnitariesThatDoTheSame_unitary_returnExpectedMatrix",
         testThreeGatesCircuitFactoryThatReturnsUnitaryAndUnitariesThatDoTheSame_unitary_returnExpectedMatrix)
    ]
}
