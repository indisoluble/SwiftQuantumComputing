//
//  Circuit+RandomTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 28/08/2018.
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

class Circuit_RandomTests: XCTestCase {

    // MARK: - Tests

    func testCorrectCircuitFactoriesAbleToBuildGatesForCircuitAndNegativeDepth_applyingGates_returnNil() {
        // Given
        let circuit = CircuitTestDouble()

        var randomFactoryCount = 0
        let randomFactory: (() -> CircuitGateFactory?) = {
            randomFactoryCount += 1

            return PhaseShiftGateFactory(radians: 0)
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: (() -> [Int]) = {
            shuffledQubitsCount += 1

            return [0]
        }

        let depth = -1

        // When
        let result = circuit.applyingFactories(randomlySelectedWith: randomFactory,
                                               on: shuffledQubits,
                                               depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, 0)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(circuit.applyingGateCount, 0)
        XCTAssertNil(result)
    }

    func testCorrectCircuitFactoriesAbleToBuildGatesForCircuitAndDepthEqualToZero_applyingGates_returnSameCircuit() {
        // Given
        let circuit = CircuitTestDouble()

        var randomFactoryCount = 0
        let randomFactory: (() -> CircuitGateFactory?) = {
            randomFactoryCount += 1

            return HadamardGateFactory()
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: (() -> [Int]) = {
            shuffledQubitsCount += 1

            return [0]
        }

        let depth = 0

        // When
        let result = circuit.applyingFactories(randomlySelectedWith: randomFactory,
                                               on: shuffledQubits,
                                               depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, 0)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(circuit.applyingGateCount, 0)
        XCTAssertTrue(result === circuit)
    }

    func testCorrectCircuitZeroFactoriesAndPositiveDepth_applyingGates_returnSameCircuit() {
        // Given
        let circuit = CircuitTestDouble()

        var randomFactoryCount = 0
        let randomFactory: (() -> CircuitGateFactory?) = {
            randomFactoryCount += 1

            return nil as CircuitGateFactory?
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: (() -> [Int]) = {
            shuffledQubitsCount += 1

            return [0]
        }

        let depth = 10

        // When
        let result = circuit.applyingFactories(randomlySelectedWith: randomFactory,
                                               on: shuffledQubits,
                                               depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(circuit.applyingGateCount, 0)
        XCTAssertTrue(result === circuit)
    }

    func testCorrectCircuitFactoriesAbleToBuildGatesForCircuitAndPositiveDepth_applyingGates_returnExpectedCircuit() {
        // Given
        let lastCircuit = CircuitTestDouble()
        var circuits = [lastCircuit]

        let qubits = [0, 1]
        let depth = 10

        var factories: [CircuitGateFactory] = []
        var expectedGates: [Gate] = []

        var isEven = true
        for _ in 0..<depth {
            let circuit = CircuitTestDouble()
            circuit.applyingGateResult = circuits[0]
            circuits.insert(circuit, at: 0)

            let factory: CircuitGateFactory = (isEven ?
                ControlledNotGateFactory() :
                NotGateFactory())
            factories.append(factory)

            expectedGates.append(factory.makeGate(inputs: qubits)!)

            isEven = !isEven
        }

        var randomFactoryCount = 0
        let randomFactory: (() -> CircuitGateFactory?) = {
            let result = factories[randomFactoryCount]
            randomFactoryCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: (() -> [Int]) = {
            shuffledQubitsCount += 1

            return qubits
        }

        // When
        let result = circuits[0].applyingFactories(randomlySelectedWith: randomFactory,
                                                   on: shuffledQubits,
                                                   depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)

        for (circuit, expectedGate) in zip(circuits, expectedGates) {
            XCTAssertEqual(circuit.applyingGateCount, 1)
            XCTAssertEqual(circuit.lastApplyingGateGate, expectedGate)
        }

        XCTAssertTrue(result === lastCircuit)
    }

    func testCorrectCircuitSomeFactoriesAbleToBuildGatesForCircuitAndPositiveDepth_applyingGates_returnExpectedCircuit() {
        // Given
        let lastCircuit = CircuitTestDouble()
        var circuits = [lastCircuit]

        let qubits = [0, 1]
        let depth = 10

        var factories: [CircuitGateFactory] = []
        var qubitsArray: [[Int]] = []
        var expectedGates: [Gate] = []

        var isEven = true
        for _ in 0..<depth {
            if isEven {
                let circuit = CircuitTestDouble()
                circuit.applyingGateResult = circuits[0]
                circuits.insert(circuit, at: 0)

                let factory = ControlledNotGateFactory()
                factories.append(factory)
                qubitsArray.append(qubits)

                expectedGates.append(factory.makeGate(inputs: qubits)!)
            } else {
                factories.append(NotGateFactory())
                qubitsArray.append([])
            }

            isEven = !isEven
        }

        var randomFactoryCount = 0
        let randomFactory: (() -> CircuitGateFactory?) = {
            let result = factories[randomFactoryCount]
            randomFactoryCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: (() -> [Int]) = {
            let result = qubitsArray[shuffledQubitsCount]
            shuffledQubitsCount += 1

            return result
        }

        // When
        let result = circuits[0].applyingFactories(randomlySelectedWith: randomFactory,
                                                   on: shuffledQubits,
                                                   depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)

        for (circuit, expectedGate) in zip(circuits, expectedGates) {
            XCTAssertEqual(circuit.applyingGateCount, 1)
            XCTAssertEqual(circuit.lastApplyingGateGate, expectedGate)
        }

        XCTAssertTrue(result === lastCircuit)
    }
}
