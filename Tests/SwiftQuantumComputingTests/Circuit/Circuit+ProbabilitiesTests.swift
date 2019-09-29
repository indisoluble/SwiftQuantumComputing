//
//  Circuit+ProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/11/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

    // MARK: - Tests

    func testNonEmptyBits_summarizedProbabilitiesWithoutQubits_callMeasureWithExpectedQubitsAndBits() {
        // Given
        let bits = "101"

        // When
        _ = try? circuit.summarizedProbabilities(afterInputting: bits)

        // Then
        let expectedQubits = [2, 1, 0]
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, expectedQubits)
        XCTAssertEqual(circuit.lastMeasureBits, bits)
    }

    func testPreselectedQubits_summarizedProbabilities_callMeasureWithExpectedQubitsAndBits() {
        // Given
        let qubits = [9, 3]
        let bits = "101"

        // When
        _ = try? circuit.summarizedProbabilities(qubits: qubits, afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, qubits)
        XCTAssertEqual(circuit.lastMeasureBits, bits)
    }

    func testCircuitWithNoMeasurements_summarizedProbabilities_throwException() {
        // Given
        circuit.measureResult = nil

        // Then
        XCTAssertThrowsError(try circuit.summarizedProbabilities(qubits: [], afterInputting: ""))
    }

    func testCircuitWithMeasurements_summarizedProbabilities_returnExpectedResult() {
        // Given
        circuit.measureResult = [0, 0, 0, 0.25, 0, 0.25, 0, 0, 0.25, 0, 0, 0, 0, 0.25, 0, 0]

        // When
        let result = try? circuit.summarizedProbabilities(qubits: [], afterInputting: "")

        // Then
        let expectedResult = ["0011": 0.25, "0101": 0.25, "1000": 0.25, "1101": 0.25]
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testNonEmptyBits_summarizedProbabilitiesWithoutQubits_callMeasureWithExpectedQubitsAndBits",
         testNonEmptyBits_summarizedProbabilitiesWithoutQubits_callMeasureWithExpectedQubitsAndBits),
        ("testPreselectedQubits_summarizedProbabilities_callMeasureWithExpectedQubitsAndBits",
         testPreselectedQubits_summarizedProbabilities_callMeasureWithExpectedQubitsAndBits),
        ("testCircuitWithNoMeasurements_summarizedProbabilities_throwException",
         testCircuitWithNoMeasurements_summarizedProbabilities_throwException),
        ("testCircuitWithMeasurements_summarizedProbabilities_returnExpectedResult",
         testCircuitWithMeasurements_summarizedProbabilities_returnExpectedResult)
    ]
}
