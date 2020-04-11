//
//  Rational+QuotientAndRemainderWithDivisionTypeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/03/2020.
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

class Rational_QuotientAndRemainderWithDivisionTypeTests: XCTestCase {

    // MARK: - Tests

    func testAnyRational_quotientAndRemainder_returnExpectedValues() {
        // Given
        let value = try! Rational(numerator: 13, denominator: 3)

        // When
        let (quotient, remainder) = value.quotientAndRemainder()

        // Then
        XCTAssertEqual(quotient, 4)
        XCTAssertEqual(remainder, 1)
    }

    static var allTests = [
        ("testAnyRational_quotientAndRemainder_returnExpectedValues",
         testAnyRational_quotientAndRemainder_returnExpectedValues)
    ]
}
