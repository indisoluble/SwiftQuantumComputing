//
//  Double+RoundedToDecimalPlacesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/04/2020.
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

class Double_RoundedToDecimalPlacesTests: XCTestCase {

    // MARK: - Tests

    func testDoubleNearToNextDouble_roundedToDecimalPlaces_returnExpectedDouble() {
        // Given
        let value = 1.6789

        // Then
        XCTAssertEqual(value.rounded(toDecimalPlaces: 0), 2.0)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 1), 1.7)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 2), 1.68)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 3), 1.679)
    }

    func testDoubleAwayFromNextDouble_roundedToDecimalPlaces_returnExpectedDouble() {
        // Given
        let value = 1.4321

        // Then
        XCTAssertEqual(value.rounded(toDecimalPlaces: 0), 1.0)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 1), 1.4)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 2), 1.43)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 3), 1.432)
    }

    func testDoubleInTheMiddle_roundedToDecimalPlaces_returnExpectedDouble() {
        // Given
        let value = 1.5555

        // Then
        XCTAssertEqual(value.rounded(toDecimalPlaces: 0), 2.0)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 1), 1.6)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 2), 1.56)
        XCTAssertEqual(value.rounded(toDecimalPlaces: 3), 1.556)
    }

    func testPeriodicNumber_roundedToDecimalPlaces_returnExpectedDouble() {
        // Given
        let periodic = (10.0 / 3.0)

        // Then
        XCTAssertEqual(periodic.rounded(toDecimalPlaces: 0), 3.0)
        XCTAssertEqual(periodic.rounded(toDecimalPlaces: 1), 3.3)
        XCTAssertEqual(periodic.rounded(toDecimalPlaces: 2), 3.33)
    }

    static var allTests = [
        ("testDoubleNearToNextDouble_roundedToDecimalPlaces_returnExpectedDouble",
         testDoubleNearToNextDouble_roundedToDecimalPlaces_returnExpectedDouble),
        ("testDoubleAwayFromNextDouble_roundedToDecimalPlaces_returnExpectedDouble",
         testDoubleAwayFromNextDouble_roundedToDecimalPlaces_returnExpectedDouble),
        ("testDoubleInTheMiddle_roundedToDecimalPlaces_returnExpectedDouble",
         testDoubleInTheMiddle_roundedToDecimalPlaces_returnExpectedDouble),
        ("testPeriodicNumber_roundedToDecimalPlaces_returnExpectedDouble",
         testPeriodicNumber_roundedToDecimalPlaces_returnExpectedDouble)
    ]
}
