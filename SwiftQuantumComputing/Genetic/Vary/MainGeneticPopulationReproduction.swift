//
//  MainGeneticPopulationReproduction.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/02/2019.
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
import os.log

// MARK: - Main body

struct MainGeneticPopulationReproduction {

    // MARK: - Internal types

    typealias Random = (ClosedRange<Double>) -> Double

    // MARK: - Private properties

    private let mutationProbability: Double
    private let mutation: GeneticPopulationMutation
    private let crossover: GeneticPopulationCrossover
    private let random: Random

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(mutationProbability: Double,
         mutation: GeneticPopulationMutation,
         crossover: GeneticPopulationCrossover,
         random: @escaping Random = { Double.random(in: $0) }) {
        self.mutationProbability = mutationProbability
        self.mutation = mutation
        self.crossover = crossover
        self.random = random
    }
}

// MARK: - GeneticPopulationReproduction  methods

extension MainGeneticPopulationReproduction: GeneticPopulationReproduction {
    func applied(to population: [Fitness.EvalCircuit]) throws -> [Fitness.EvalCircuit] {
        var offspring: [Fitness.EvalCircuit] = []

        if (random(0...1) < mutationProbability) {
            var result: Fitness.EvalCircuit?
            do {
                result = try mutation.applied(to: population)
            } catch GeneticPopulationMutationAppliedError.populationIsEmpty {
                throw GeneticPopulationReproductionAppliedError.populationIsEmpty
            } catch GeneticPopulationMutationAppliedError.useCaseEvaluatorsThrowed(let errors) {
                throw GeneticPopulationReproductionAppliedError.useCaseEvaluatorsThrowed(errors: errors)
            } catch {
                fatalError("Unexpected error: \(error).")
            }

            if let result = result {
                os_log("reproduction: mutation produced",
                       log: MainGeneticPopulationReproduction.logger,
                       type: .info)

                offspring.append(result)
            }
        } else {
            var result: [Fitness.EvalCircuit]!
            do {
                result = try crossover.applied(to: population)
            } catch GeneticPopulationCrossoverAppliedError.populationIsEmpty {
                throw GeneticPopulationReproductionAppliedError.populationIsEmpty
            } catch GeneticPopulationCrossoverAppliedError.useCaseEvaluatorsThrowed(let errors) {
                throw GeneticPopulationReproductionAppliedError.useCaseEvaluatorsThrowed(errors: errors)
            } catch {
                fatalError("Unexpected error: \(error).")
            }

            os_log("reproduction: crossover produced",
                   log: MainGeneticPopulationReproduction.logger,
                   type: .info)

            offspring.append(contentsOf: result)
        }

        return offspring
    }
}
