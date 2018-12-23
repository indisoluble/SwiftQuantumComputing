//
//  RandomGatesFactoryTests.swift
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

class RandomGatesFactoryTests: XCTestCase {

    // MARK: - Tests

    func testQubitCountEqualToZero_init_returnNil() {
        // Then
        XCTAssertNil(RandomGatesFactory(qubitCount: 0, depth: 10, factories: []))
    }

    func testNegativeDepth_init_returnNil() {
        // Then
        XCTAssertNil(RandomGatesFactory(qubitCount: 5, depth: -1, factories: []))
    }

    func testFactoryWithDepthEqualToZero_randomGates_returnEmptyList() {
        // Given
        var randomFactoryCount = 0
        let randomFactory: RandomGatesFactory.RandomFactory = {
            randomFactoryCount += 1

            return HadamardGateFactory()
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: RandomGatesFactory.ShuffledQubits = {
            shuffledQubitsCount += 1

            return [0]
        }

        let factory = RandomGatesFactory(depth: 0,
                                         randomFactory: randomFactory,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = factory?.randomGates()

        // Then
        XCTAssertEqual(randomFactoryCount, 0)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result, [] as [Gate])
    }

    func testFactoryWithZeroGateFactoriesAndPositiveDepth_randomGates_returnEmptyList() {
        // Given
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
        let factory = RandomGatesFactory(depth: depth,
                                         randomFactory: randomFactory,
                                         shuffledQubits: shuffledQubits)


        // When
        let result = factory?.randomGates()

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result, [] as [Gate])
    }

    func testFactoryWithGateFactoriesAbleToBuildGatesForCircuitAndPositiveDepth_randomGates_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var factories: [CircuitGateFactory] = []
        var expectedGates: [Gate] = []

        var isEven = true
        for _ in 0..<depth {
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

        let factory = RandomGatesFactory(depth: depth,
                                         randomFactory: randomFactory,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = factory?.randomGates()

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertEqual(result, expectedGates)
    }

    func testFactoryWithSomeGateFactoriesAbleToBuildGatesForCircuitAndPositiveDepth_randomGates_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var factories: [CircuitGateFactory] = []
        var qubitsArray: [[Int]] = []
        var expectedGates: [Gate] = []

        var isEven = true
        for _ in 0..<depth {
            if isEven {
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

        let factory = RandomGatesFactory(depth: depth,
                                         randomFactory: randomFactory,
                                         shuffledQubits: shuffledQubits)

        // When
        let result = factory?.randomGates()

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertEqual(result, expectedGates)
    }
}
