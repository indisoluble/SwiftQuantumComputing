//
//  ControlledGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/08/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

class ControlledGateTests: XCTestCase {

    // MARK: - Tests

    func testZeroControlCount_init_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()
        let controlCount = 0

        // Then
        XCTAssertThrowsError(try ControlledGate(gate: gate, controlCount: controlCount))
    }

    func testGateThatThrowsException_makeFixed_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = nil

        let factory = try! ControlledGate(gate: gate, controlCount: 1)

        // Then
        switch factory.makeFixed(inputs: []) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testValidGateAndLessInputsThanNecessary_makeFixed_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = .not(target: 0)

        let controlCount = 1
        let factory = try! ControlledGate(gate: gate, controlCount: controlCount)

        let inputs = Array(0..<controlCount)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testValidGateAndEnoughInputs_makeFixed_returnExpectedGate() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = .not(target: 0)

        let factory = try! ControlledGate(gate: gate, controlCount: 1)

        let inputs = Array(0..<2)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.controlled(let gate, let controls)):
            XCTAssertEqual(gate, .not(target: 0))
            XCTAssertEqual(controls, [1])
        default:
            XCTAssert(false)
        }
    }

    func testComposedGateAndEnoughInputs_makeFixed_returnExpectedGate() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = .controlled(gate: .not(target: 0), controls: [1, 3, 4])

        let factory = try! ControlledGate(gate: gate, controlCount: 2)

        let inputs = Array(0..<10)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.controlled(let gate, let controls)):
            XCTAssertEqual(gate, .controlled(gate: .not(target: 0), controls: [1, 3, 4]))
            XCTAssertEqual(controls, [2, 5])
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testZeroControlCount_init_throwException",
         testZeroControlCount_init_throwException),
        ("testGateThatThrowsException_makeFixed_throwException",
         testGateThatThrowsException_makeFixed_throwException),
        ("testValidGateAndLessInputsThanNecessary_makeFixed_throwException",
         testValidGateAndLessInputsThanNecessary_makeFixed_throwException),
        ("testValidGateAndEnoughInputs_makeFixed_returnExpectedGate",
         testValidGateAndEnoughInputs_makeFixed_returnExpectedGate),
        ("testComposedGateAndEnoughInputs_makeFixed_returnExpectedGate",
         testComposedGateAndEnoughInputs_makeFixed_returnExpectedGate)
    ]
}
