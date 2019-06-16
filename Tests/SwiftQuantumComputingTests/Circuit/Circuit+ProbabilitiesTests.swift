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

    func testNonEmptyBits_probabilitiesWithouQubits_callMeasureWithExpectedQubitsAndBits() {
        // Given
        let bits = "101"

        // When
        _ = try? circuit.probabilities(afterInputting: bits)

        // Then
        let expectedQubits = [2, 1, 0]
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, expectedQubits)
        XCTAssertEqual(circuit.lastMeasureBits, bits)
    }

    func testPreselectedQubits_probabilities_callMeasureWithExpectedQubitsAndBits() {
        // Given
        let qubits = [9, 3]
        let bits = "101"

        // When
        _ = try? circuit.probabilities(qubits: qubits, afterInputting: bits)

        // Then
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, qubits)
        XCTAssertEqual(circuit.lastMeasureBits, bits)
    }

    func testCircuitWithNoMeasurements_probabilities_throwException() {
        // Given
        circuit.measureResult = nil

        // Then
        XCTAssertThrowsError(try circuit.probabilities(qubits: [], afterInputting: ""))
    }

    func testCircuitWithMeasurements_probabilities_returnExpectedResult() {
        // Given
        circuit.measureResult = [0, 0, 0, 0.25, 0, 0.25, 0, 0, 0.25, 0, 0, 0, 0, 0.25, 0, 0]

        // When
        let result = try? circuit.probabilities(qubits: [], afterInputting: "")

        // Then
        let expectedResult = ["0011": 0.25, "0101": 0.25, "1000": 0.25, "1101": 0.25]
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testNonEmptyBits_probabilitiesWithouQubits_callMeasureWithExpectedQubitsAndBits",
         testNonEmptyBits_probabilitiesWithouQubits_callMeasureWithExpectedQubitsAndBits),
        ("testPreselectedQubits_probabilities_callMeasureWithExpectedQubitsAndBits",
         testPreselectedQubits_probabilities_callMeasureWithExpectedQubitsAndBits),
        ("testCircuitWithNoMeasurements_probabilities_throwException",
         testCircuitWithNoMeasurements_probabilities_throwException),
        ("testCircuitWithMeasurements_probabilities_returnExpectedResult",
         testCircuitWithMeasurements_probabilities_returnExpectedResult)
    ]
}
