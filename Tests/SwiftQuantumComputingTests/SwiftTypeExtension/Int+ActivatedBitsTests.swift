//
//  Int+ActivatedBitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/10/2020.
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

class Int_ActivatedBitsTests: XCTestCase {

    // MARK: - Tests

    func testNegativeCount_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual(10.activatedBits(count: -1), [])
    }

    func testCountEqualToZero_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual(10.activatedBits(count: 0), [])
    }

    func testOne_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual(1.activatedBits(count: 1), [0])
    }

    func testZero_activatedBits_returnEmptySet() {
        // Then
        XCTAssertEqual(0.activatedBits(count: 1), [])
    }

    func testOnlyOnes_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual(Int("1111", radix: 2)!.activatedBits(count: 4), [0, 1, 2, 3])
    }

    func testMixedZerosAndOnes_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual(Int("1001011", radix: 2)!.activatedBits(count: 7), [0, 1, 3, 6])
    }

    func testMixedZerosAndOnesAndSmallCount_activatedBits_returnExpectedSet() {
        // Then
        XCTAssertEqual(Int("1001011", radix: 2)!.activatedBits(count: 5), [0, 1, 3])
    }

    static var allTests = [
        ("testNegativeCount_activatedBits_returnEmptySet",
         testNegativeCount_activatedBits_returnEmptySet),
        ("testCountEqualToZero_activatedBits_returnEmptySet",
         testCountEqualToZero_activatedBits_returnEmptySet),
        ("testOne_activatedBits_returnExpectedSet",
         testOne_activatedBits_returnExpectedSet),
        ("testZero_activatedBits_returnEmptySet",
         testZero_activatedBits_returnEmptySet),
        ("testOnlyOnes_activatedBits_returnExpectedSet",
         testOnlyOnes_activatedBits_returnExpectedSet),
        ("testMixedZerosAndOnes_activatedBits_returnExpectedSet",
         testMixedZerosAndOnes_activatedBits_returnExpectedSet),
        ("testMixedZerosAndOnesAndSmallCount_activatedBits_returnExpectedSet",
         testMixedZerosAndOnesAndSmallCount_activatedBits_returnExpectedSet)
    ]
}
