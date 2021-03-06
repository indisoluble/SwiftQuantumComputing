//
//  Int+TruthTableEntryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/04/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class Int_TruthTableEntryTests: XCTestCase {

    // MARK: - Tests

    func testTruthShorterThanTruthCount_int_returnExpectedEntry() {
        // When
        let entry = try! TruthTableEntry(truth: "1", truthCount: 3)

        // Then
        XCTAssertEqual(Int(entry), 1)
    }

    func testTruthLongerThanTruthCountAndZerosAtTheBegining_int_returnExpectedEntry() {
        // When
        let entry = try! TruthTableEntry(truth: "000011", truthCount: 3)

        // Then
        XCTAssertEqual(Int(entry), 3)
    }

    static var allTests = [
        ("testTruthShorterThanTruthCount_int_returnExpectedEntry",
         testTruthShorterThanTruthCount_int_returnExpectedEntry),
        ("testTruthLongerThanTruthCountAndZerosAtTheBegining_int_returnExpectedEntry",
         testTruthLongerThanTruthCountAndZerosAtTheBegining_int_returnExpectedEntry)
    ]
}
