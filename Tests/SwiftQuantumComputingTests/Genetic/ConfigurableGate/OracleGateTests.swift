//
//  OracleGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/01/2019.
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

class OracleGateTests: XCTestCase {

    // MARK: - Tests

    func testZeroTruthTableQubits_init_throwException() {
        // Then
        XCTAssertThrowsError(try OracleGate(truthTable: [], truthTableQubitCount: 0))
    }

    func testAnyFactoryAndAsManyInpusAsTruthTableQubits_makeFixed_throwException() {
        // Given
        let truthTableQubitCount = 3
        let factory = try! OracleGate(truthTable: [], truthTableQubitCount: truthTableQubitCount)

        let inputs = Array(0..<truthTableQubitCount)

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testAnyFactoryAndOneInputMoreThanTruthTableQubits_makeFixed_returnExpectedGate() {
        // Given
        let expectedTruthTable = ["000", "111"]
        let expectedTruthTableQubitCount = 3
        let factory = try! OracleGate(truthTable: expectedTruthTable,
                                      truthTableQubitCount: expectedTruthTableQubitCount)

        let inputs = Array((0..<(expectedTruthTableQubitCount + 1)).reversed())

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.oracle(let truthTable, let target, let controls)):
            XCTAssertEqual(truthTable, expectedTruthTable)
            XCTAssertEqual(target, inputs[expectedTruthTableQubitCount])
            XCTAssertEqual(controls, Array(inputs[0..<expectedTruthTableQubitCount]))
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testZeroTruthTableQubits_init_throwException",
         testZeroTruthTableQubits_init_throwException),
        ("testAnyFactoryAndAsManyInpusAsTruthTableQubits_makeFixed_throwException",
         testAnyFactoryAndAsManyInpusAsTruthTableQubits_makeFixed_throwException),
        ("testAnyFactoryAndOneInputMoreThanTruthTableQubits_makeFixed_returnExpectedGate",
         testAnyFactoryAndOneInputMoreThanTruthTableQubits_makeFixed_returnExpectedGate)
    ]
}
