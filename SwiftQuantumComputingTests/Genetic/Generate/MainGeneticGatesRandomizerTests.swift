//
//  MainGeneticGatesRandomizerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/02/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

class MainGeneticGatesRandomizerTests: XCTestCase {

    // MARK: - Tests

    func testQubitCountEqualToZero_init_returnNil() {
        // Then
        XCTAssertNil(MainGeneticGatesRandomizer(qubitCount: 0, factories: []))
    }

    func testAnyRandomizerAndNegativeDepth_make_returnNil() {
        // Given
        let randomizer = MainGeneticGatesRandomizer(qubitCount: 1, factories: [])!

        // Then
        XCTAssertNil(randomizer.make(depth: -1))
    }

    func testAnyRandomizerAndDepthEqualToZero_make_returnEmptyList() {
        // Given
        var randomFactoryCount = 0
        let randomFactory: MainGeneticGatesRandomizer.RandomFactory = {
            randomFactoryCount += 1

            return GeneticGateFactoryTestDouble()
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: MainGeneticGatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return [0]
        }

        let randomizer = MainGeneticGatesRandomizer(randomFactory: randomFactory,
                                                    shuffledQubits: shuffledQubits)

        // When
        let result = randomizer.make(depth: 0)

        // Then
        XCTAssertEqual(randomFactoryCount, 0)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result?.count, 0)
    }

    func testRandomizerWithZeroFactoriesAndPositiveDepth_make_returnEmptyList() {
        // Given
        var randomFactoryCount = 0
        let randomFactory: MainGeneticGatesRandomizer.RandomFactory = {
            randomFactoryCount += 1

            return nil as GeneticGateFactory?
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: MainGeneticGatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return [0]
        }

        let randomizer = MainGeneticGatesRandomizer(randomFactory: randomFactory,
                                                    shuffledQubits: shuffledQubits)

        // When
        let depth = 10
        let result = randomizer.make(depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, 0)
        XCTAssertEqual(result?.count, 0)
    }

    func testRandomizerWithFactoriesAbleToBuildGatesAndPositiveDepth_make_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var factories: [GeneticGateFactory] = []
        var expectedGates: [GeneticGateTestDouble] = []

        for _ in 0..<depth {
            let factory = GeneticGateFactoryTestDouble()

            let gate = GeneticGateTestDouble()
            factory.makeGateResult = gate

            factories.append(factory)
            expectedGates.append(gate)
        }

        var randomFactoryCount = 0
        let randomFactory: MainGeneticGatesRandomizer.RandomFactory = {
            let result = factories[randomFactoryCount]
            randomFactoryCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: MainGeneticGatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return qubits
        }

        let randomizer = MainGeneticGatesRandomizer(randomFactory: randomFactory,
                                                    shuffledQubits: shuffledQubits)

        // When
        let result = randomizer.make(depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertNotNil(result as? [GeneticGateTestDouble])
        XCTAssertEqual(result?.count, depth)
        if let result = result as? [GeneticGateTestDouble], result.count == depth {
            for (lhs, rhs) in zip(result, expectedGates) {
                XCTAssert(lhs === rhs)
            }
        }
    }

    func testRandomizerWithSomeFactoriesAbleToBuildGatesAndPositiveDepth_make_returnExpectedGates() {
        // Given
        let qubits = [0, 1]
        let depth = 10

        var factories: [GeneticGateFactory] = []
        var expectedGates: [GeneticGateTestDouble] = []

        var isEven = true
        for _ in 0..<depth {
            let factory = GeneticGateFactoryTestDouble()
            factories.append(factory)

            if isEven {
                let gate = GeneticGateTestDouble()
                expectedGates.append(gate)

                factory.makeGateResult = gate
            }

            isEven = !isEven
        }

        var randomFactoryCount = 0
        let randomFactory: MainGeneticGatesRandomizer.RandomFactory = {
            let result = factories[randomFactoryCount]
            randomFactoryCount += 1

            return result
        }

        var shuffledQubitsCount = 0
        let shuffledQubits: MainGeneticGatesRandomizer.ShuffledQubits = {
            shuffledQubitsCount += 1

            return qubits
        }

        let randomizer = MainGeneticGatesRandomizer(randomFactory: randomFactory,
                                                    shuffledQubits: shuffledQubits)

        // When
        let result = randomizer.make(depth: depth)

        // Then
        XCTAssertEqual(randomFactoryCount, depth)
        XCTAssertEqual(shuffledQubitsCount, depth)
        XCTAssertNotNil(result as? [GeneticGateTestDouble])
        XCTAssertEqual(result?.count, expectedGates.count)
        if let result = result as? [GeneticGateTestDouble], result.count == expectedGates.count {
            for (lhs, rhs) in zip(result, expectedGates) {
                XCTAssert(lhs === rhs)
            }
        }
    }
}
