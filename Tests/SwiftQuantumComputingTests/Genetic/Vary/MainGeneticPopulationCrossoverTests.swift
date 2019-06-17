//
//  MainGeneticPopulationCrossoverTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/02/2019.
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

class MainGeneticPopulationCrossoverTests: XCTestCase {

    // MARK: - Properties

    let tournamentSize = 1
    let maxDepth = 5
    let fitness = FitnessTestDouble()
    let crossover = GeneticCircuitCrossoverTestDouble()
    let evaluator = GeneticCircuitEvaluatorTestDouble()
    let score = GeneticCircuitScoreTestDouble()
    let scoreResult = 1.0
    let evalCircuits: [Fitness.EvalCircuit] = []

    // MARK: - Tests

    func testTournamentSizeEqualToZero_init_throwException() {
        // Given
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            return [(0, [])]
        }

        // Then
        XCTAssertThrowsError(try MainGeneticPopulationCrossover(tournamentSize: 0,
                                                                maxDepth: maxDepth,
                                                                fitness: fitness,
                                                                crossover: crossover,
                                                                evaluator: evaluator,
                                                                score: score,
                                                                randomElements: randomElements))
    }

    func testFitnessReturnNil_applied_returnEmptyList() {
        // Given
        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // Given
        let result = try? populationCrossover.applied(to: evalCircuits)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 0)
        XCTAssertEqual(randomElementsCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(crossover.executeCount, 0)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
        XCTAssertEqual(score.calculateCount, 0)
    }

    func testCrossoverThatReturnCrossesBiggerThanAllowed_applied_returnEmptyList() {
        // Given
        fitness.fittestResult = (0, [])
        let firstCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth + 1)
        let secondCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth + 1)
        crossover.executeResult = (firstCross, secondCross)

        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // When
        let result = try? populationCrossover.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 2)
        XCTAssertEqual(fitness.fittestCount, 2)
        XCTAssertEqual(crossover.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
        XCTAssertEqual(score.calculateCount, 0)
        XCTAssertEqual(result?.count, 0)
    }

    func testCrossoverThatReturnFirstCrossBiggerThanAllowed_applied_returnExpectedResult() {
        // Given
        fitness.fittestResult = (0, [])
        let firstCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth + 1)
        let secondCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        crossover.executeResult = (firstCross, secondCross)
        evaluator.evaluateCircuitResult = (0, 0)
        score.calculateResult = scoreResult

        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // When
        let result = try? populationCrossover.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 2)
        XCTAssertEqual(fitness.fittestCount, 2)
        XCTAssertEqual(crossover.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(score.calculateCount, 1)

        if let result = result {
            let expectedCrosses = [secondCross]
            XCTAssertEqual(result.count, expectedCrosses.count)

            for (resultCross, expectedCross) in zip(result, expectedCrosses) {
                XCTAssertEqual(resultCross.eval, scoreResult)
                XCTAssertEqual(resultCross.circuit.count, expectedCross.count)

                if let circuit = resultCross.circuit as? [GeneticGateTestDouble] {
                    for (resultGate, expectedGate) in zip(circuit, expectedCross) {
                        XCTAssert(resultGate === expectedGate)
                    }
                } else {
                    XCTAssert(false)
                }
            }
        } else {
            XCTAssert(false)
        }
    }

    func testCrossoverThatReturnSecondCrossBiggerThanAllowed_applied_returnExpectedResult() {
        // Given
        fitness.fittestResult = (0, [])
        let firstCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        let secondCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth + 1)
        crossover.executeResult = (firstCross, secondCross)
        evaluator.evaluateCircuitResult = (0, 0)
        score.calculateResult = scoreResult

        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // When
        let result = try? populationCrossover.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 2)
        XCTAssertEqual(fitness.fittestCount, 2)
        XCTAssertEqual(crossover.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(score.calculateCount, 1)

        if let result = result {
            let expectedCrosses = [firstCross]
            XCTAssertEqual(result.count, expectedCrosses.count)

            for (resultCross, expectedCross) in zip(result, expectedCrosses) {
                XCTAssertEqual(resultCross.eval, scoreResult)
                XCTAssertEqual(resultCross.circuit.count, expectedCross.count)

                if let circuit = resultCross.circuit as? [GeneticGateTestDouble] {
                    for (resultGate, expectedGate) in zip(circuit, expectedCross) {
                        XCTAssert(resultGate === expectedGate)
                    }
                } else {
                    XCTAssert(false)
                }
            }
        } else {
            XCTAssert(false)
        }
    }

    func testEvaluatorThatThrowException_applied_throwException() {
        // Given
        fitness.fittestResult = (0, [])
        let firstCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        let secondCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        crossover.executeResult = (firstCross, secondCross)

        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // Then
        XCTAssertThrowsError(try populationCrossover.applied(to: evalCircuits))
        XCTAssertEqual(randomElementsCount, 2)
        XCTAssertEqual(fitness.fittestCount, 2)
        XCTAssertEqual(crossover.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 2)
        XCTAssertEqual(score.calculateCount, 0)
    }

    func testDependenciesReturnValidValues_applied_returnExpectedResult() {
        // Given
        fitness.fittestResult = (0, [])
        let firstCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        let secondCross = Array(repeating: GeneticGateTestDouble(), count: maxDepth)
        crossover.executeResult = (firstCross, secondCross)
        evaluator.evaluateCircuitResult = (0, 0)
        score.calculateResult = scoreResult

        var randomElementsCount = 0
        let randomElements: MainGeneticPopulationCrossover.RandomElements = { _, _ in
            randomElementsCount += 1

            return [(0, [])]
        }

        let populationCrossover = try! MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                                      maxDepth: maxDepth,
                                                                      fitness: fitness,
                                                                      crossover: crossover,
                                                                      evaluator: evaluator,
                                                                      score: score,
                                                                      randomElements: randomElements)

        // When
        let result = try? populationCrossover.applied(to: evalCircuits)

        // Then
        XCTAssertEqual(randomElementsCount, 2)
        XCTAssertEqual(fitness.fittestCount, 2)
        XCTAssertEqual(crossover.executeCount, 1)
        XCTAssertEqual(evaluator.evaluateCircuitCount, 2)
        XCTAssertEqual(score.calculateCount, 2)

        if let result = result {
            let expectedCrosses = [firstCross, secondCross]
            XCTAssertEqual(result.count, expectedCrosses.count)

            for (resultCross, expectedCross) in zip(result, expectedCrosses) {
                XCTAssertEqual(resultCross.eval, scoreResult)
                XCTAssertEqual(resultCross.circuit.count, expectedCross.count)

                if let circuit = resultCross.circuit as? [GeneticGateTestDouble] {
                    for (resultGate, expectedGate) in zip(circuit, expectedCross) {
                        XCTAssert(resultGate === expectedGate)
                    }
                } else {
                    XCTAssert(false)
                }
            }
        } else {
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testTournamentSizeEqualToZero_init_throwException",
         testTournamentSizeEqualToZero_init_throwException),
        ("testFitnessReturnNil_applied_returnEmptyList",
         testFitnessReturnNil_applied_returnEmptyList),
        ("testCrossoverThatReturnCrossesBiggerThanAllowed_applied_returnEmptyList",
         testCrossoverThatReturnCrossesBiggerThanAllowed_applied_returnEmptyList),
        ("testCrossoverThatReturnFirstCrossBiggerThanAllowed_applied_returnExpectedResult",
         testCrossoverThatReturnFirstCrossBiggerThanAllowed_applied_returnExpectedResult),
        ("testCrossoverThatReturnSecondCrossBiggerThanAllowed_applied_returnExpectedResult",
         testCrossoverThatReturnSecondCrossBiggerThanAllowed_applied_returnExpectedResult),
        ("testEvaluatorThatThrowException_applied_throwException",
         testEvaluatorThatThrowException_applied_throwException),
        ("testDependenciesReturnValidValues_applied_returnExpectedResult",
         testDependenciesReturnValidValues_applied_returnExpectedResult)
    ]
}
