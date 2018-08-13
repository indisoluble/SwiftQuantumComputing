//
//  Int+DerivedTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 13/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class Int_DerivedTests: XCTestCase {

    // MARK: - Tests

    func testTwoAndTwoSortedPositions_derived_returnExpectedValue() {
        // Then
        XCTAssertEqual(2.derived(takingBitsAt: [1, 2]), 1)
    }

    func testTwoAndTwoInvertedPositions_derived_returnExpectedValue() {
        // Then
        XCTAssertEqual(2.derived(takingBitsAt: [2, 1]), 2)
    }

    func testFiftySevenAndTwoSortedPositions_derived_returnExpectedValue() {
        // Then
        XCTAssertEqual(57.derived(takingBitsAt: [1, 3]), 2)
    }

    func testFortyTwoAndTwoInvertedPositions_derived_returnExpectedValue() {
        // Then
        XCTAssertEqual(42.derived(takingBitsAt: [4, 1]), 2)
    }

    func testAnyNumberAndPositionOutOfRange_derived_returnZero() {
        // Then
        XCTAssertEqual(2.derived(takingBitsAt: [1000]), 0)
    }

    func testFortyTwoTwoInvertedPositionAndOneOutOfRange_derived_returnExpectedValue() {
        // Then
        XCTAssertEqual(42.derived(takingBitsAt: [2, 1, 1000]), 2)
    }
}
