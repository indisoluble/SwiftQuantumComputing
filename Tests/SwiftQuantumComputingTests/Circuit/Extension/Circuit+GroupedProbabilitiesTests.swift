//
//  Circuit+GroupedProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 28/03/2020.
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

class Circuit_GroupedProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()
    let bits = "101"
    let initialStatevector = try! Vector([Complex.zero, Complex.zero, Complex.zero, Complex.zero,
                                          Complex.zero, Complex.one, Complex.zero, Complex.zero])
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

    func assertEqualGroupedProbabilities(_ one: [String: Circuit.GroupedProb],
                                         _ other: [String: Circuit.GroupedProb]) {
        let groupOneKeys = Set(one.keys)
        let groupOtherKeys = Set(other.keys)
        if groupOneKeys == groupOtherKeys {
            for groupKey in groupOneKeys {
                XCTAssertEqual(one[groupKey]!.probability,
                               other[groupKey]!.probability,
                               accuracy: 0.001)

                let summaryOneKeys = Set(one[groupKey]!.summary.keys)
                let summaryOtherKeys = Set(other[groupKey]!.summary.keys)
                if summaryOneKeys == summaryOtherKeys {
                    for summaryKey in summaryOneKeys {
                        XCTAssertEqual(one[groupKey]!.summary[summaryKey]!,
                                       other[groupKey]!.summary[summaryKey]!,
                                       accuracy: 0.001)
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

    func testAnyCircuitAndZeroGroupQubits_groupedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.groupedProbabilities(byQubits: [],
                                                              summarizedByQubits: [0],
                                                              withInitialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testAnyCircuitAndRepeatedQubits_groupedProbabilities_throwException() {
        // Then
        XCTAssertThrowsError(try circuit.groupedProbabilities(byQubits: [0],
                                                              summarizedByQubits: [0],
                                                              withInitialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 0)
    }

    func testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException() {
        // Given
        circuit.statevectorResult = try! Vector([Complex.zero, Complex.one])

        // Then
        XCTAssertThrowsError(try circuit.groupedProbabilities(byQubits: [100],
                                                              summarizedByQubits: [0],
                                                              withInitialBits: bits))
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)
    }

    func testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = finalStateVector

        // When
        let result = try? circuit.groupedProbabilities(byQubits: [1],
                                                       summarizedByQubits: [0],
                                                       withInitialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (2.0 / 3.0, ["0": 1.0]),
                "1": (1.0 / 3.0, ["0": 1.0])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = finalStateVector

        // When
        let result = try? circuit.groupedProbabilities(byQubits: [0],
                                                       summarizedByQubits: [1],
                                                       withInitialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (1.0, ["0": 2.0 / 3.0, "1": 1.0 / 3.0])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testCircuitThatReturnStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities() {
        // Given
        circuit.statevectorResult = finalStateVector

        // When
        let result = try? circuit.groupedProbabilities(byQubits: [1], withInitialBits: bits)

        // Then
        XCTAssertEqual(circuit.statevectorCount, 1)
        XCTAssertEqual(circuit.lastStatevectorInitialStatevector, initialStatevector)

        XCTAssertNotNil(result)
        if let result = result {
            let expectedResult: [String: Circuit.GroupedProb] = [
                "0": (2.0 / 3.0, [:]),
                "1": (1.0 / 3.0, [:])
            ]
            assertEqualGroupedProbabilities(result, expectedResult)
        }
    }

    func testCircuitThatReturnStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: [0],
                                                          summarizedByQubits: (1..<3),
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: [0],
                                                          summarizedByQubits: (1...2),
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (1..<3),
                                                          summarizedByQubits: [0],
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (0..<1),
                                                          summarizedByQubits: (1..<3),
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (0..<1),
                                                          summarizedByQubits: (1...2),
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (1...2),
                                                          summarizedByQubits: [0],
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (1...2),
                                                          summarizedByQubits: (0..<1),
                                                          withInitialBits: bits))
    }

    func testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException() {
        // Given
        circuit.statevectorResult = finalStateVector

        // Then
        XCTAssertNoThrow(try circuit.groupedProbabilities(byQubits: (1...2),
                                                          summarizedByQubits: (0...0),
                                                          withInitialBits: bits))
    }

    static var allTests = [
        ("testAnyCircuitAndZeroGroupQubits_groupedProbabilities_throwException",
         testAnyCircuitAndZeroGroupQubits_groupedProbabilities_throwException),
        ("testAnyCircuitAndRepeatedQubits_groupedProbabilities_throwException",
         testAnyCircuitAndRepeatedQubits_groupedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException",
         testCircuitThatReturnStatevectorAndQubitsOutOfBoundsOfVector_groupedProbabilities_throwException),
        ("testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubit_groupedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndOneGroupQubitAndOneSummaryQubitReversed_groupedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities",
         testCircuitThatReturnStatevectorAndOneGroupQubitAndZeroSummaryQubit_groupedProbabilities_returnExpectedProbabilities),
        ("testCircuitThatReturnStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitClosedRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitRange_groupedProbabilities_doNotThrowException),
        ("testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException",
         testCircuitThatReturnStatevectorAndGroupQubitClosedRangeAndSummaryQubitClosedRange_groupedProbabilities_doNotThrowException)
    ]
}
