//
//  GeneticMutationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/02/2019.
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

class GeneticMutationTests: XCTestCase {

    // MARK: - Properties

    let randomizer = GeneticGatesRandomizerTestDouble()

    // MARK: - Tests

    func testDepthNotEnoughToBuildAMutation_execute_returnNil() {
        // Given
        let maxDepth = 2
        let circuit = Array(repeating: GeneticGateTestDouble(), count: maxDepth)

        var randomSplitCount = 0
        let randomSplit: GeneticMutation.RandomSplit = { _ in
            randomSplitCount += 1

            return (circuit, circuit)
        }

        var randomElementCount = 0
        let randomElement: GeneticMutation.RandomElement = { _ in
            randomElementCount += 1

            return 0
        }

        let mutator = GeneticMutation(maxDepth: maxDepth,
                                      randomizer: randomizer,
                                      randomSplit: randomSplit,
                                      randomElement: randomElement)

        // When
        let mutation = mutator.execute(circuit)

        // Then
        XCTAssertEqual(randomSplitCount, 2)
        XCTAssertEqual(randomElementCount, 0)
        XCTAssertEqual(randomizer.makeCount, 0)
        XCTAssertNil(mutation)
    }

    func testBigEnoughDepthAndRandomizerThatReturnNil_execute_returnNil() {
        // Given
        let maxDepth = 4
        let circuit = [GeneticGateTestDouble()]

        var randomSplitCount = 0
        let randomSplit: GeneticMutation.RandomSplit = { _ in
            randomSplitCount += 1

            return (circuit, circuit)
        }

        var randomElementCount = 0
        let randomElement: GeneticMutation.RandomElement = { _ in
            randomElementCount += 1

            return 0
        }

        let mutator = GeneticMutation(maxDepth: maxDepth,
                                      randomizer: randomizer,
                                      randomSplit: randomSplit,
                                      randomElement: randomElement)

        // When
        let mutation = mutator.execute(circuit)

        // Then
        XCTAssertEqual(randomSplitCount, 2)
        XCTAssertEqual(randomElementCount, 1)
        XCTAssertEqual(randomizer.makeCount, 1)
        XCTAssertNil(mutation)
    }

    func testBigEnoughDepthAndRandomizerThatReturnCircuit_execute_returnExpectedCircuit() {
        // Given
        let maxDepth = 4
        let circuit = [GeneticGateTestDouble()]

        let randomizerResult = [GeneticGateTestDouble()]
        randomizer.makeResult = randomizerResult

        var randomSplitCount = 0
        let randomSplit: GeneticMutation.RandomSplit = { _ in
            randomSplitCount += 1

            return (circuit, circuit)
        }

        var randomElementCount = 0
        let randomElement: GeneticMutation.RandomElement = { _ in
            randomElementCount += 1

            return 0
        }

        let mutator = GeneticMutation(maxDepth: maxDepth,
                                      randomizer: randomizer,
                                      randomSplit: randomSplit,
                                      randomElement: randomElement)

        // When
        let mutation = mutator.execute(circuit)

        // Then
        let expectedMutation = circuit + randomizerResult + circuit

        XCTAssertEqual(randomSplitCount, 2)
        XCTAssertEqual(randomElementCount, 1)
        XCTAssertEqual(randomizer.makeCount, 1)
        XCTAssertNotNil(mutation as? [GeneticGateTestDouble])
        XCTAssertEqual(mutation?.count, expectedMutation.count)
        if let mutation = mutation as? [GeneticGateTestDouble],
            mutation.count == expectedMutation.count {
            for (lhs, rhs) in zip(mutation, expectedMutation) {
                XCTAssert(lhs === rhs)
            }
        }
    }
}
