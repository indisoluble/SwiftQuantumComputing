//
//  Gate+OracleWithRangeControlsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/12/2019.
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

class Gate_OracleWithRangeControlsTests: XCTestCase {

    // MARK: - Properties

    let truthTable = ["0", "1"]
    let target = 0

    // MARK: - Tests

    func testAnyRange_oracleWithControls_returnExpectedGate() {
        // Then
        XCTAssertEqual(Gate.oracle(truthTable: truthTable, target: target, controls: 0..<3),
                       Gate.oracle(truthTable: truthTable, target: target, controls: [0, 1, 2]))
    }

    func testAnyClosedRange_oracleWithControls_returnExpectedGate() {
        // Then
        XCTAssertEqual(Gate.oracle(truthTable: truthTable, target: target, controls: 0...2),
                       Gate.oracle(truthTable: truthTable, target: target, controls: [0, 1, 2]))
    }

    func testAnyRange_oracleWithReversedControls_returnExpectedGate() {
        // Then
        XCTAssertEqual(Gate.oracle(truthTable: truthTable, target: target, reversedControls: 0..<3),
                       Gate.oracle(truthTable: truthTable, target: target, controls: [2, 1, 0]))
    }

    func testAnyClosedRange_oracleWithReversedControls_returnExpectedGate() {
        // Then
        XCTAssertEqual(Gate.oracle(truthTable: truthTable, target: target, reversedControls: 0...2),
                       Gate.oracle(truthTable: truthTable, target: target, controls: [2, 1, 0]))
    }

    static var allTests = [
        ("testAnyRange_oracleWithControls_returnExpectedGate",
         testAnyRange_oracleWithControls_returnExpectedGate),
        ("testAnyClosedRange_oracleWithControls_returnExpectedGate",
         testAnyClosedRange_oracleWithControls_returnExpectedGate),
        ("testAnyRange_oracleWithReversedControls_returnExpectedGate",
         testAnyRange_oracleWithReversedControls_returnExpectedGate),
        ("testAnyClosedRange_oracleWithReversedControls_returnExpectedGate",
         testAnyClosedRange_oracleWithReversedControls_returnExpectedGate)
    ]
}
