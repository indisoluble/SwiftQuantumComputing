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

    let tournamentSize = 1
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

        // Then
        switch populationMutation.applied(to: evalCircuits) {
        case .success(let result):
            XCTAssertNil(result)
            XCTAssertEqual(randomElementsCount, 1)
            XCTAssertEqual(fitness.fittestCount, 1)
            XCTAssertEqual(mutation.executeCount, 0)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testMutationThrowException_applied_throwException() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationMutation.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        fitness.fittestResult = (0, [])

        mutation.executeError = .gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: NotGate())

        let populationMutation = MainGeneticPopulationMutation(tournamentSize: tournamentSize,
                                                               fitness: fitness,
                                                               mutation: mutation,
                                                               evaluator: evaluator,
                                                               score: score,
                                                               randomElements: randomElements)

        // Then
        switch populationMutation.applied(to: evalCircuits) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(randomElementsCount, 1)
            XCTAssertEqual(fitness.fittestCount, 1)
            XCTAssertEqual(mutation.executeCount, 1)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
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

        // Then
        switch populationMutation.applied(to: evalCircuits) {
        case .success(let result):
            XCTAssertEqual(randomElementsCount, 1)
            XCTAssertEqual(fitness.fittestCount, 1)
            XCTAssertEqual(mutation.executeCount, 1)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
            XCTAssertEqual(score.calculateCount, 0)
            XCTAssertNil(result)
        default:
            XCTAssert(false)
        }
    }

    func testEvaluatorThrowException_applied_throwException() {
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

        // Then
        switch populationMutation.applied(to: evalCircuits) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(randomElementsCount, 1)
            XCTAssertEqual(fitness.fittestCount, 1)
            XCTAssertEqual(mutation.executeCount, 1)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 1)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
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
        let result = try? populationMutation.applied(to: evalCircuits).get()

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

    static var allTests = [
        ("testFitnessReturnNil_applied_returnNil",
         testFitnessReturnNil_applied_returnNil),
        ("testMutationThrowException_applied_throwException",
         testMutationThrowException_applied_throwException),
        ("testMutationReturnNil_applied_returnNil",
         testMutationReturnNil_applied_returnNil),
        ("testEvaluatorThrowException_applied_throwException",
         testEvaluatorThrowException_applied_throwException),
        ("testDependenciesReturnValidValues_applied_returnExpectedResult",
         testDependenciesReturnValidValues_applied_returnExpectedResult)
    ]
}
