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

    let gates = [Gate.hadamard(target: 0), Gate.not(target: 0)]
    let drawer = DrawerTestDouble()
    let qubitCount = 1
    let backend = BackendTestDouble()

    // MARK: - Tests

    func testQubitCountEqualToZero_init_returnNil() {
        // Then
        XCTAssertNil(CircuitFacade(gates: gates, drawer:drawer, qubitCount: 0, backend:backend))
    }

    func testAnyCircuit_qubitCount_returnExpectedValue() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   drawer: drawer,
                                   qubitCount: qubitCount,
                                   backend: backend)!

        // Then
        XCTAssertEqual(facade.qubitCount, qubitCount)
    }

    func testAnyCircuit_gates_returnExpectedValue() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   drawer: drawer,
                                   qubitCount: qubitCount,
                                   backend: backend)!

        // Then
        XCTAssertEqual(facade.gates, gates)
    }

    func testAnyCircuit_playgroundDescription_forwardCallToDrawer() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   drawer: drawer,
                                   qubitCount: qubitCount,
                                   backend: backend)!

        let view = SQCView()
        drawer.drawCircuitResult = view

        // When
        let result = facade.playgroundDescription

        // Then
        XCTAssertEqual(drawer.drawCircuitCount, 1)
        XCTAssertEqual(drawer.lastDrawCircuitCircuit, gates)
        XCTAssertTrue((result as! SQCView) === view)
    }

    func testAnyCircuit_measure_forwardCallToDrawer() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   drawer: drawer,
                                   qubitCount: qubitCount,
                                   backend: backend)!

        let measure = [0.1, 0.9]
        backend.measureQubitsResult = measure

        let otherQubits = [1]

        // When
        let result = facade.measure(qubits: otherQubits)

        // Then
        XCTAssertEqual(backend.measureQubitsCount, 1)
        XCTAssertEqual((backend.lastMeasureQubitsCircuit as! [Gate]), gates)
        XCTAssertEqual(backend.lastMeasureQubitsQubits, otherQubits)
        XCTAssertEqual(result, measure)
    }
}
