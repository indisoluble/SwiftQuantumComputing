//
//  CircuitStatevector+ProbabilitiesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/06/2020.
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

class CircuitStatevector_ProbabilitiesTests: XCTestCase {

    // MARK: - Properties

    let circuitStatevector = CircuitStatevectorTestDouble()

    // MARK: - Tests

    func testAnyCircuitStatevector_probabilities_returnExpectedProbabilities() {
        // Given
        circuitStatevector.statevectorResult = try! Vector([
                   Complex.zero,
                   Complex(real: 1 / sqrt(2), imag: 0),
                   Complex.zero,
                   Complex(real: 0, imag: 1 / sqrt(2)),
               ])

        // When
        let result = circuitStatevector.probabilities()

        // Then
        XCTAssertEqual(circuitStatevector.statevectorCount, 1)

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

    static var allTests = [
        ("testAnyCircuitStatevector_probabilities_returnExpectedProbabilities",
         testAnyCircuitStatevector_probabilities_returnExpectedProbabilities)
    ]
}
