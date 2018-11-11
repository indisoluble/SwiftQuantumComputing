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

    func testCircuitWithFixedQubitCount_probabilitiesWithouQubits_callMeasureWithExpectedQubits() {
        // Given
        circuit.qubitCountResult = 3

        // When
        _ = circuit.probabilities()

        // Then
        let expectedQubits = [2, 1, 0]
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, expectedQubits)
    }

    func testPreselectedQubits_probabilities_callMeasureWithExpectedQubits() {
        // Given
        let qubits = [9, 3]

        // When
        _ = circuit.probabilities(qubits: qubits)

        // Then
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureQubits, qubits)
    }

    func testCircuitWithNoMeasurements_probabilities_returnNil() {
        // Given
        circuit.measureResult = nil

        // Then
        XCTAssertNil(circuit.probabilities(qubits: []))
    }

    func testCircuitWithMeasurements_probabilities_returnExpectedResult() {
        // Given
        circuit.measureResult = [0, 0, 0, 0.25, 0, 0.25, 0, 0, 0.25, 0, 0, 0, 0, 0.25, 0, 0]

        // When
        let result = circuit.probabilities(qubits: [])

        // Then
        let expectedResult = ["0011": 0.25, "0101": 0.25, "1000": 0.25, "1101": 0.25]
        XCTAssertEqual(result, expectedResult)
    }
}
