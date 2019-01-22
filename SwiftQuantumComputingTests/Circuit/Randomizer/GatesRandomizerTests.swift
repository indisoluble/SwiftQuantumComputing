//
//  GatesRandomizerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/12/2018.
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

class GatesRandomizerTests: XCTestCase {

    // MARK: - Tests

    func testQubitCountEqualToZero_init_returnNil() {
        // Then
        XCTAssertNil(GatesRandomizer(qubitCount: 0, depth: 10, gates: []))
    }

    func testNegativeDepth_init_returnNil() {
        // Then
        XCTAssertNil(GatesRandomizer(qubitCount: 5, depth: -1, gates: []))
    }

    func testRandomizerWithDepthEqualToZero_execute_returnEmptyList() {
        // Given
        var randomGateCount = 0
        let randomGate: GatesRandomizer.RandomGate = {
            randomGateCount += 1

            return HadamardGate()
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: GatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return [0]
        }

        let randomizer = GatesRandomizer(depth: 0,
                                         randomGate: randomGate,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = randomizer?.execute()

        // Then
        XCTAssertEqual(randomGateCount, 0)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result, [] as [FixedGate])
    }

    func testRandomizerWithZeroGatesAndPositiveDepth_execute_returnEmptyList() {
        // Given
        var randomGateCount = 0
        let randomGate: GatesRandomizer.RandomGate = {
            randomGateCount += 1

            return nil as Gate?
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: GatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return [0]
        }

        let depth = 10
        let randomizer = GatesRandomizer(depth: depth,
                                         randomGate: randomGate,
                                         shuffledQubits: shuffledQubits)


        // When
        let result = randomizer?.execute()

        // Then
        XCTAssertEqual(randomGateCount, depth)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result, [] as [FixedGate])
    }

    func testRandomizerWithGatesAbleToBuildFixedGatesForCircuitAndPositiveDepth_execute_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var gates: [Gate] = []
        var expectedFixedGates: [FixedGate] = []

        var isEven = true
        for _ in 0..<depth {
            let gate: Gate = (isEven ? ControlledNotGate() : NotGate())
            gates.append(gate)

            expectedFixedGates.append(gate.makeFixed(inputs: qubits)!)

            isEven = !isEven
        }

        var randomGateCount = 0
        let randomGate: GatesRandomizer.RandomGate = {
            let result = gates[randomGateCount]
            randomGateCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: GatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return qubits
        }

        let randomizer = GatesRandomizer(depth: depth,
                                         randomGate: randomGate,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = randomizer?.execute()

        // Then
        XCTAssertEqual(randomGateCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertEqual(result, expectedFixedGates)
    }

    func testRandomizerWithSomeGatesAbleToBuildFixedGatesForCircuitAndPositiveDepth_execute_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var gates: [Gate] = []
        var qubitsArray: [[Int]] = []
        var expectedFixedGates: [FixedGate] = []

        var isEven = true
        for _ in 0..<depth {
            if isEven {
                let gate = ControlledNotGate()
                gates.append(gate)
                qubitsArray.append(qubits)

                expectedFixedGates.append(gate.makeFixed(inputs: qubits)!)
            } else {
                gates.append(NotGate())
                qubitsArray.append([])
            }

            isEven = !isEven
        }

        var randomGateCount = 0
        let randomGate: GatesRandomizer.RandomGate = {
            let result = gates[randomGateCount]
            randomGateCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: GatesRandomizer.ShuffledQubits = {
            let result = qubitsArray[shuffledQubitsCount]
            shuffledQubitsCount += 1

            return result
        }

        let randomizer = GatesRandomizer(depth: depth,
                                         randomGate: randomGate,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = randomizer?.execute()

        // Then
        XCTAssertEqual(randomGateCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertEqual(result, expectedFixedGates)
    }
}
