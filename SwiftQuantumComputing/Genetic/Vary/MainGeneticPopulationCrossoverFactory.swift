//
//  MainGeneticPopulationCrossoverFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/02/2019.
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

import Foundation

// MARK: - Main body

struct MainGeneticPopulationCrossoverFactory {

    // MARK: - Private properties

    private let fitness: Fitness
    private let crossover: GeneticCircuitCrossover
    private let score: GeneticCircuitScore

    // MARK: - Internal init methods

    init(fitness: Fitness,
         crossover: GeneticCircuitCrossover,
         score: GeneticCircuitScore) {
        self.fitness = fitness
        self.crossover = crossover
        self.score = score
    }
}

// MARK: - GeneticPopulationCrossoverFactory methods

extension MainGeneticPopulationCrossoverFactory: GeneticPopulationCrossoverFactory {
    func makeCrossover(tournamentSize: Int,
                       maxDepth: Int,
                       evaluator: GeneticCircuitEvaluator) throws -> GeneticPopulationCrossover {
        do {
            return try MainGeneticPopulationCrossover(tournamentSize: tournamentSize,
                                                      maxDepth: maxDepth,
                                                      fitness: fitness,
                                                      crossover: crossover,
                                                      evaluator: evaluator,
                                                      score: score)
        } catch MainGeneticPopulationCrossover.InitError.tournamentSizeHasToBeBiggerThanZero {
            throw GeneticPopulationCrossoverFactoryMakeCrossoverError.tournamentSizeHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
