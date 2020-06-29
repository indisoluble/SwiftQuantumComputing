//
//  SimpleGeneticGateFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/02/2019.
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

class SimpleGeneticGateFactoryTests: XCTestCase {

    // MARK: - Tests

    func testFactoryWithGateThatReturnNil_makeGate_throwException() {
        // Given
        let gate = ConfigurableGateTestDouble()
        let factory = SimpleGeneticGateFactory(gate: gate)

        let inputs = [0, 1]

        // Then
        switch factory.makeGate(inputs: inputs) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(gate.makeFixedCount, 1)
            XCTAssertEqual(gate.lastMakeFixedInputs, inputs)
        default:
            XCTAssert(false)
        }
    }

    func testFactoryWithGateThatReturnValue_makeGate_returnNotNil() {
        // Given
        let gate = ConfigurableGateTestDouble()
        gate.makeFixedResult = Gate.not(target: 0)
        let factory = SimpleGeneticGateFactory(gate: gate)

        // When
        let inputs = [0, 1]
        let result = try? factory.makeGate(inputs: inputs).get()

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(gate.makeFixedCount, 1)
        XCTAssertEqual(gate.lastMakeFixedInputs, inputs)
    }

    static var allTests = [
        ("testFactoryWithGateThatReturnNil_makeGate_throwException",
         testFactoryWithGateThatReturnNil_makeGate_throwException),
        ("testFactoryWithGateThatReturnValue_makeGate_returnNotNil",
         testFactoryWithGateThatReturnValue_makeGate_returnNotNil)
    ]
}
