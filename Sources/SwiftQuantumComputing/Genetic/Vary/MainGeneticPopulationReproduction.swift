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

    private static let logger = Logger()

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
    func applied(to population: [Fitness.EvalCircuit]) -> Result<[Fitness.EvalCircuit], EvolveCircuitError> {
        if (random(0...1) < mutationProbability) {
            switch mutation.applied(to: population) {
            case .success(let result):
                MainGeneticPopulationReproduction.logger.info("reproduction: mutation produced")

                return .success(result != nil ? [result!] : [])
            case .failure(let error):
                return .failure(error)
            }
        }

        switch crossover.applied(to: population) {
        case .success(let result):
            if !result.isEmpty {
                MainGeneticPopulationReproduction.logger.info("reproduction: crossover produced")
            }

            return .success(result)
        case .failure(let error):
            return .failure(error)
        }
    }
}
