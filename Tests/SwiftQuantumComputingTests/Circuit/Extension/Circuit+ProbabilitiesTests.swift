//
//  Circuit+ProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/10/2019.
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

class Circuit_ProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()
    let bits = "101"
    let initialStatevector = try! Vector([Complex(0), Complex(0), Complex(0), Complex(0),
                                          Complex(0), Complex(1), Complex(0), Complex(0)])

    // MARK: - Tests

    func testCircuitThatThrowException_probabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.probabilities(withInitialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)
    }

    func testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex(0),
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex(0),
            Complex(real: 0, imag: 1 / sqrt(2)),
        ])

        // When
        let result = try? circuit.probabilities(withInitialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = [
                Double(0),
                1.0 / 2.0,
                Double(0),
                1.0 / 2.0
            ]

            for (value, expectedValue) in zip(result, expectedResult) {
                XCTAssertEqual(value, expectedValue, accuracy: 0.001)
            }
        }
    }

    static var allTests = [
        ("testCircuitThatThrowException_probabilities_throwException",
         testCircuitThatThrowException_probabilities_throwException),
        ("testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities)
    ]
}
