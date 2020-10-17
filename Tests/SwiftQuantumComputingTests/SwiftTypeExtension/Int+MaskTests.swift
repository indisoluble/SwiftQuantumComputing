//
//  Int+MaskTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/10/2020.
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

class Int_MaskTests: XCTestCase {

    // MARK: - Tests

    func testEmptyList_mask_returnZero() {
        // Then
        XCTAssertEqual(Int.mask(activatingBitsAt: []), 0)
    }

    func testActivatingZero_mask_returnOne() {
        // Then
        XCTAssertEqual(Int.mask(activatingBitsAt: [0]), 1)
    }

    func testActivatingTwoOnes_mask_returnTwo() {
        // Then
        XCTAssertEqual(Int.mask(activatingBitsAt: [1, 1]), 2)
    }

    func testActivatingOneAndZero_mask_returnThree() {
        // Then
        XCTAssertEqual(Int.mask(activatingBitsAt: [1, 0]), 3)
    }

    func testActivatingOneAndFour_mask_returnEighteen() {
        // Then
        XCTAssertEqual(Int.mask(activatingBitsAt: [1, 4]), 18)
    }

    static var allTests = [
        ("testEmptyList_mask_returnZero",
         testEmptyList_mask_returnZero),
        ("testActivatingZero_mask_returnOne",
         testActivatingZero_mask_returnOne),
        ("testActivatingTwoOnes_mask_returnTwo",
         testActivatingTwoOnes_mask_returnTwo),
        ("testActivatingOneAndZero_mask_returnThree",
         testActivatingOneAndZero_mask_returnThree),
        ("testActivatingOneAndFour_mask_returnEighteen",
         testActivatingOneAndFour_mask_returnEighteen)
    ]
}
