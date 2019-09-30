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

    let bits = "01"
    let gates = [FixedGate.hadamard(target: 0), FixedGate.not(target: 0)]
    let statevectorSimulator = StatevectorSimulatorTestDouble()

    // MARK: - Tests

    func testAnyCircuit_statevector_forwardCallToStatevectorSimulator() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        let expectedResult = [Complex(0), Complex(1)]
        statevectorSimulator.statevectorResult = try! Vector(expectedResult)

        // When
        let result = try? facade.statevector(afterInputting: bits)

        // Then
        let lastStatevectorBits = statevectorSimulator.lastStatevectorBits
        let lastStatevectorGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)
        XCTAssertEqual(lastStatevectorBits, bits)
        XCTAssertEqual(lastStatevectorGates, gates)
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyCircuitAndZeroQubits_measure_throwException() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        // Then
        XCTAssertThrowsError(try facade.measure(qubits: [], afterInputting: bits))
        XCTAssertEqual(statevectorSimulator.statevectorCount, 0)
    }

    func testAnyCircuitAndRepeatedQubits_measure_throwException() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        // Then
        XCTAssertThrowsError(try facade.measure(qubits: [0, 0], afterInputting: bits))
        XCTAssertEqual(statevectorSimulator.statevectorCount, 0)
    }

    func testAnyRegisterAndUnsortedQubits_measure_throwException() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        // Then
        XCTAssertThrowsError(try facade.measure(qubits: [0, 1], afterInputting: bits))
        XCTAssertEqual(statevectorSimulator.statevectorCount, 0)
    }

    func testCircuitWithSimulatorThatReturnsVectorAndQubitsOutOfBoundsOfVector_measure_throwException() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        statevectorSimulator.statevectorResult = try! Vector([Complex(0),
                                                              Complex(0),
                                                              Complex(0),
                                                              Complex(1)])

        // Then
        XCTAssertThrowsError(try facade.measure(qubits: [100, 0], afterInputting: bits))
        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)

        let lastMeasureInputBits = statevectorSimulator.lastStatevectorBits
        let lastMeasureGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(lastMeasureInputBits, bits)
        XCTAssertEqual(lastMeasureGates, gates)
    }

    func testAnyCircuitAndNegativeQubits_measure_throwException() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        statevectorSimulator.statevectorResult = try! Vector([Complex(0),
                                                              Complex(0),
                                                              Complex(0),
                                                              Complex(1)])

        // Then
        XCTAssertThrowsError(try facade.measure(qubits: [0, -1], afterInputting: bits))
        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)

        let lastMeasureInputBits = statevectorSimulator.lastStatevectorBits
        let lastMeasureGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(lastMeasureInputBits, bits)
        XCTAssertEqual(lastMeasureGates, gates)
    }

    func testCircuitWithSimulatorThatReturnsVectorAndOneQubit_measure_returnExpectedProbabilities() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        let prob = (1 / sqrt(5))
        let vector = try! Vector([Complex(0), Complex(prob), Complex(prob), Complex(prob),
                                  Complex(prob), Complex(0), Complex(0), Complex(prob)])
        statevectorSimulator.statevectorResult = vector

        // When
        let measures = try! facade.measure(qubits: [0], afterInputting: bits)

        // Then
        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)

        let lastMeasureInputBits = statevectorSimulator.lastStatevectorBits
        let lastMeasureGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(lastMeasureInputBits, bits)
        XCTAssertEqual(lastMeasureGates, gates)

        let expectedMeasures = [(Double(2) / Double(5)), (Double(3) / Double(5))]

        XCTAssertEqual(measures.count, expectedMeasures.count)
        for index in 0..<measures.count {
            XCTAssertEqual(measures[index], expectedMeasures[index], accuracy: 0.001)
        }
    }

    func testCircuitWithSimulatorThatReturnsVectorAndTwoQubits_measure_returnExpectedProbabilities() {
        // Given
        let facade = CircuitFacade(gates: gates, statevectorSimulator: statevectorSimulator)

        let prob = (1 / sqrt(5))
        let vector = try! Vector([Complex(0), Complex(prob), Complex(prob), Complex(prob),
                                  Complex(prob), Complex(0), Complex(0), Complex(prob)])
        statevectorSimulator.statevectorResult = vector

        // When
        let measures = try! facade.measure(qubits: [1, 0], afterInputting: bits)

        // Then
        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)

        let lastMeasureInputBits = statevectorSimulator.lastStatevectorBits
        let lastMeasureGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(lastMeasureInputBits, bits)
        XCTAssertEqual(lastMeasureGates, gates)

        let expectedMeasures = [(Double(1) / Double(5)), (Double(1) / Double(5)),
                                (Double(1) / Double(5)), (Double(2) / Double(5))]

        XCTAssertEqual(measures.count, expectedMeasures.count)
        for index in 0..<measures.count {
            XCTAssertEqual(measures[index], expectedMeasures[index], accuracy: 0.001)
        }
    }

    static var allTests = [
        ("testAnyCircuit_statevector_forwardCallToStatevectorSimulator",
         testAnyCircuit_statevector_forwardCallToStatevectorSimulator),
        ("testAnyCircuitAndZeroQubits_measure_throwException",
         testAnyCircuitAndZeroQubits_measure_throwException),
        ("testAnyCircuitAndRepeatedQubits_measure_throwException",
         testAnyCircuitAndRepeatedQubits_measure_throwException),
        ("testAnyRegisterAndUnsortedQubits_measure_throwException",
         testAnyRegisterAndUnsortedQubits_measure_throwException),
        ("testCircuitWithSimulatorThatReturnsVectorAndQubitsOutOfBoundsOfVector_measure_throwException",
         testCircuitWithSimulatorThatReturnsVectorAndQubitsOutOfBoundsOfVector_measure_throwException),
        ("testAnyCircuitAndNegativeQubits_measure_throwException",
         testAnyCircuitAndNegativeQubits_measure_throwException),
        ("testCircuitWithSimulatorThatReturnsVectorAndOneQubit_measure_returnExpectedProbabilities",
         testCircuitWithSimulatorThatReturnsVectorAndOneQubit_measure_returnExpectedProbabilities),
        ("testCircuitWithSimulatorThatReturnsVectorAndTwoQubits_measure_returnExpectedProbabilities",
         testCircuitWithSimulatorThatReturnsVectorAndTwoQubits_measure_returnExpectedProbabilities)
    ]
}
