//
//  MainGeneticPopulationMutationFactoryTests.swift
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

class MainGeneticPopulationMutationFactoryTests: XCTestCase {

    // MARK: - Properties

    let fitness = FitnessTestDouble()
    let factory = GeneticCircuitMutationFactoryTestDouble()
    let mutation = GeneticCircuitMutationTestDouble()
    let score = GeneticCircuitScoreTestDouble()
    let qubitCount = 0
    let tournamentSize = 0
    let maxDepth = 0
    let evaluator = GeneticCircuitEvaluatorTestDouble()
    let gates: [Gate] = []

    // MARK: - Tests

    func testFactoryThrowException_makeMutation_throwException() {
        // Given
        let populationFactory = MainGeneticPopulationMutationFactory(fitness: fitness,
                                                                     factory: factory,
                                                                     score: score)

        // Then
        XCTAssertThrowsError(try populationFactory.makeMutation(qubitCount: qubitCount,
                                                                tournamentSize: tournamentSize,
                                                                maxDepth: maxDepth,
                                                                evaluator: evaluator,
                                                                gates: gates))
    }

    func testFactoryReturnMutation_makeMutation_returnValue() {
        // Given
        factory.makeMutationResult = mutation

        let populationFactory = MainGeneticPopulationMutationFactory(fitness: fitness,
                                                                     factory: factory,
                                                                     score: score)

        // Then
        XCTAssertNoThrow(try populationFactory.makeMutation(qubitCount: qubitCount,
                                                            tournamentSize: tournamentSize,
                                                            maxDepth: maxDepth,
                                                            evaluator: evaluator,
                                                            gates: gates))
    }
}
