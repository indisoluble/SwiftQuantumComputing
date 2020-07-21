//
//  Circuit+StatevectorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/06/2020.
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

class Circuit_StatevectorTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()

    // MARK: - Tests

    func testEmptyCircuit_statevector_produceExpectedVector() {
        // Given
        circuit.gatesResult = []

        // When
        _ = circuit.statevector()

        // Then
        let initialElements: [Complex<Double>] = [.one, .zero]
        let expectedInitialStatevector = try! Vector(initialElements)

        XCTAssertEqual(circuit.gatesCount, 1)
        XCTAssertEqual(circuit.circuitStatevectorCount, 1)
        XCTAssertEqual(circuit.lastCircuitStatevectorInitialStatevector?.statevector,
                       expectedInitialStatevector)
    }

    func testCircuitWithKnownQubitCount_statevector_produceExpectedVector() {
        // Given
        let gates = [Gate.not(target: 0), Gate.hadamard(target: 2)]

        circuit.gatesResult = gates

        // When
        _ = circuit.statevector()

        // Then
        let initialElements: [Complex<Double>] = [
            .one, .zero, .zero, .zero, .zero, .zero, .zero, .zero
        ]
        let expectedInitialStatevector = try! Vector(initialElements)

        XCTAssertEqual(circuit.gatesCount, 1)
        XCTAssertEqual(circuit.circuitStatevectorCount, 1)
        XCTAssertEqual(circuit.lastCircuitStatevectorInitialStatevector?.statevector,
                       expectedInitialStatevector)
    }

    static var allTests = [
        ("testEmptyCircuit_statevector_produceExpectedVector",
         testEmptyCircuit_statevector_produceExpectedVector),
        ("testCircuitWithKnownQubitCount_statevector_produceExpectedVector",
         testCircuitWithKnownQubitCount_statevector_produceExpectedVector)
    ]
}
