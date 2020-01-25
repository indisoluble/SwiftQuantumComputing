//
//  String+BitXorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/12/2019.
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

class String_BitXorTests: XCTestCase {

    // MARK: - Tests

    func testInvalidString_bitXor_returnNil() {
        // Then
        XCTAssertNil("a00".bitXor())
    }

    func testValidString_bitXor_returnTrue() {
        // Then
        XCTAssertTrue("11010".bitXor()!)
    }

    func testValidString_bitXor_returnFalse() {
        // Then
        XCTAssertFalse("110101".bitXor()!)
    }

    func testInvalidInputA_bitXor_returnNil() {
        // Then
        XCTAssertNil(String.bitXor("a00", "000"))
    }

    func testInvalidInputB_bitXor_returnNil() {
        // Then
        XCTAssertNil(String.bitXor("000", "a00"))
    }

    func testTwoValidInputsWithSameLength_bitXor_returnExpectedResult() {
        // Given
        let inputA = "0011"
        let inputB = "0101"

        // Then
        XCTAssertEqual(String.bitXor(inputA, inputB), "0110")
    }

    func testTwoValidInputsWithDifferentLength_bitXor_returnExpectedResult() {
        // Given
        let inputA = "11"
        let inputB = "0101"

        // Then
        XCTAssertEqual(String.bitXor(inputA, inputB), "0110")
    }

    static var allTests = [
        ("testInvalidString_bitXor_returnNil",
         testInvalidString_bitXor_returnNil),
        ("testValidString_bitXor_returnTrue",
         testValidString_bitXor_returnTrue),
        ("testValidString_bitXor_returnFalse",
         testValidString_bitXor_returnFalse),
        ("testInvalidInputA_bitXor_returnNil",
         testInvalidInputA_bitXor_returnNil),
        ("testInvalidInputB_bitXor_returnNil",
         testInvalidInputB_bitXor_returnNil),
        ("testTwoValidInputsWithSameLength_bitXor_returnExpectedResult",
         testTwoValidInputsWithSameLength_bitXor_returnExpectedResult),
        ("testTwoValidInputsWithDifferentLength_bitXor_returnExpectedResult",
         testTwoValidInputsWithDifferentLength_bitXor_returnExpectedResult)
    ]
}
