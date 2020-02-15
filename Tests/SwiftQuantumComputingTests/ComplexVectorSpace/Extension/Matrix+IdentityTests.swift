//
//  Matrix+IdentityTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/02/2020.
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

class Matrix_IdentityTests: XCTestCase {

    // MARK: - Tests

    func testCountEqualToZero_makeIdentity_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix.makeIdentity(count: 0))
    }

    func testCountBiggerThanZero_makeIdentity_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeIdentity(count: 3)

        // Then
        let expectedMatrix = try? Matrix([[Complex.one, Complex.zero, Complex.zero],
                                          [Complex.zero, Complex.one, Complex.zero],
                                          [Complex.zero, Complex.zero, Complex.one]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    static var allTests = [
        ("testCountEqualToZero_makeIdentity_throwException",
         testCountEqualToZero_makeIdentity_throwException),
        ("testCountBiggerThanZero_makeIdentity_returnExpectedMatrix",
         testCountBiggerThanZero_makeIdentity_returnExpectedMatrix)
    ]
}
