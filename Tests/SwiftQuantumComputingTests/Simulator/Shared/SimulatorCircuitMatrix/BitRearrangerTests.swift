//
//  BitRearrangerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/12/2020.
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

class BitRearrangerTests: XCTestCase {

    // MARK: - Tests

    func testTwoAndNoOrigins_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: []).rearrangeBits(in: 2), 0)
    }

    func testTwoAndTwoSortedOrigins_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [2, 1]).rearrangeBits(in: 2), 1)
    }

    func testTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1, 2]).rearrangeBits(in: 2), 2)
    }

    func testFiftySevenAndTwoSortedOrigins_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [3, 1]).rearrangeBits(in: 57), 2)
    }

    func testFortyTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1, 4]).rearrangeBits(in: 42), 2)
    }

    func testAnyNumberAndOriginOutOfRange_rearrangeBits_returnZero() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1000]).rearrangeBits(in: 2), 0)
    }

    func testFortyTwoTwoInvertedOriginAndOneOutOfRange_rearrangeBits_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1000, 1, 2]).rearrangeBits(in: 42), 2)
    }

    func testTwoInvertedOrigins_selectedBitsMask_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1, 4]).selectedBitsMask, 18)
    }

    func testTwoInvertedOrigins_unselectedBitsMask_returnExpectedValue() {
        // Then
        XCTAssertEqual(BitRearranger(origins: [1, 4]).unselectedBitsMask, ~18)
    }

    static var allTests = [
        ("testTwoAndNoOrigins_rearrangeBits_returnExpectedValue",
         testTwoAndNoOrigins_rearrangeBits_returnExpectedValue),
        ("testTwoAndTwoSortedOrigins_rearrangeBits_returnExpectedValue",
         testTwoAndTwoSortedOrigins_rearrangeBits_returnExpectedValue),
        ("testTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue",
         testTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue),
        ("testFiftySevenAndTwoSortedOrigins_rearrangeBits_returnExpectedValue",
         testFiftySevenAndTwoSortedOrigins_rearrangeBits_returnExpectedValue),
        ("testFortyTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue",
         testFortyTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue),
        ("testAnyNumberAndOriginOutOfRange_rearrangeBits_returnZero",
         testAnyNumberAndOriginOutOfRange_rearrangeBits_returnZero),
        ("testFortyTwoTwoInvertedOriginAndOneOutOfRange_rearrangeBits_returnExpectedValue",
         testFortyTwoTwoInvertedOriginAndOneOutOfRange_rearrangeBits_returnExpectedValue),
        ("testTwoInvertedOrigins_selectedBitsMask_returnExpectedValue",
         testTwoInvertedOrigins_selectedBitsMask_returnExpectedValue),
        ("testTwoInvertedOrigins_unselectedBitsMask_returnExpectedValue",
         testTwoInvertedOrigins_unselectedBitsMask_returnExpectedValue)
    ]
}
