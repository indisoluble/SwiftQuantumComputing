//
//  Gate+SingleQubitGateReplicatorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/12/2019.
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

class Gate_SingleQubitGateReplicatorTests: XCTestCase {

    // MARK: - Tests

    func testListOfTargets_hadamard_returnExpectedList() {
        // Then
        XCTAssertEqual(Gate.hadamard(targets: [2, 2]),
                       [Gate.hadamard(target: 2), Gate.hadamard(target: 2)])
    }

    func testListOfTargets_not_returnExpectedList() {
        // Then
        XCTAssertEqual(Gate.not(targets: [2, 2]), [Gate.not(target: 2), Gate.not(target: 2)])
    }

    static var allTests = [
        ("testListOfTargets_hadamard_returnExpectedList",
         testListOfTargets_hadamard_returnExpectedList),
        ("testListOfTargets_not_returnExpectedList",
         testListOfTargets_not_returnExpectedList)
    ]
}
