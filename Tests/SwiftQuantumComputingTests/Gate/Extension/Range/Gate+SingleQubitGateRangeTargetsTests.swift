//
//  Gate+SingleQubitGateRangeTargetsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/12/2019.
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

class Gate_SingleQubitGateRangeTargetsTests: XCTestCase {

    // MARK: - Tests

    func testRangeOfTargets_hadamard_returnExpectedList() {
        // Then
        XCTAssertEqual(Gate.hadamard(targets: 0..<2),
                       [Gate.hadamard(target: 0), Gate.hadamard(target: 1)])
        XCTAssertEqual(Gate.hadamard(targets: 0...1),
                       [Gate.hadamard(target: 0), Gate.hadamard(target: 1)])
        XCTAssertEqual(Gate.hadamard(targets: 0, 1),
                       [Gate.hadamard(target: 0), Gate.hadamard(target: 1)])
    }

    func testRangeOfTargets_not_returnExpectedList() {
        // Then
        XCTAssertEqual(Gate.not(targets: 0..<2), [Gate.not(target: 0), Gate.not(target: 1)])
        XCTAssertEqual(Gate.not(targets: 0...1), [Gate.not(target: 0), Gate.not(target: 1)])
        XCTAssertEqual(Gate.not(targets: 0, 1), [Gate.not(target: 0), Gate.not(target: 1)])
    }

    static var allTests = [
        ("testRangeOfTargets_hadamard_returnExpectedList",
         testRangeOfTargets_hadamard_returnExpectedList),
        ("testRangeOfTargets_not_returnExpectedList",
         testRangeOfTargets_not_returnExpectedList)
    ]
}
