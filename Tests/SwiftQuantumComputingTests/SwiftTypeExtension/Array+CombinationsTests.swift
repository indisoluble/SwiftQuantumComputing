//
//  Array+CombinationsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/12/2019.
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

class Array_CombinationsTests: XCTestCase {

    // MARK: - Tests

    func testEmptyList_combinations_returnEmptyList() {
        // Then
        XCTAssertEqual(([] as [Int]).combinations(), [] as [[Int]])
    }

    func testOneElementList_combinations_returnExpectedResult() {
        // Then
        XCTAssertEqual([1].combinations(), [[], [1]])
    }

    func testTwoElementList_combinations_returnExpectedResult() {
        // Then
        XCTAssertEqual([1, 2].combinations(), [[], [1], [2], [1, 2]])
    }

    func testThreeElementList_combinations_returnExpectedResult() {
        // Then
        XCTAssertEqual([1, 2, 3].combinations(), [
            [],
            [1], [2], [3],
            [1, 2], [1, 3], [2, 3],
            [1, 2, 3]])
    }

    func testFourElementList_combinations_returnExpectedResult() {
        // Then
        XCTAssertEqual([1, 2, 3, 4].combinations(),
                       [[],
                        [1], [2], [3], [4],
                        [1, 2], [1, 3], [1, 4],
                        [2, 3], [2, 4],
                        [3, 4],
                        [1, 2, 3], [1, 2, 4],
                        [1, 3, 4],
                        [2, 3, 4],
                        [1, 2, 3, 4]])
    }

    static var allTests = [
        ("testEmptyList_combinations_returnEmptyList",
         testEmptyList_combinations_returnEmptyList),
        ("testOneElementList_combinations_returnExpectedResult",
         testOneElementList_combinations_returnExpectedResult),
        ("testTwoElementList_combinations_returnExpectedResult",
         testTwoElementList_combinations_returnExpectedResult),
        ("testThreeElementList_combinations_returnExpectedResult",
         testThreeElementList_combinations_returnExpectedResult),
        ("testFourElementList_combinations_returnExpectedResult",
         testFourElementList_combinations_returnExpectedResult)
    ]
}
