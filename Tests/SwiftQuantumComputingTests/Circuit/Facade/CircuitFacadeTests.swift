//
//  CircuitFacadeTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 23/08/2018.
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

class CircuitFacadeTests: XCTestCase {

    // MARK: - Properties

    let gates = [FixedGate.hadamard(target: 0), FixedGate.not(target: 0)]
    let backend = BackendTestDouble()

    // MARK: - Tests

    func testAnyCircuit_measure_forwardCallToBackend() {
        // Given
        let facade = CircuitFacade(gates: gates, backend: backend)

        let measure = [0.1, 0.9]
        backend.measureResult = measure

        let otherQubits = [1]
        let bits = "01"

        // When
        let result = try? facade.measure(qubits: otherQubits, afterInputting: bits)

        // Then
        let lastMeasureInputBits = backend.lastMeasureCircuit?.inputBits
        let lastMeasureGates = backend.lastMeasureCircuit?.gates as? [FixedGate]

        XCTAssertEqual(backend.measureCount, 1)
        XCTAssertEqual(backend.lastMeasureQubits, otherQubits)
        XCTAssertEqual(lastMeasureInputBits, bits)
        XCTAssertEqual(lastMeasureGates, gates)
        XCTAssertEqual(result, measure)
    }
}
