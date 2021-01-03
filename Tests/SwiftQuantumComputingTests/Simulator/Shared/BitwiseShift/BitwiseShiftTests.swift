//
//  BitwiseShiftTests.swift
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

class BitwiseShiftTests: XCTestCase {

    // MARK: - Tests

    func testAnyOriginAndDestination_init_setPropertiesToExpectedValues() {
        // When
        let sut = BitwiseShift(origin: 4, destination: 2)

        // Then
        XCTAssertEqual(sut.selectMask, 16)
        XCTAssertEqual(sut.placesToTheRight, 2)
    }

    func testOtherOriginAndDestination_init_setPropertiesToExpectedValues() {
        // When
        let sut = BitwiseShift(origin: 2, destination: 4)

        // Then
        XCTAssertEqual(sut.selectMask, 4)
        XCTAssertEqual(sut.placesToTheRight, -2)
    }

    func testOriginEqualToDestination_init_setPropertiesToExpectedValues() {
        // When
        let sut = BitwiseShift(origin: 4, destination: 4)

        // Then
        XCTAssertEqual(sut.selectMask, 16)
        XCTAssertEqual(sut.placesToTheRight, 0)
    }

    func testOriginOutOfRange_init_setPropertiesToExpectedValues() {
        // When
        let sut = BitwiseShift(origin: 1000, destination: 1)

        // Then
        XCTAssertEqual(sut.selectMask, 0)
        XCTAssertEqual(sut.placesToTheRight, 999)
    }

    func testAnyBitwiseShiftAndValue_perform_returnExpectedValue() {
        // Given
        let sut = BitwiseShift(origin: 4, destination: 2)

        // Then
        XCTAssertEqual(sut.perform(on: 16), 4)
    }

    func testBitwiseWithEqualOriginAndDestination_perform_returnExpectedValue() {
        // Given
        let sut = BitwiseShift(origin: 4, destination: 4)

        // Then
        XCTAssertEqual(sut.perform(on: 17), 16)
    }

    static var allTests = [
        ("testAnyOriginAndDestination_init_setPropertiesToExpectedValues",
         testAnyOriginAndDestination_init_setPropertiesToExpectedValues),
        ("testOtherOriginAndDestination_init_setPropertiesToExpectedValues",
         testOtherOriginAndDestination_init_setPropertiesToExpectedValues),
        ("testOriginEqualToDestination_init_setPropertiesToExpectedValues",
         testOriginEqualToDestination_init_setPropertiesToExpectedValues),
        ("testOriginOutOfRange_init_setPropertiesToExpectedValues",
         testOriginOutOfRange_init_setPropertiesToExpectedValues),
        ("testAnyBitwiseShiftAndValue_perform_returnExpectedValue",
         testAnyBitwiseShiftAndValue_perform_returnExpectedValue),
        ("testBitwiseWithEqualOriginAndDestination_perform_returnExpectedValue",
         testBitwiseWithEqualOriginAndDestination_perform_returnExpectedValue)
    ]
}
