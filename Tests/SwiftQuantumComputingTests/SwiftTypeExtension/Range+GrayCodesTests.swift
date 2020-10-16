//
//  Range+GrayCodesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/09/2020.
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

class Range_GrayCodesTests: XCTestCase {

    // MARK: - Tests

    func testAnyRange_grayCodes_returnExpectedList() {
        // Then
        XCTAssertEqual((0..<16).grayCodes(),
                       [0, 1, 3, 2, 6, 7, 5, 4, 12, 13, 15, 14, 10, 11, 9, 8])
    }

    static var allTests = [
        ("testAnyRange_grayCodes_returnExpectedList", testAnyRange_grayCodes_returnExpectedList)
    ]
}
