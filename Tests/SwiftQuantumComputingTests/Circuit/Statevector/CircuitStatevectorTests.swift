//
//  CircuitStatevectorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/12/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class CircuitStatevectorTests: XCTestCase {

    // MARK: - Tests

    func testAnyCircuitStatevector_probabilities_returnExpectedProbabilities() {
        // Given
        let circuitStatevector = CircuitStatevectorTestDouble()
        circuitStatevector.statevectorResult = try! Vector([
            .zero, Complex(1 / sqrt(2)), .zero, Complex(imaginary: 1 / sqrt(2))
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
            XCTAssertEqual(value, expectedValue, accuracy: SharedConstants.tolerance)
        }
    }

    static var allTests = [
        ("testAnyCircuitStatevector_probabilities_returnExpectedProbabilities",
         testAnyCircuitStatevector_probabilities_returnExpectedProbabilities)
    ]
}
