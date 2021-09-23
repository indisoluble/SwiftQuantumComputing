//
//  CircuitStatevectorAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/06/2020.
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

class CircuitStatevectorAdapterTests: XCTestCase {

    // MARK: - Properties

    let nonPowerOfTwoVector = try! Vector([.zero, .zero, .one])
    let squareModulusNotEqualToOneVector = try! Vector([.zero, .zero, .one, .one])
    let validVector = try! Vector([.zero, .zero, .one, .zero])

    // MARK: - Tests

    func testNonPowerOfTwoVector_init_throwException() {
        // Then
        XCTAssertThrowsError(try CircuitStatevectorAdapter(statevector: nonPowerOfTwoVector))
    }

    func testSquareModulusNotEqualToOneVector_init_throwException() {
        // Then
        XCTAssertThrowsError(try CircuitStatevectorAdapter(statevector: squareModulusNotEqualToOneVector))
    }

    func testValidVector_init_returnValue() {
        // Then
        XCTAssertNoThrow(try CircuitStatevectorAdapter(statevector: validVector))
    }

    static var allTests = [
        ("testNonPowerOfTwoVector_init_throwException",
         testNonPowerOfTwoVector_init_throwException),
        ("testSquareModulusNotEqualToOneVector_init_throwException",
         testSquareModulusNotEqualToOneVector_init_throwException),
        ("testValidVector_init_returnValue",
         testValidVector_init_returnValue)
    ]
}
