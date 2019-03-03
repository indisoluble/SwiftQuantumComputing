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

    func testFactoryWithZeroTruthTableQubits_makeFixed_returnNil() {
        // Given
        let factory = OracleGate(truthTable: [], truthTableQubitCount: 0)

        // Then
        XCTAssertNil(factory.makeFixed(inputs: [0]))
    }

    func testAnyFactoryAndAsManyInpusAsTruthTableQubits_makeFixed_returnNil() {
        // Given
        let truthTableQubitCount = 3
        let factory = OracleGate(truthTable: [], truthTableQubitCount: truthTableQubitCount)

        let inputs = Array(0..<truthTableQubitCount)

        // Then
        XCTAssertNil(factory.makeFixed(inputs: inputs))
    }

    func testAnyFactoryAndOneInputMoreThanTruthTableQubits_makeFixed_returnExpectedGate() {
        // Given
        let expectedTruthTable = ["000", "111"]
        let expectedTruthTableQubitCount = 3
        let factory = OracleGate(truthTable: expectedTruthTable,
                                 truthTableQubitCount: expectedTruthTableQubitCount)

        let inputs = Array((0..<(expectedTruthTableQubitCount + 1)).reversed())

        // When
        guard let result = factory.makeFixed(inputs: inputs) else {
            XCTAssert(false)

            return
        }

        // Then
        switch result {
        case .oracle(let truthTable, let target, let controls):
            XCTAssertEqual(truthTable, expectedTruthTable)
            XCTAssertEqual(target, inputs[expectedTruthTableQubitCount])
            XCTAssertEqual(controls, Array(inputs[0..<expectedTruthTableQubitCount]))
        default:
            XCTAssert(false)
        }
    }
}
