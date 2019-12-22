//
//  String+IsBitActivatedTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/12/2019.
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

class String_IsBitActivatedTests: XCTestCase {

    // MARK: - Tests

    func testStringWithOnesAndNegativeIndex_isBitActivated_returnFalse() {
        // Then
        XCTAssertFalse("111".isBitActivated(at: -1))
    }

    func testStringWithOnesAndIndexOutOfBound_isBitActivated_returnFalse() {
        // Given
        let str = "111"

        // Then
        XCTAssertFalse(str.isBitActivated(at: str.count))
    }

    func testStringWithLastBitActiveAndLastIndex_isBitActivated_returnTrue() {
        // Given
        let str = "10000"

        // Then
        XCTAssertTrue(str.isBitActivated(at: str.count - 1))
    }

    func testStringWithLastBitDeactiveAndLastIndex_isBitActivated_returnFalse() {
        // Given
        let str = "01111"

        // Then
        XCTAssertFalse(str.isBitActivated(at: str.count - 1))
    }

    func testStringWithLastBitSetToIncorrectValueAndLastIndex_isBitActivated_returnFalse() {
        // Given
        let str = "A1111"

        // Then
        XCTAssertFalse(str.isBitActivated(at: str.count - 1))
    }

    static var allTests = [
        ("testStringWithOnesAndNegativeIndex_isBitActivated_returnFalse",
         testStringWithOnesAndNegativeIndex_isBitActivated_returnFalse),
        ("testStringWithOnesAndIndexOutOfBound_isBitActivated_returnFalse",
         testStringWithOnesAndIndexOutOfBound_isBitActivated_returnFalse),
        ("testStringWithLastBitActiveAndLastIndex_isBitActivated_returnTrue",
         testStringWithLastBitActiveAndLastIndex_isBitActivated_returnTrue),
        ("testStringWithLastBitDeactiveAndLastIndex_isBitActivated_returnFalse",
         testStringWithLastBitDeactiveAndLastIndex_isBitActivated_returnFalse),
        ("testStringWithLastBitSetToIncorrectValueAndLastIndex_isBitActivated_returnFalse",
         testStringWithLastBitSetToIncorrectValueAndLastIndex_isBitActivated_returnFalse)
    ]
}
