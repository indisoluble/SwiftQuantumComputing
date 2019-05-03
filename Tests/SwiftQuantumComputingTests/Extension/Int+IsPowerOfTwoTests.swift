//
//  Int+IsPowerOfTwoTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 11/08/2018.
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

class Int_IsPowerOfTwoTests: XCTestCase {

    // MARK: - Tests

    func testNegativeInt_isPowerOfTwo_returnFalse() {
        // Then
        XCTAssertFalse((-1024).isPowerOfTwo)
    }

    func testZero_isPowerOfTwo_returnFalse() {
        // Then
        XCTAssertFalse(0.isPowerOfTwo)
    }

    func testPositiveIntNotPowerOfTwo_isPowerOfTwo_returnFalse() {
        // Then
        XCTAssertFalse(9.isPowerOfTwo)
    }

    func testPositiveIntPowerOfTwo_isPowerOfTwo_returnFalse() {
        // Then
        XCTAssertTrue(1024.isPowerOfTwo)
    }
}
