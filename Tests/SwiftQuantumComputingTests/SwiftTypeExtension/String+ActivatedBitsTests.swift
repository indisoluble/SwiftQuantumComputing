//
//  String+ActivatedBitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/01/2020.
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

class String_ActivatedBitsTests: XCTestCase {

    // MARK: - Tests

    func testEmptyString_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual("".activatedBits, [])
    }

    func testCharOne_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual("1".activatedBits, [0])
    }

    func testCharZero_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual("0".activatedBits, [])
    }

    func testOnlyOnes_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual("1111".activatedBits, [0, 1, 2, 3])
    }

    func testOnlyZeros_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual("0000".activatedBits, [])
    }

    func testMixedZerosAndOnes_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual("1001011".activatedBits, [0, 1, 3, 6])
    }

    func testNoActivatedBitsAndMinCountNegative_init_returnEmptyString() {
        // Then
        XCTAssertEqual(String(activatedBits: [], minCount: -1), "")
    }

    func testNoActivatedBitsAndMinCountZero_init_returnEmptyString() {
        // Then
        XCTAssertEqual(String(activatedBits: [], minCount: 0), "")
    }

    func testNoActivatedBitsAndMinCountOne_init_returnZero() {
        // Then
        XCTAssertEqual(String(activatedBits: [], minCount: 1), "0")
    }

    func testAnyActivatedBitsAndSmallMinCount_init_returnExpectedValue() {
        // Given
        let activatedBits: Set<Int> = [1, 2]
        let minCount = 1

        // Then
        XCTAssertEqual(String(activatedBits: activatedBits, minCount: minCount), "110")
    }

    func testAnyActivatedBitsAndBigMinCount_init_returnExpectedValue() {
        // Given
        let activatedBits: Set<Int> = [0, 2]
        let minCount = 5

        // Then
        XCTAssertEqual(String(activatedBits: activatedBits, minCount: minCount), "00101")
    }

    static var allTests = [
        ("testEmptyString_activatedBits_returnEmptySet",
         testEmptyString_activatedBits_returnEmptySet),
        ("testCharOne_activatedBits_returnExpectedSet",
         testCharOne_activatedBits_returnExpectedSet),
        ("testCharZero_activatedBits_returnEmptySet",
         testCharZero_activatedBits_returnEmptySet),
        ("testOnlyOnes_activatedBits_returnExpectedSet",
         testOnlyOnes_activatedBits_returnExpectedSet),
        ("testOnlyZeros_activatedBits_returnEmptySet",
         testOnlyZeros_activatedBits_returnEmptySet),
        ("testMixedZerosAndOnes_activatedBits_returnExpectedSet",
         testMixedZerosAndOnes_activatedBits_returnExpectedSet),
        ("testNoActivatedBitsAndMinCountNegative_init_returnEmptyString",
         testNoActivatedBitsAndMinCountNegative_init_returnEmptyString),
        ("testNoActivatedBitsAndMinCountZero_init_returnEmptyString",
         testNoActivatedBitsAndMinCountZero_init_returnEmptyString),
        ("testNoActivatedBitsAndMinCountOne_init_returnZero",
         testNoActivatedBitsAndMinCountOne_init_returnZero),
        ("testAnyActivatedBitsAndSmallMinCount_init_returnExpectedValue",
         testAnyActivatedBitsAndSmallMinCount_init_returnExpectedValue),
        ("testAnyActivatedBitsAndBigMinCount_init_returnExpectedValue",
         testAnyActivatedBitsAndBigMinCount_init_returnExpectedValue)
    ]
}
