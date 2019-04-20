//
//  MainInitialPopulationProducerFactory.swift
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

struct MainInitialPopulationProducerFactory {

    // MARK: - Private properties

    private let generatorFactory: GeneticGatesRandomizerFactory
    private let evaluatorFactory: GeneticCircuitEvaluatorFactory
    private let score: GeneticCircuitScore

    // MARK: - Internal init methods

    init(generatorFactory: GeneticGatesRandomizerFactory,
         evaluatorFactory: GeneticCircuitEvaluatorFactory,
         score: GeneticCircuitScore) {
        self.generatorFactory = generatorFactory
        self.evaluatorFactory = evaluatorFactory
        self.score = score
    }
}

// MARK: - InitialPopulationProducerFactory methods

extension MainInitialPopulationProducerFactory: InitialPopulationProducerFactory {
    func makeProducer(qubitCount: Int,
                      threshold: Double,
                      useCases: [GeneticUseCase],
                      gates: [Gate]) throws -> InitialPopulationProducer {
        var generator: GeneticGatesRandomizer!
        do {
            generator = try generatorFactory.makeRandomizer(qubitCount: qubitCount, gates: gates)
        } catch GeneticGatesRandomizerFactoryMakeRandomizerError.qubitCountHasToBeBiggerThanZero {
            throw InitialPopulationProducerFactoryMakeProducerError.qubitCountHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        var evaluator: GeneticCircuitEvaluator!
        do {
            evaluator = try evaluatorFactory.makeEvaluator(qubitCount: qubitCount,
                                                           threshold: threshold,
                                                           useCases: useCases)
        } catch GeneticCircuitEvaluatorFactoryMakeEvaluatorError.qubitCountHasToBeBiggerThanZero {
            throw InitialPopulationProducerFactoryMakeProducerError.qubitCountHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return MainInitialPopulationProducer(generator: generator,
                                             evaluator: evaluator,
                                             score: score)
    }
}
