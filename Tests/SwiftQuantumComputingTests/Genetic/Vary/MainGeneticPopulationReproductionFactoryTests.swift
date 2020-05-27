//
//  MainGeneticPopulationReproductionFactoryTests.swift
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

class MainGeneticPopulationReproductionFactoryTests: XCTestCase {

    // MARK: - Properties

    let evaluatorFactory = GeneticCircuitEvaluatorFactoryTestDouble()
    let crossoverFactory = GeneticPopulationCrossoverFactoryTestDouble()
    let crossover = GeneticPopulationCrossoverTestDouble()
    let mutationFactory = GeneticPopulationMutationFactoryTestDouble()
    let mutation = GeneticPopulationMutationTestDouble()
    let qubitCount = 0
    let tournamentSize = 1
    let mutationProbability = 0.0
    let threshold = 0.0
    let maxDepth = 0
    let useCases: [GeneticUseCase] = []
    let gates: [ConfigurableGate] = []

    // MARK: - Tests

    func testMutationFactoryThrowException_makeReproduction_throwException() {
        // Given
        evaluatorFactory.makeEvaluatorResult = GeneticCircuitEvaluatorTestDouble()

        let factory = MainGeneticPopulationReproductionFactory(evaluatorFactory: evaluatorFactory,
                                                               crossoverFactory: crossoverFactory,
                                                               mutationFactory: mutationFactory)

        // Then
        XCTAssertThrowsError(try factory.makeReproduction(qubitCount: qubitCount,
                                                          tournamentSize: tournamentSize,
                                                          mutationProbability: mutationProbability,
                                                          threshold: threshold,
                                                          maxDepth: maxDepth,
                                                          useCases: useCases,
                                                          gates: gates))
        XCTAssertEqual(evaluatorFactory.makeEvaluatorCount, 1)
        XCTAssertEqual(mutationFactory.makeMutationCount, 1)
        XCTAssertEqual(crossoverFactory.makeCrossoverCount, 0)
    }

    func testcrossoverFactoryThrowException_makeReproduction_throwException() {
        // Given
        evaluatorFactory.makeEvaluatorResult = GeneticCircuitEvaluatorTestDouble()
        mutationFactory.makeMutationResult = mutation

        let factory = MainGeneticPopulationReproductionFactory(evaluatorFactory: evaluatorFactory,
                                                               crossoverFactory: crossoverFactory,
                                                               mutationFactory: mutationFactory)

        // Then
        XCTAssertThrowsError(try factory.makeReproduction(qubitCount: qubitCount,
                                                          tournamentSize: tournamentSize,
                                                          mutationProbability: mutationProbability,
                                                          threshold: threshold,
                                                          maxDepth: maxDepth,
                                                          useCases: useCases,
                                                          gates: gates))
        XCTAssertEqual(evaluatorFactory.makeEvaluatorCount, 1)
        XCTAssertEqual(mutationFactory.makeMutationCount, 1)
        XCTAssertEqual(crossoverFactory.makeCrossoverCount, 1)
    }

    func testAllFActoriesReturnValues_makeReproduction_returnValue() {
        // Given
        evaluatorFactory.makeEvaluatorResult = GeneticCircuitEvaluatorTestDouble()
        mutationFactory.makeMutationResult = mutation
        crossoverFactory.makeCrossoverResult = crossover

        let factory = MainGeneticPopulationReproductionFactory(evaluatorFactory: evaluatorFactory,
                                                               crossoverFactory: crossoverFactory,
                                                               mutationFactory: mutationFactory)

        // When
        let result = try? factory.makeReproduction(qubitCount: qubitCount,
                                                   tournamentSize: tournamentSize,
                                                   mutationProbability: mutationProbability,
                                                   threshold: threshold,
                                                   maxDepth: maxDepth,
                                                   useCases: useCases,
                                                   gates: gates)

        // Then
        XCTAssertEqual(evaluatorFactory.makeEvaluatorCount, 1)
        XCTAssertEqual(mutationFactory.makeMutationCount, 1)
        XCTAssertEqual(crossoverFactory.makeCrossoverCount, 1)
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testMutationFactoryThrowException_makeReproduction_throwException",
         testMutationFactoryThrowException_makeReproduction_throwException),
        ("testcrossoverFactoryThrowException_makeReproduction_throwException",
         testcrossoverFactoryThrowException_makeReproduction_throwException),
        ("testAllFActoriesReturnValues_makeReproduction_returnValue",
         testAllFActoriesReturnValues_makeReproduction_returnValue)
    ]
}
