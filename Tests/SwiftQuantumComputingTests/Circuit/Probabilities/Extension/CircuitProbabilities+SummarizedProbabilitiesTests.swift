//
//  CircuitProbabilities+SummarizedProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/06/2020.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class CircuitProbabilities_SummarizedProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuitStatevector = CircuitStatevectorTestDouble()
    let finalStateVector = try! Vector([
        Complex(1 / sqrt(3)),
        .zero,
        .zero,
        .zero,
        Complex(1 / sqrt(3)),
        .zero,
        Complex(1 / sqrt(3)),
        .zero
    ])

    // MARK: - Tests

    func testAnyCircuitStatevector_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([
            .zero,
            Complex(1 / sqrt(2)),
            .zero,
            Complex(imaginary: 1 / sqrt(2)),
        ])

        // When
        let result = circuitStatevector.summarizedProbabilities()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        let expectedResult = [
            "01": 1.0 / 2.0,
            "11": 1.0 / 2.0
        ]

        let keys = Set(result.keys)
        let expectedKeys = Set(expectedResult.keys)
        if keys == expectedKeys {
            for key in keys {
                XCTAssertEqual(result[key]!,
                               expectedResult[key]!,
                               accuracy: SharedConstants.tolerance)
            }
        } else {
            XCTAssert(false)
        }
    }

    func testAnyCircuitStatevectorAndZeroQubits_summarizedProbabilities_throwException() {
        // Then
        var error: SummarizedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.summarizedProbabilities(byQubits: []) {
            error = e
        }
        XCTAssertEqual(error, .qubitsCanNotBeAnEmptyList)
        XCTAssertEqual(circuitStatevector.statevectorCount, 0)
    }

    func testAnyCircuitStatevectorAndRepeatedQubits_summarizedProbabilities_throwException() {
        // Then
        var error: SummarizedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.summarizedProbabilities(byQubits: [0, 0]) {
            error = e
        }
        XCTAssertEqual(error, .qubitsAreNotUnique)
        XCTAssertEqual(circuitStatevector.statevectorCount, 0)
    }

    func testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        var error: SummarizedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.summarizedProbabilities(byQubits: [100, 0]) {
            error = e
        }
        XCTAssertEqual(error, .qubitsAreNotInsideBounds)
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)
    }

    func testAnyCircuitStatevectorAndNegativeQubits_summarizedProbabilities_throwException() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        var error: SummarizedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.summarizedProbabilities(byQubits: [0, -1]) {
            error = e
        }
        XCTAssertEqual(error, .qubitsAreNotInsideBounds)
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)
    }

    func testAnyCircuitStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([
            .zero,
            Complex(1 / sqrt(2)),
            .zero,
            Complex(imaginary: 1 / sqrt(2)),
        ])

        // When
        let result = try? circuitStatevector.summarizedProbabilities(byQubits: [0]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult = ["1": Double(1)]

            let keys = Set(result.keys)
            let expectedKeys = Set(expectedResult.keys)
            if keys == expectedKeys {
                for key in keys {
                    XCTAssertEqual(result[key]!,
                                   expectedResult[key]!,
                                   accuracy: SharedConstants.tolerance)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testAnyCircuitStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.summarizedProbabilities(byQubits: [1, 0]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

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
                    XCTAssertEqual(result[key]!,
                                   expectedResult[key]!,
                                   accuracy: SharedConstants.tolerance)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testAnyCircuitStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.summarizedProbabilities(byQubits: [0, 1]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

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
                    XCTAssertEqual(result[key]!,
                                   expectedResult[key]!,
                                   accuracy: SharedConstants.tolerance)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testAnyCircuitStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([
            Complex.one, Complex.zero, Complex.zero, Complex.zero
        ])

        // Then
        var result: [String: Double]?
        if case .success(let probs) = circuitStatevector.summarizedProbabilities(byQubits: (0..<2)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([
            Complex.one, Complex.zero, Complex.zero, Complex.zero
        ])

        // Then
        var result: [String: Double]?
        if case .success(let probs) = circuitStatevector.summarizedProbabilities(byQubits: (0...1)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testAnyCircuitStatevector_summarizedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevector_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndZeroQubits_summarizedProbabilities_throwException",
         testAnyCircuitStatevectorAndZeroQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndRepeatedQubits_summarizedProbabilities_throwException",
         testAnyCircuitStatevectorAndRepeatedQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException",
         testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_summarizedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndNegativeQubits_summarizedProbabilities_throwException",
         testAnyCircuitStatevectorAndNegativeQubits_summarizedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndOneQubit_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndTwoQubits_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndReversedTwoQubits_summarizedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException",
         testAnyCircuitStatevectorAndQubitRange_summarizedProbabilitiesWithQubitRange_doNotThrowException),
        ("testAnyCircuitStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException",
         testAnyCircuitStatevectorAndQubitClosedRange_summarizedProbabilitiesWithQubitClosedRange_doNotThrowException)
    ]
}
