//
//  String+BitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/03/2020.
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

class String_BitsTests: XCTestCase {

    // MARK: - Tests

    func testValueAndBitCount_init_returnExpectedValue() {
        // Then
        XCTAssertEqual(String(13, bitCount: 6), "001101")
    }

    func testValueAndBits_init_returnExpectedValue() {
        // Then
        XCTAssertEqual(String(13, bits: [1, 0]), "01")
    }

    func testValueAndReversedBits_init_returnExpectedValue() {
        // Then
        XCTAssertEqual(String(13, bits: [0, 1]), "10")
    }

    func testValueAndBitsOutOfRange_init_returnExpectedValue() {
        // Then
        XCTAssertEqual(String(13, bits: [100, 0, 1, 200]), "0100")
    }

    func testValueAndEmptyBits_init_returnExpectedValue() {
        // Then
        XCTAssertEqual(String(13, bits: []), "")
    }

    static var allTests = [
        ("testValueAndBitCount_init_returnExpectedValue",
         testValueAndBitCount_init_returnExpectedValue),
        ("testValueAndBits_init_returnExpectedValue",
         testValueAndBits_init_returnExpectedValue),
        ("testValueAndReversedBits_init_returnExpectedValue",
         testValueAndReversedBits_init_returnExpectedValue),
        ("testValueAndBitsOutOfRange_init_returnExpectedValue",
         testValueAndBitsOutOfRange_init_returnExpectedValue),
        ("testValueAndEmptyBits_init_returnExpectedValue",
         testValueAndEmptyBits_init_returnExpectedValue)
    ]
}
