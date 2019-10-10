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

    // MARK: - Tests

    func testCircuitThatThrowException_probabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.probabilities(afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)
    }

    func testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = [
            Complex(0),
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex(0),
            Complex(real: 0, imag: 1 / sqrt(2)),
        ]

        // When
        let result = try? circuit.probabilities(afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)

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

    func testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = [
            Complex(0),
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex(0),
            Complex(real: 0, imag: 1 / sqrt(2)),
        ]

        // When
        let result = try? circuit.summarizedProbabilities(afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = [
                "01": 1.0 / 2.0,
                "11": 1.0 / 2.0
            ]

            let keys = Set(result.keys)
            let expectedKeys = Set(expectedResult.keys)
            if keys == expectedKeys {
                for key in keys {
                    XCTAssertEqual(result[key]!, expectedResult[key]!, accuracy: 0.001)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testAnyCircuitAndZeroQubits_summarizedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [], afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [0, 0],
                                                                 afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testAnyCircuitAndUnsortedQubits_summarizedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [0, 1],
                                                                 afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException() {
        // Given
        circuit.statevectorResult = [Complex(0), Complex(1)]

        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [100, 0],
                                                                 afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)
    }

    func testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException() {
        // Given
        circuit.statevectorResult = [Complex(0), Complex(1)]

        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [0, -1],
                                                                 afterInputting: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)
    }

    func testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = [
            Complex(0),
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex(0),
            Complex(real: 0, imag: 1 / sqrt(2)),
        ]

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [0], afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = ["1": Double(1)]

            let keys = Set(result.keys)
            let expectedKeys = Set(expectedResult.keys)
            if keys == expectedKeys {
                for key in keys {
                    XCTAssertEqual(result[key]!, expectedResult[key]!, accuracy: 0.001)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testCircuitThatReturnStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = [
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex(0),
            Complex(0),
            Complex(0),
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex(0),
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex(0)
        ]

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [1, 0], afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorAfterInputting, bits)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = [
                "00": 2.0 / 3.0,
                "10": 1.0 / 3.0
            ]

            let keys = Set(result.keys)
            let expectedKeys = Set(expectedResult.keys)
            if keys == expectedKeys {
                for key in keys {
                    XCTAssertEqual(result[key]!, expectedResult[key]!, accuracy: 0.001)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    static var allTests = [
        ("testCircuitThatThrowException_probabilities_throwException",
         testCircuitThatThrowException_probabilities_throwException),
        ("testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevector_probabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitAndZeroQubits_summarizedProbabilities_throwException",
         testAnyCircuitAndZeroQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException",
         testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitAndUnsortedQubits_summarizedProbabilities_throwException",
         testAnyCircuitAndUnsortedQubits_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException",
         testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException",
         testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities)
    ]
}
