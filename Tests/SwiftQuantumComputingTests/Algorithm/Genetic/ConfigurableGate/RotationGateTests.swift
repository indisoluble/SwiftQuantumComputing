//
//  RotationGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/09/2020.
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

class RotationGateTests: XCTestCase {

    // MARK: - Tests

    func testAnyFactoryAndZeroInputs_makeFixed_throwException() {
        // Given
        let factory = RotationGate(axis: .x, radians: 0.0)

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
        let axis = Gate.Axis.x
        let radians = 0.1
        let factory = RotationGate(axis: axis, radians: radians)

        let inputs = [0, 1]

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.rotation(let gateAxis, let gateRadians, let target)):
            XCTAssertEqual(axis, gateAxis)
            XCTAssertEqual(radians, gateRadians)
            XCTAssertEqual(inputs[0], target)
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
