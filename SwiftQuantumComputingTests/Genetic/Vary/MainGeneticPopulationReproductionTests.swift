//
//  MainGeneticPopulationReproductionTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/03/2019.
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

class MainGeneticPopulationReproductionTests: XCTestCase {

    // MARK: - Properties

    let mutationProbability = 0.2
    let mutation = GeneticPopulationMutationTestDouble()
    let crossover = GeneticPopulationCrossoverTestDouble()
    let evalCircuits: [Fitness.EvalCircuit] = []

    // MARK: - Tests

    func testRandomReturnProbabilityBelowMutationProbabilityAndMutationReturnNil_applied_returnEmptyList() {
        // Given
        var randomCount = 0
        let randomResult = mutationProbability - 0.1
        let random: MainGeneticPopulationReproduction.Random = { _ in
            randomCount += 1

            return randomResult
        }

        let reproduction = MainGeneticPopulationReproduction(mutationProbability: mutationProbability,
                                                             mutation: mutation,
                                                             crossover: crossover,
                                                             random: random)

        // When
        let result = reproduction.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomCount, 1)
        XCTAssertEqual(mutation.appliedCount, 1)
        XCTAssertEqual(crossover.appliedCount, 0)
        XCTAssertEqual(result.count, 0)
    }

    func testRandomReturnProbabilityBelowMutationProbabilityAndMutationReturnValue_applied_returnExpectedValue() {
        // Given
        var randomCount = 0
        let randomResult = mutationProbability - 0.1
        let random: MainGeneticPopulationReproduction.Random = { _ in
            randomCount += 1

            return randomResult
        }

        let mutationResult: Fitness.EvalCircuit = (0, [GeneticGateTestDouble()])
        mutation.appliedResult = mutationResult

        let reproduction = MainGeneticPopulationReproduction(mutationProbability: mutationProbability,
                                                             mutation: mutation,
                                                             crossover: crossover,
                                                             random: random)

        // When
        let result = reproduction.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomCount, 1)
        XCTAssertEqual(mutation.appliedCount, 1)
        XCTAssertEqual(crossover.appliedCount, 0)
        XCTAssertEqual(result.count, 1)
        if let resultEvalCircuit = result.first {
            XCTAssertEqual(resultEvalCircuit.eval, mutationResult.eval)
            XCTAssertEqual(resultEvalCircuit.circuit.count, mutationResult.circuit.count)

            if let resultCircuit = resultEvalCircuit.circuit as? [GeneticGateTestDouble],
                let expectedCircuit = mutationResult.circuit as? [GeneticGateTestDouble] {
                for (resultGate, expectedGate) in zip(resultCircuit, expectedCircuit) {
                    XCTAssertTrue(resultGate === expectedGate)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testRandomReturnProbabilityEqualToMutationProbability_applied_returnExpectedValue() {
        // Given
        var randomCount = 0
        let randomResult = mutationProbability
        let random: MainGeneticPopulationReproduction.Random = { _ in
            randomCount += 1

            return randomResult
        }

        let crossoverResult: Fitness.EvalCircuit = (0, [GeneticGateTestDouble()])
        let crossoverList = [crossoverResult]
        crossover.appliedResult = crossoverList

        let reproduction = MainGeneticPopulationReproduction(mutationProbability: mutationProbability,
                                                             mutation: mutation,
                                                             crossover: crossover,
                                                             random: random)

        // When
        let result = reproduction.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomCount, 1)
        XCTAssertEqual(mutation.appliedCount, 0)
        XCTAssertEqual(crossover.appliedCount, 1)
        XCTAssertEqual(result.count, crossoverList.count)
        for (resultEvalCircuit, expectedEvalCircuit) in zip(result, crossoverList) {
            XCTAssertEqual(resultEvalCircuit.eval, expectedEvalCircuit.eval)
            XCTAssertEqual(resultEvalCircuit.circuit.count, expectedEvalCircuit.circuit.count)

            if let resultCircuit = resultEvalCircuit.circuit as? [GeneticGateTestDouble],
                let expectedCircuit = expectedEvalCircuit.circuit as? [GeneticGateTestDouble] {
                for (resultGate, expectedGate) in zip(resultCircuit, expectedCircuit) {
                    XCTAssertTrue(resultGate === expectedGate)
                }
            } else {
                XCTAssert(false)
            }
        }
    }
}
