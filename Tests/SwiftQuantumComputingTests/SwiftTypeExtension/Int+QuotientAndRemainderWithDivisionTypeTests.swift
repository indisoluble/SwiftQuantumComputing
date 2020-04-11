//
//  Int+QuotientAndRemainderWithDivisionTypeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/02/2020.
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

class Int_QuotientAndRemainderWithDivisionTypeTests: XCTestCase {

    // MARK: - Tests

    func testAnyValues_euclidenaQuotientAndRemainder_returnExpectedValue() {
        // Then
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .euclidean).quotient, 4)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .euclidean).remainder, 1)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .euclidean).quotient, -5)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .euclidean).remainder, 2)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .euclidean).quotient, -4)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .euclidean).remainder, 1)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .euclidean).quotient, 5)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .euclidean).remainder, 2)
    }

    func testAnyValues_flooredQuotientAndRemainder_returnExpectedValue() {
        // Then
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .floored).quotient, 4)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .floored).remainder, 1)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .floored).quotient, -5)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .floored).remainder, 2)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .floored).quotient, -5)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .floored).remainder, -2)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .floored).quotient, 4)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .floored).remainder, -1)
    }

    func testAnyValues_swiftQuotientAndRemainder_returnExpectedValue() {
        // Then
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .swift).quotient, 4)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: 3, division: .swift).remainder, 1)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .swift).quotient, -4)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: 3, division: .swift).remainder, -1)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .swift).quotient, -4)
        XCTAssertEqual(13.quotientAndRemainder(dividingBy: -3, division: .swift).remainder, 1)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .swift).quotient, 4)
        XCTAssertEqual((-13).quotientAndRemainder(dividingBy: -3, division: .swift).remainder, -1)
    }

    static var allTests = [
        ("testAnyValues_euclidenaQuotientAndRemainder_returnExpectedValue",
         testAnyValues_euclidenaQuotientAndRemainder_returnExpectedValue),
        ("testAnyValues_flooredQuotientAndRemainder_returnExpectedValue",
         testAnyValues_flooredQuotientAndRemainder_returnExpectedValue),
        ("testAnyValues_swiftQuotientAndRemainder_returnExpectedValue",
         testAnyValues_swiftQuotientAndRemainder_returnExpectedValue)
    ]
}
