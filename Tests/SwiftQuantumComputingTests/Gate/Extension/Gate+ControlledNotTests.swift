//
//  Gate+ControlledNotTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/09/2020.
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

class Gate_ControlledNotTests: XCTestCase {

    // MARK: - Tests

    func testAnyValues_controlledNot_returnExpectedGate() {
        // Then
        XCTAssertEqual(Gate.controlledNot(target: 0, control: 1),
                       Gate.controlled(gate: .not(target: 0), controls: [1]))
    }

    static var allTests = [
        ("testAnyValues_controlledNot_returnExpectedGate",
         testAnyValues_controlledNot_returnExpectedGate)
    ]
}
