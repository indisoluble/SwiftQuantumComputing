//
//  Circuit+SummarizedProbabilitiesTests.swift
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

class Circuit_SummarizedProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()
    let bits = "101"
    let initialStatevector = try! Vector([Complex.zero, Complex.zero, Complex.zero, Complex.zero,
                                          Complex.zero, Complex.one, Complex.zero, Complex.zero])

    // MARK: - Tests

    func testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex.zero,
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex.zero,
            Complex(real: 0, imag: 1 / sqrt(2)),
        ])

        // When
        let result = try? circuit.summarizedProbabilities(withInitialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

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
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [], initialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [0, 0], initialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException() {
        // Given
        circuit.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [100, 0],
                                                                 initialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)
    }

    func testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException() {
        // Given
        circuit.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [0, -1],
                                                                 initialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)
    }

    func testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex.zero,
            Complex(real: 1 / sqrt(2), imag: 0),
            Complex.zero,
            Complex(real: 0, imag: 1 / sqrt(2)),
        ])

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [0], initialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

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
        circuit.statevectorResult = try! Vector([
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero,
            Complex.zero,
            Complex.zero,
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero,
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero
        ])

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [1, 0], initialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

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

    func testCircuitThatReturnStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero,
            Complex.zero,
            Complex.zero,
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero,
            Complex(real: 1 / sqrt(3), imag: 0),
            Complex.zero
        ])

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [0, 1], initialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = [
                "00": 2.0 / 3.0,
                "01": 1.0 / 3.0
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

    func testCircuitThatReturnStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex.one, Complex.zero, Complex.zero, Complex.zero
        ])

        // Then
        XCTAssertNoThrow(try circuit.summarizedProbabilities(qubits: (0..<2), initialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException() {
        // Given
        circuit.statevectorResult = try! Vector([
            Complex.one, Complex.zero, Complex.zero, Complex.zero
        ])

        // Then
        XCTAssertNoThrow(try circuit.summarizedProbabilities(qubits: (0...1), initialBits: bits))
    }

    static var allTests = [
        ("testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevector_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitAndZeroQubits_summarizedProbabilities_throwException",
         testAnyCircuitAndZeroQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException",
         testAnyCircuitAndRepeatedQubits_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException",
         testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException",
         testCircuitThatReturnStatevectorAndNegativeQubits_summarizedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException",
         testCircuitThatReturnStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException",
         testCircuitThatReturnStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException)
    ]
}
