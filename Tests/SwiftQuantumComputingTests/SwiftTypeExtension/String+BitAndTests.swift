//
//  String+BitAndTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/01/2020.
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

class String_BitAndTests: XCTestCase {

    // MARK: - Tests

    func testInvalidInputA_bitAnd_returnNil() {
        // Then
        XCTAssertNil("a00" & "000")
    }

    func testInvalidInputB_bitAnd_returnNil() {
        // Then
        XCTAssertNil("000" & "a00")
    }

    func testTwoValidInputsWithSameLength_bitAnd_returnExpectedResult() {
        // Then
        XCTAssertEqual("0011" & "0101", "0001")
    }

    func testTwoValidInputsWithDifferentLength_bitAnd_returnExpectedResult() {
        // Then
        XCTAssertEqual("11" & "0101", "0001")
    }

    static var allTests = [
        ("testInvalidInputA_bitAnd_returnNil",
         testInvalidInputA_bitAnd_returnNil),
        ("testInvalidInputB_bitAnd_returnNil",
         testInvalidInputB_bitAnd_returnNil),
        ("testTwoValidInputsWithSameLength_bitAnd_returnExpectedResult",
         testTwoValidInputsWithSameLength_bitAnd_returnExpectedResult),
        ("testTwoValidInputsWithDifferentLength_bitAnd_returnExpectedResult",
         testTwoValidInputsWithDifferentLength_bitAnd_returnExpectedResult)
    ]
}
