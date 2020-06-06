//
//  ControlledNotGateTests.swift
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

class ControlledNotGateTests: XCTestCase {

    // MARK: - Properties

    let factory = ControlledNotGate()

    // MARK: - Tests

    func testAnyFactoryAndOnlyOneInput_makeFixed_throwException() {
        // Then
        switch factory.makeFixed(inputs: [0]) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testAnyFactoryAndThreeInputs_makeFixed_returnExpectedGate() {
        // Given
        let inputs = [0, 1, 2]

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.controlledNot(let target, let control)):
            XCTAssertEqual(inputs[0], target)
            XCTAssertEqual(inputs[1], control)
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testAnyFactoryAndOnlyOneInput_makeFixed_throwException",
         testAnyFactoryAndOnlyOneInput_makeFixed_throwException),
        ("testAnyFactoryAndThreeInputs_makeFixed_returnExpectedGate",
         testAnyFactoryAndThreeInputs_makeFixed_returnExpectedGate)
    ]
}
