//
//  Array+RearrangeBitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/12/2020.
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

class Array_RearrangeBitsTests: XCTestCase {

    // MARK: - Tests

    func testTwoAndNoOrigins_rearrangeBits_returnExpectedValue() {
        // Given
        let sut: [BitwiseShift] = []

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 2), 0)
    }

    func testTwoAndTwoSortedOrigins_rearrangeBits_returnExpectedValue() {
        // Given
        let sut = [
            BitwiseShift(origin: 2, destination: 1),
            BitwiseShift(origin: 1, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 2), 1)
    }

    func testTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue() {
        // Given
        let sut = [
            BitwiseShift(origin: 1, destination: 1),
            BitwiseShift(origin: 2, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 2), 2)
    }

    func testFiftySevenAndTwoSortedOrigins_rearrangeBits_returnExpectedValue() {
        // Given
        let sut = [
            BitwiseShift(origin: 3, destination: 1),
            BitwiseShift(origin: 1, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 57), 2)
    }

    func testFortyTwoAndTwoInvertedOrigins_rearrangeBits_returnExpectedValue() {
        // Given
        let sut = [
            BitwiseShift(origin: 1, destination: 1),
            BitwiseShift(origin: 4, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 42), 2)
    }

    func testAnyNumberAndOriginOutOfRange_rearrangeBits_returnZero() {
        // Given
        let sut = [
            BitwiseShift(origin: 1000, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 2), 0)
    }

    func testFortyTwoTwoInvertedOriginAndOneOutOfRange_rearrangeBits_returnExpectedValue() {
        // Given
        let sut = [
            BitwiseShift(origin: 1000, destination: 2),
            BitwiseShift(origin: 1, destination: 1),
            BitwiseShift(origin: 2, destination: 0)
        ]

        // Then
        XCTAssertEqual(sut.rearrangeBits(in: 42), 2)
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
         testFortyTwoTwoInvertedOriginAndOneOutOfRange_rearrangeBits_returnExpectedValue)
    ]
}
