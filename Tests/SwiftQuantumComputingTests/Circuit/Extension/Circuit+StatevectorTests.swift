//
//  Circuit+StatevectorTests.swift
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

class Circuit_StatevectorTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()

    // MARK: - Tests

    func testEmptyBitsString_statevectorWithInitialBits_throwException() {
        // Then
        var error: StatevectorError?
        if case .failure(let e) = circuit.statevector(withInitialBits: "") {
            error = e
        }
        XCTAssertEqual(error, .initialBitsAreNotAStringComposedOnlyOfZerosAndOnes)
        XCTAssertEqual(circuit.gatesCount, 0)
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testBitsStringWithLeadingSpaces_statevectorWithInitialBits_throwException() {
        // Then
        var error: StatevectorError?
        if case .failure(let e) = circuit.statevector(withInitialBits: "  1001") {
            error = e
        }
        XCTAssertEqual(error, .initialBitsAreNotAStringComposedOnlyOfZerosAndOnes)
        XCTAssertEqual(circuit.gatesCount, 0)
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testBitsStringWithTrailingSpaces_statevectorWithInitialBits_throwException() {
        // Then
        var error: StatevectorError?
        if case .failure(let e) = circuit.statevector(withInitialBits: "1001  ") {
            error = e
        }
        XCTAssertEqual(error, .initialBitsAreNotAStringComposedOnlyOfZerosAndOnes)
        XCTAssertEqual(circuit.gatesCount, 0)
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testBitsStringWithWrongCharacter_statevectorWithInitialBits_throwException() {
        // Then
        var error: StatevectorError?
        if case .failure(let e) = circuit.statevector(withInitialBits: "10#1") {
            error = e
        }
        XCTAssertEqual(error, .initialBitsAreNotAStringComposedOnlyOfZerosAndOnes)
        XCTAssertEqual(circuit.gatesCount, 0)
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testValidBitString_statevectorWithInitialBits_produceExpectedVector() {
        // Given
        let bits = "011"

        // When
        _ = circuit.statevector(withInitialBits: bits)

        // Then
        let initialElements = [Complex.zero, Complex.zero, Complex.zero, Complex.one,
                               Complex.zero, Complex.zero, Complex.zero, Complex.zero]
        let expectedInitialStatevector = try! Vector(initialElements)

        XCTAssertEqual(circuit.gatesCount, 0)
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, expectedInitialStatevector)
    }

    func testCircuitWithKnownQubitCount_statevector_produceExpectedVector() {
        // Given
        let gates = [Gate.not(target: 0), Gate.hadamard(target: 2)]

        circuit.gatesResult = gates

        // When
        _ = circuit.statevector()

        // Then
        let initialElements = [Complex.one, Complex.zero, Complex.zero, Complex.zero,
                               Complex.zero, Complex.zero, Complex.zero, Complex.zero]
        let expectedInitialStatevector = try! Vector(initialElements)

        XCTAssertEqual(circuit.gatesCount, 1)
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, expectedInitialStatevector)
    }

    static var allTests = [
        ("testEmptyBitsString_statevectorWithInitialBits_throwException",
         testEmptyBitsString_statevectorWithInitialBits_throwException),
        ("testBitsStringWithLeadingSpaces_statevectorWithInitialBits_throwException",
         testBitsStringWithLeadingSpaces_statevectorWithInitialBits_throwException),
        ("testBitsStringWithTrailingSpaces_statevectorWithInitialBits_throwException",
         testBitsStringWithTrailingSpaces_statevectorWithInitialBits_throwException),
        ("testBitsStringWithWrongCharacter_statevectorWithInitialBits_throwException",
         testBitsStringWithWrongCharacter_statevectorWithInitialBits_throwException),
        ("testValidBitString_statevectorWithInitialBits_produceExpectedVector",
         testValidBitString_statevectorWithInitialBits_produceExpectedVector),
        ("testCircuitWithKnownQubitCount_statevector_produceExpectedVector",
         testCircuitWithKnownQubitCount_statevector_produceExpectedVector)
    ]
}
