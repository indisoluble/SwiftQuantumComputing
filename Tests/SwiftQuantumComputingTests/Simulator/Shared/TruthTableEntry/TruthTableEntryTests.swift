//
//  TruthTableEntryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/04/2021.
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

class TruthTableEntryTests: XCTestCase {

    // MARK: - Tests

    func testEmptyTruth_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "", truthCount: 1))
    }

    func testTruthCountZero_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "1", truthCount: 0))
    }

    func testTruthLongerThanTruthCountAndNonValidCharactersAtTheBegining_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "0a0111", truthCount: 3))
    }

    func testTruthLongerThanTruthCountAndOnesAtTheBegining_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "010111", truthCount: 3))
    }

    func testTruthLongerThanTruthCountZerosAtTheBeginingAndNonValidCharactersAtTheEnd_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "0001a1", truthCount: 3))
    }

    func testTruthShorterThanTruthCountAndNonValidCharacters_init_throwException() {
        // Then
        XCTAssertThrowsError(try TruthTableEntry(truth: "a1", truthCount: 3))
    }

    func testTruthShorterThanTruthCount_init_returnExpectedEntry() {
        // When
        let entry = try? TruthTableEntry(truth: "1", truthCount: 3)

        // Then
        XCTAssertEqual(entry?.truth, "001")
    }

    func testTruthLongerThanTruthCountAndZerosAtTheBegining_init_returnExpectedEntry() {
        // When
        let entry = try? TruthTableEntry(truth: "000011", truthCount: 3)

        // Then
        XCTAssertEqual(entry?.truth, "011")
    }

    func testTruthWithoutCount_init_returnExpectedEntry() {
        // Given
        let truth = "000011"

        // Then
        XCTAssertEqual(try? TruthTableEntry(truth: truth).truth, truth)
    }

    func testAnyTwoEntries_add_returnExpectedEntry() {
        // Given
        let lhs = try! TruthTableEntry(truth: "1", truthCount: 3)
        let rhs = try! TruthTableEntry(truth: "000011", truthCount: 3)

        // Then
        XCTAssertEqual((lhs + rhs).truth, "001011")
    }

    static var allTests = [
        ("testEmptyTruth_init_throwException",
         testEmptyTruth_init_throwException),
        ("testTruthCountZero_init_throwException",
         testTruthCountZero_init_throwException),
        ("testTruthLongerThanTruthCountAndNonValidCharactersAtTheBegining_init_throwException",
         testTruthLongerThanTruthCountAndNonValidCharactersAtTheBegining_init_throwException),
        ("testTruthLongerThanTruthCountAndOnesAtTheBegining_init_throwException",
         testTruthLongerThanTruthCountAndOnesAtTheBegining_init_throwException),
        ("testTruthLongerThanTruthCountZerosAtTheBeginingAndNonValidCharactersAtTheEnd_init_throwException",
         testTruthLongerThanTruthCountZerosAtTheBeginingAndNonValidCharactersAtTheEnd_init_throwException),
        ("testTruthShorterThanTruthCountAndNonValidCharacters_init_throwException",
         testTruthShorterThanTruthCountAndNonValidCharacters_init_throwException),
        ("testTruthShorterThanTruthCount_init_returnExpectedEntry",
         testTruthShorterThanTruthCount_init_returnExpectedEntry),
        ("testTruthLongerThanTruthCountAndZerosAtTheBegining_init_returnExpectedEntry",
         testTruthLongerThanTruthCountAndZerosAtTheBegining_init_returnExpectedEntry),
        ("testTruthWithoutCount_init_returnExpectedEntry",
         testTruthWithoutCount_init_returnExpectedEntry),
        ("testAnyTwoEntries_add_returnExpectedEntry",
         testAnyTwoEntries_add_returnExpectedEntry)
    ]
}
