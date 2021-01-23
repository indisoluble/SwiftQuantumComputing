//
//  DirectStatevectorMultiQubitGateIndexerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/01/2021.
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

class DirectStatevectorMultiQubitGateIndexerTests: XCTestCase {

    // MARK: - Tests

    func testIndexerWithOneInputAndStatevectorPositionTwo_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult() {
        // Given
        let sut = DirectStatevectorMultiQubitGateIndexer(gateInputs: [2])

        // When
        let (row, multiplications) = sut.indexesToCalculateStatevectorValueAtPosition(2)

        // Then
        let expectedMultplications: [DirectStatevectorMultiplicationIndexes] = [(0, 2), (1,  6)]

        XCTAssertEqual(row, 0)
        XCTAssertTrue(zip(multiplications, expectedMultplications).allSatisfy(==))
    }

    func testIndexerWithOneInputAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult() {
        // Given
        let sut = DirectStatevectorMultiQubitGateIndexer(gateInputs: [2])

        // When
        let (row, multiplications) = sut.indexesToCalculateStatevectorValueAtPosition(4)

        // Then
        let expectedMultplications: [DirectStatevectorMultiplicationIndexes] = [(0, 0), (1,  4)]

        XCTAssertEqual(row, 1)
        XCTAssertTrue(zip(multiplications, expectedMultplications).allSatisfy(==))
    }

    func testIndexerWithTwoInputsAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult() {
        // Given
        let sut = DirectStatevectorMultiQubitGateIndexer(gateInputs: [2, 3])

        // When
        let (row, multiplications) = sut.indexesToCalculateStatevectorValueAtPosition(4)

        // Then
        let expectedMultplications: [DirectStatevectorMultiplicationIndexes] = [
            (0, 0), (1,  8), (2, 4), (3, 12)
        ]

        XCTAssertEqual(row, 2)
        XCTAssertTrue(zip(multiplications, expectedMultplications).allSatisfy(==))
    }

    static var allTests = [
        ("testIndexerWithOneInputAndStatevectorPositionTwo_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult",
         testIndexerWithOneInputAndStatevectorPositionTwo_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult),
        ("testIndexerWithOneInputAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult",
         testIndexerWithOneInputAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult),
        ("testIndexerWithTwoInputsAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult",
         testIndexerWithTwoInputsAndStatevectorPositionFour_indexesToCalculateStatevectorValueAtPosition_returnExpectedResult)
    ]
}
