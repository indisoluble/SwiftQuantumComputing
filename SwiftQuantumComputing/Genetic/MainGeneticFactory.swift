//
//  MainGeneticFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/02/2019.
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

public struct MainGeneticFactory {

    // MARK: - Private properties

    private let initialPopulationFactory: InitialPopulationProducerFactory
    private let fitness: Fitness
    private let reproductionFactory: GeneticPopulationReproductionFactory
    private let oracleFactory: OracleCircuitFactory

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init() {
        let generatorFactory = MainGeneticGatesRandomizerFactory()
        let circuitFactory = MainCircuitFactory()
        let oracleFactory = MainOracleCircuitFactory()
        let useCaseEvaluatorFactory = MainGeneticUseCaseEvaluatorFactory(factory: circuitFactory,
                                                                         oracleFactory:oracleFactory)
        let evaluatorFactory = MainGeneticCircuitEvaluatorFactory(factory: useCaseEvaluatorFactory)
        let score = MainGeneticCircuitScore()
        let producerFactory = MainInitialPopulationProducerFactory(generatorFactory: generatorFactory,
                                                                   evaluatorFactory: evaluatorFactory,
                                                                   score: score)

        let fitness = MainFitness()
        let circuitCrossover = MainGeneticCircuitCrossover()
        let crossoverFactory = MainGeneticPopulationCrossoverFactory(fitness: fitness,
                                                                     crossover: circuitCrossover,
                                                                     score: score)
        let circuitMutationFactory = MainGeneticCircuitMutationFactory(factory: generatorFactory)
        let mutationFactory = MainGeneticPopulationMutationFactory(fitness: fitness,
                                                                   factory: circuitMutationFactory,
                                                                   score: score)
        let reproductionFactory = MainGeneticPopulationReproductionFactory(evaluatorFactory: evaluatorFactory,
                                                                           crossoverFactory: crossoverFactory,
                                                                           mutationFactory: mutationFactory)

        self.init(initialPopulationFactory: producerFactory,
                  fitness: fitness,
                  reproductionFactory: reproductionFactory,
                  oracleFactory: oracleFactory)
    }

    // MARK: - Internal init methods

    init(initialPopulationFactory: InitialPopulationProducerFactory,
         fitness: Fitness,
         reproductionFactory: GeneticPopulationReproductionFactory,
         oracleFactory: OracleCircuitFactory) {
        self.initialPopulationFactory = initialPopulationFactory
        self.fitness = fitness
        self.reproductionFactory = reproductionFactory
        self.oracleFactory = oracleFactory
    }
}


// MARK: - GeneticFactory methods

extension MainGeneticFactory: GeneticFactory {
    public func evolveCircuit(configuration config: GeneticConfiguration,
                              useCases: [GeneticUseCase],
                              gates: [Gate]) throws -> EvolvedCircuit {
        guard let initSize = config.populationSize.first else {
            throw GeneticFactoryEvolveCircuitError.configurationPopulationSizeIsEmpty
        }
        let maxSize = config.populationSize.last!

        guard let maxDepth = config.depth.last else {
            throw GeneticFactoryEvolveCircuitError.configurationDepthIsEmpty
        }

        guard let firstCase = useCases.first else {
            throw GeneticFactoryEvolveCircuitError.useCaseListIsEmpty
        }

        let qubitCount = firstCase.circuit.qubitCount
        guard useCases.reduce(true, { $0 && $1.circuit.qubitCount == qubitCount })  else {
            throw GeneticFactoryEvolveCircuitError.useCasesDoNotSpecifySameCircuitQubitCount
        }

        var initialPopulation: InitialPopulationProducer!
        do {
            initialPopulation = try initialPopulationFactory.makeProducer(qubitCount: qubitCount,
                                                                          threshold: config.threshold,
                                                                          useCases: useCases,
                                                                          gates: gates)
        } catch InitialPopulationProducerFactoryMakeProducerError.qubitCountHasToBeBiggerThanZero {
            throw GeneticFactoryEvolveCircuitError.useCaseCircuitQubitCountHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        var reproduction: GeneticPopulationReproduction!
        do {
            reproduction = try reproductionFactory.makeReproduction(qubitCount: qubitCount,
                                                                    tournamentSize: config.tournamentSize,
                                                                    mutationProbability: config.mutationProbability,
                                                                    threshold: config.threshold,
                                                                    maxDepth: maxDepth,
                                                                    useCases: useCases,
                                                                    gates: gates)
        } catch GeneticPopulationReproductionFactoryMakeReproductionError.qubitCountHasToBeBiggerThanZero {
            throw GeneticFactoryEvolveCircuitError.useCaseCircuitQubitCountHasToBeBiggerThanZero
        } catch GeneticPopulationReproductionFactoryMakeReproductionError.tournamentSizeHasToBeBiggerThanZero {
            throw GeneticFactoryEvolveCircuitError.configurationTournamentSizeHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        os_log("Producing initial population...", log: MainGeneticFactory.logger, type: .info)
        var population: [Fitness.EvalCircuit]!
        do {
            population = try initialPopulation.execute(size: initSize, depth: config.depth)
        } catch InitialPopulationProducerExecuteError.populationSizeHasToBeBiggerThanZero {
            throw GeneticFactoryEvolveCircuitError.configurationPopulationSizeHasToBeBiggerThanZero
        } catch InitialPopulationProducerExecuteError.useCaseEvaluatorsThrowedErrorsForAtLeastOneCircuit(let errors) {
            throw GeneticFactoryEvolveCircuitError.useCaseEvaluatorsThrowed(errors: errors)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
        os_log("Initial population completed", log: MainGeneticFactory.logger, type: .info)

        var candidate = fitness.fittest(in: population)!

        var currGen = 0
        let errProb = config.errorProbability
        let genCount = config.generationCount
        while (candidate.eval > errProb) && (currGen < genCount) && (population.count < maxSize) {
            os_log("Init. generation %d...", log: MainGeneticFactory.logger, type: .info, currGen)

            var offspring: [Fitness.EvalCircuit]!
            do {
                offspring = try reproduction.applied(to: population)
            } catch GeneticPopulationReproductionAppliedError.useCaseEvaluatorsThrowed(let errors) {
                throw GeneticFactoryEvolveCircuitError.useCaseEvaluatorsThrowed(errors: errors)
            } catch {
                fatalError("Unexpected error: \(error).")
            }

            if (offspring.isEmpty) {
                os_log("evolveCircuit: empty offspr.", log: MainGeneticFactory.logger, type: .debug)
            } else {
                population.append(contentsOf: offspring)
                candidate = fitness.fittest(in: population)!
            }

            os_log("Generation %d completed. Population: %d. Evaluation: %s",
                   log: MainGeneticFactory.logger,
                   type: .info,
                   currGen, population.count, String(candidate.eval))

            currGen += 1
        }

        let circuit = try! oracleFactory.makeOracleCircuit(geneticCircuit: candidate.circuit,
                                                           useCase: firstCase)

        return (candidate.eval, circuit.circuit, circuit.oracleAt)
    }
}
