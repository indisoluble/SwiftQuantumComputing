//
//  MainGeneticPopulationMutationTests.swift
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

class MainGeneticPopulationMutationTests: XCTestCase {

    // MARK: - Properties

    let tournamentSize = 0
    let fitness = FitnessTestDouble()
    let mutation = GeneticCircuitMutationTestDouble()
    let evaluator = GeneticCircuitEvaluatorTestDouble()
    let score = GeneticCircuitScoreTestDouble()
    let scoreResult = 1.0
    let evalCircuits: [Fitness.EvalCircuit] = []

    // MARK: - Tests

    func testFitnessReturnNil_applied_returnNil() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationMutation.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationMutation = MainGeneticPopulationMutation(tournamentSize: tournamentSize,
                                                               fitness: fitness,
                                                               mutation: mutation,
                                                               evaluator: evaluator,
                                                               score: score,
                                                               randomElements: randomElements)

        // When
        let result = populationMutation.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(mutation.executeCount, 0)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
        XCTAssertEqual(score.calculateCount, 0)
        XCTAssertNil(result)
    }

    func testMutationReturnNil_applied_returnNil() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationMutation.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        fitness.fittestResult = (0, [])

        let populationMutation = MainGeneticPopulationMutation(tournamentSize: tournamentSize,
                                                               fitness: fitness,
                                                               mutation: mutation,
                                                               evaluator: evaluator,
                                                               score: score,
                                                               randomElements: randomElements)

        // When
        let result = populationMutation.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(mutation.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
        XCTAssertEqual(score.calculateCount, 0)
        XCTAssertNil(result)
    }

    func testEvaluatorReturnNil_applied_returnNil() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationMutation.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        fitness.fittestResult = (0, [])
        let expectedMutation = Array(repeating: GeneticGateTestDouble(), count: 2)
        mutation.executeResult = expectedMutation

        let populationMutation = MainGeneticPopulationMutation(tournamentSize: tournamentSize,
                                                               fitness: fitness,
                                                               mutation: mutation,
                                                               evaluator: evaluator,
                                                               score: score,
                                                               randomElements: randomElements)

        // When
        let result = populationMutation.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(mutation.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(score.calculateCount, 0)
        XCTAssertNil(result)
    }

    func testDependenciesReturnValidValues_applied_returnExpectedResult() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationMutation.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        fitness.fittestResult = (0, [])
        let expectedMutation = Array(repeating: GeneticGateTestDouble(), count: 2)
        mutation.executeResult = expectedMutation
        evaluator.evaluateCircuitResult = (0, 0)
        score.calculateResult = scoreResult

        let populationMutation = MainGeneticPopulationMutation(tournamentSize: tournamentSize,
                                                               fitness: fitness,
                                                               mutation: mutation,
                                                               evaluator: evaluator,
                                                               score: score,
                                                               randomElements: randomElements)

        // When
        let result = populationMutation.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(mutation.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(score.calculateCount, 1)

        if let result = result {
            XCTAssertEqual(result.eval, scoreResult)
            XCTAssertEqual(result.circuit.count, expectedMutation.count)

            if let circuit = result.circuit as? [GeneticGateTestDouble] {
                for (resultGate, expectedGate) in zip(circuit, expectedMutation) {
                    XCTAssert(resultGate === expectedGate)
                }
            } else {
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}
