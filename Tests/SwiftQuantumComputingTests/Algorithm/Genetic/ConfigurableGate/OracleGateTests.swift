//
//  OracleGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/08/2020.
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

class OracleGateTests: XCTestCase {

    // MARK: - Tests

    func testZeroTruthTableQubits_init_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()

        // Then
        XCTAssertThrowsError(try OracleGate(truthTable: [], truthTableQubitCount: 0, gate: gate))
    }

    func testGateThatThrowsException_makeFixed_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = nil

        let factory = try! OracleGate(truthTable: [], truthTableQubitCount: 1, gate: gate)

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

        let truthTableQubitCount = 1
        let factory = try! OracleGate(truthTable: [],
                                      truthTableQubitCount: truthTableQubitCount,
                                      gate: gate)

        let inputs = Array(0..<truthTableQubitCount)

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

        let factory = try! OracleGate(truthTable: [], truthTableQubitCount: 1, gate: gate)

        let inputs = Array(0..<2)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.oracle(let truthTable, let controls, let gate)):
            XCTAssertEqual(truthTable, [])
            XCTAssertEqual(controls, [1])
            XCTAssertEqual(gate, .not(target: 0))
        default:
            XCTAssert(false)
        }
    }

    func testComposedGateAndEnoughInputs_makeFixed_returnExpectedGate() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = .oracle(truthTable: ["0"],
                                       controls: [3, 1, 4],
                                       gate: .not(target: 0))

        let factory = try! OracleGate(truthTable: ["1"], truthTableQubitCount: 2, gate: gate)

        let inputs = Array(0..<10)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.oracle(let truthTable, let controls, let gate)):
            XCTAssertEqual(truthTable, ["1"])
            XCTAssertEqual(controls, [2, 5])
            XCTAssertEqual(gate,
                           .oracle(truthTable: ["0"], controls: [3, 1, 4], gate: .not(target: 0)))
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testZeroTruthTableQubits_init_throwException",
         testZeroTruthTableQubits_init_throwException),
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
