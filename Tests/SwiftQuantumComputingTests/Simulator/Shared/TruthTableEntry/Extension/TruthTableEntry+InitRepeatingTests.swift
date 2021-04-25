//
//  TruthTableEntry+InitRepeatingTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/04/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class TruthTableEntry_InitRepeatingTests: XCTestCase {

    // MARK: - Tests

    func testNonValidCharacter_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(repeating: "a", count: 2))
    }

    func testZero_init_returnExpectedValue() {
        // When
        let entry = try? TruthTableEntry(repeating: "0", count: 3)

        // Then
        XCTAssertEqual(entry?.truth, "000")
    }

    func testOne_init_returnExpectedValue() {
        // When
        let entry = try? TruthTableEntry(repeating: "1", count: 5)

        // Then
        XCTAssertEqual(entry?.truth, "11111")
    }

    static var allTests = [
        ("testNonValidCharacter_init_throwException", testNonValidCharacter_init_throwException),
        ("testZero_init_returnExpectedValue", testZero_init_returnExpectedValue),
        ("testOne_init_returnExpectedValue", testOne_init_returnExpectedValue)
    ]
}
