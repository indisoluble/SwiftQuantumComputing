//
//  Circuit+StatevectorWithInitialBitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/11/2019.
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

class Circuit_StatevectorWithInitialBitsTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()

    // MARK: - Tests

    func testEmptyBitsString_statevector_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.statevector(withInitialBits: ""))
    }

    func testBitsStringWithLeadingSpaces_statevector_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.statevector(withInitialBits: "  1001"))
    }

    func testBitsStringWithTrailingSpaces_statevector_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.statevector(withInitialBits: "1001  "))
    }

    func testBitsStringWithWrongCharacter_statevector_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.statevector(withInitialBits: "10#1"))
    }

    func testValidBitString_statevector_produceExpectedVector() {
        // Given
        let bits = "011"

        // When
        _ = try? circuit.statevector(withInitialBits: bits)

        // Then
        let expectedElements = [Complex(0), Complex(0), Complex(0), Complex(1),
                                Complex(0), Complex(0), Complex(0), Complex(0)]
        let expectedInitialStatevector = try! Vector(expectedElements)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, expectedInitialStatevector)
    }

    static var allTests = [
        ("testEmptyBitsString_statevector_throwException",
         testEmptyBitsString_statevector_throwException),
        ("testBitsStringWithLeadingSpaces_statevector_throwException",
         testBitsStringWithLeadingSpaces_statevector_throwException),
        ("testBitsStringWithTrailingSpaces_statevector_throwException",
         testBitsStringWithTrailingSpaces_statevector_throwException),
        ("testBitsStringWithWrongCharacter_statevector_throwException",
         testBitsStringWithWrongCharacter_statevector_throwException),
        ("testValidBitString_statevector_produceExpectedVector",
         testValidBitString_statevector_produceExpectedVector)
    ]
}
