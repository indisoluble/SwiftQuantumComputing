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
    let backend = BackendTestDouble()
    let factory = BackendRegisterFactoryTestDouble()

    // MARK: - Tests

    func testAnyCircuit_playgroundDescription_forwardCallToDrawer() {
        // Given
        let facade = CircuitFacade(gates: gates, drawer: drawer, backend: backend, factory: factory)

        let view = SQCView()
        drawer.drawCircuitResult = view

        // When
        let result = facade.playgroundDescription

        // Then
        XCTAssertEqual(drawer.drawCircuitCount, 1)
        XCTAssertEqual(drawer.lastDrawCircuitCircuit, gates)
        XCTAssertTrue((result as! SQCView) === view)
    }

    func testAnyCircuitAndRegisterFactoryThatReturnNil_measure_returnNil() {
        // Given
        let facade = CircuitFacade(gates: gates, drawer: drawer, backend: backend, factory: factory)
        factory.makeRegisterResult = nil

        let qubits = [0, 1]
        let bits = "01"

        // When
        let result = facade.measure(qubits: qubits, afterInputting: bits)

        // Then
        XCTAssertEqual(factory.makeRegisterCount, 1)
        XCTAssertEqual(factory.lastMakeRegisterBits, bits)
        XCTAssertEqual(backend.measureCount, 0)
        XCTAssertNil(result)
    }

    func testAnyCircuitAndFactoryThatReturnARegister_measure_forwardCallToBackend() {
        // Given
        let facade = CircuitFacade(gates: gates, drawer: drawer, backend: backend, factory: factory)

        let register = BackendRegisterTestDouble()
        factory.makeRegisterResult = register

        let measure = [0.1, 0.9]
        backend.measureResult = measure

        let otherQubits = [1]
        let bits = "01"

        // When
        let result = facade.measure(qubits: otherQubits, afterInputting: bits)

        // Then
        let lastMeasureRegister = backend.lastMeasureCircuit?.register as? BackendRegisterTestDouble
        let lastMeasureGates = backend.lastMeasureCircuit?.gates as? [Gate]

        XCTAssertEqual(factory.makeRegisterCount, 1)
        XCTAssertEqual(factory.lastMakeRegisterBits, bits)
        XCTAssertEqual(backend.measureCount, 1)
        XCTAssertEqual(backend.lastMeasureQubits, otherQubits)
        XCTAssertTrue(lastMeasureRegister === register)
        XCTAssertEqual(lastMeasureGates, gates)
        XCTAssertEqual(result, measure)
    }
}
