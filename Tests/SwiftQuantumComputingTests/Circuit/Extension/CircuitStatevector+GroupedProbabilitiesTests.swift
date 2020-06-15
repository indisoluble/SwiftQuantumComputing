//
//  CircuitStatevector+GroupedProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/06/2020.
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

class CircuitStatevector_GroupedProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuitStatevector = CircuitStatevectorTestDouble()
    let finalStateVector = try! Vector([
        Complex(real: 1 / sqrt(3), imag: 0),
        Complex.zero,
        Complex.zero,
        Complex.zero,
        Complex(real: 1 / sqrt(3), imag: 0),
        Complex.zero,
        Complex(real: 1 / sqrt(3), imag: 0),
        Complex.zero
    ])

    // MARK: - Auxiliar methods

    func assertEqualGroupedProbabilities(_ one: [String: CircuitStatevector.GroupedProb],
                                         _ other: [String: CircuitStatevector.GroupedProb]) {
        let accuracy = (1.0 / Foundation.pow(10.0, 6))

        let groupOneKeys = Set(one.keys)
        let groupOtherKeys = Set(other.keys)
        if groupOneKeys == groupOtherKeys {
            for groupKey in groupOneKeys {
                XCTAssertEqual(one[groupKey]!.probability,
                               other[groupKey]!.probability,
                               accuracy: accuracy)

                let summaryOneKeys = Set(one[groupKey]!.summary.keys)
                let summaryOtherKeys = Set(other[groupKey]!.summary.keys)
                if summaryOneKeys == summaryOtherKeys {
                    for summaryKey in summaryOneKeys {
                        XCTAssertEqual(one[groupKey]!.summary[summaryKey]!,
                                       other[groupKey]!.summary[summaryKey]!,
                                       accuracy: accuracy)
                    }
                } else {
                    XCTAssert(false)
                }
            }
        } else {
            XCTAssert(false)
        }
    }

    // MARK: - Tests

    func testAnyCircuitStatevectorAndZeroGroupQubits_groupedProbabilities_throwException() {
        // Then
        var error: GroupedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.groupedProbabilities(byQubits: [],
                                                                          summarizedByQubits: [0]) {
            error = e
        }
        XCTAssertEqual(error, .groupQubitsCanNotBeAnEmptyList)
        XCTAssertEqual(circuitStatevector.statevectorCount, 0)
    }

    func testAnyCircuitStatevectorAndRepeatedQubits_groupedProbabilities_throwException() {
        // Then
        var error: GroupedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                          summarizedByQubits: [0]) {
            error = e
        }
        XCTAssertEqual(error, .qubitsAreNotUnique)
        XCTAssertEqual(circuitStatevector.statevectorCount, 0)
    }

    func testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        var error: GroupedProbabilitiesError?
        if case .failure(let e) = circuitStatevector.groupedProbabilities(byQubits: [100],
                                                                          summarizedByQubits: [0]) {
            error = e
        }
        XCTAssertEqual(error, .qubitsAreNotInsideBounds)
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)
    }

    func testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.groupedProbabilities(byQubits: [1],
                                                                  summarizedByQubits: [0]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (2.0 / 3.0, ["0": 1.0]),
                "1": (1.0 / 3.0, ["0": 1.0])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                  summarizedByQubits: [1]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (1.0, ["0": 2.0 / 3.0, "1": 1.0 / 3.0])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testAnyCircuitStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.groupedProbabilities(byQubits: [1]).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (2.0 / 3.0, [:]),
                "1": (1.0 / 3.0, [:])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToOneDec_groupedProbabilities_returnExpectedProbs() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                  summarizedByQubits: [1],
                                                                  roundingSummaryToDecimalPlaces: 1).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (1.0, ["0": 0.7, "1": 0.3])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToZeroDec_groupedProbabilities_returnExpectedProbs() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // When
        let result = try? circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                  summarizedByQubits: [1],
                                                                  roundingSummaryToDecimalPlaces: 0).get()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (1.0, ["0": 1.0])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testAnyCircuitStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                              summarizedByQubits: (1..<3)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: [0],
                                                                              summarizedByQubits: (1...2)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (1..<3),
                                                                              summarizedByQubits: [0]) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (0..<1),
                                                                              summarizedByQubits: (1..<3)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (0..<1),
                                                                              summarizedByQubits: (1...2)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (1...2),
                                                                              summarizedByQubits: [0]) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (1...2),
                                                                              summarizedByQubits: (0..<1)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    func testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuitStatevector.statevectorResult = finalStateVector

        // Then
        var result: [String: CircuitStatevector.GroupedProb]?
        if case .success(let probs) = circuitStatevector.groupedProbabilities(byQubits: (1...2),
                                                                              summarizedByQubits: (0...0)) {
            result = probs
        }
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testAnyCircuitStatevectorAndZeroGroupQubits_groupedProbabilities_throwException",
         testAnyCircuitStatevectorAndZeroGroupQubits_groupedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndRepeatedQubits_groupedProbabilities_throwException",
         testAnyCircuitStatevectorAndRepeatedQubits_groupedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException",
         testAnyCircuitStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException),
        ("testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities",
         testAnyCircuitStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities),
        ("testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToOneDec_groupedProbabilities_returnExpectedProbs",
         testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToOneDec_groupedProbabilities_returnExpectedProbs),
        ("testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToZeroDec_groupedProbabilities_returnExpectedProbs",
         testAnyCircuitStatevectorOneGrpQubitOneSumQubitReversedAndSumRoundedToZeroDec_groupedProbabilities_returnExpectedProbs),
        ("testAnyCircuitStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testAnyCircuitStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException)
    ]
}
