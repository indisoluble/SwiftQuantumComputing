//
//  HadamardGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/12/2018.
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

class HadamardGateTests: XCTestCase {

    // MARK: - Properties

    let factory = HadamardGate()

    // MARK: - Tests

    func testAnyFactoryAndZeroInputs_makeFixed_throwException() {
        // Then
        switch factory.makeFixed(inputs: []) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testAnyFactoryAndTwoInputs_makeFixed_returnExpectedGate() {
        // Given
        let inputs = [0, 1]

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(let gate):
            XCTAssertEqual(gate, .hadamard(target: inputs[0]))
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testAnyFactoryAndZeroInputs_makeFixed_throwException",
         testAnyFactoryAndZeroInputs_makeFixed_throwException),
        ("testAnyFactoryAndTwoInputs_makeFixed_returnExpectedGate",
         testAnyFactoryAndTwoInputs_makeFixed_returnExpectedGate)
    ]
}
