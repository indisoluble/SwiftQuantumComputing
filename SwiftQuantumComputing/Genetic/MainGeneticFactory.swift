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

    // MARK: - Private types

    private struct Operators {
        let generator: GeneticGatesRandomizer
        let evaluator: GeneticCircuitEvaluator
        let mutation: GeneticMutation
    }

    private typealias EvalCircuit = (eval: Double, circuit: [GeneticGate])

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init() {}
}


// MARK: - GeneticFactory methods

extension MainGeneticFactory: GeneticFactory {
    public func evolveCircuit(configuration: GeneticConfiguration,
                              useCases: [GeneticUseCase],
                              gates: [Gate]) -> EvolvedCircuit? {
        guard let operators = MainGeneticFactory.makeOperators(configuration: configuration,
                                                               useCases: useCases,
                                                               gates: gates) else {
                                                                return nil
        }

        os_log("Producing initial population...",
               log: MainGeneticFactory.logger,
               type: .info)
        guard var population = MainGeneticFactory.produceInitialPopulation(configuration: configuration,
                                                                           operators: operators) else {
                                                                            return nil
        }
        os_log("Initial population completed",
               log: MainGeneticFactory.logger,
               type: .info)

        var candidate = MainGeneticFactory.fittest(in: population)!
        let genCount = configuration.generationCount
        let maxSize = configuration.populationSize.last!
        let errorProb = configuration.errorProbability

        var currentGen = 0
        while (candidate.eval > errorProb) && (currentGen < genCount) && (population.count < maxSize) {
            os_log("Initiating generation %d...",
                   log: MainGeneticFactory.logger,
                   type: .info,
                   currentGen)

            let offspring = MainGeneticFactory.produceOffspring(configuration: configuration,
                                                                operators: operators,
                                                                population: population)
            if (offspring.count == 0) {
                os_log("Unable to produce new offspring",
                       log: MainGeneticFactory.logger,
                       type: .info)
            } else {
                population.append(contentsOf: offspring)
                candidate = MainGeneticFactory.fittest(in: population)!
            }

            os_log("Generation %d completed. Population: %d. Evaluation: %s",
                   log: MainGeneticFactory.logger,
                   type: .info,
                   currentGen, population.count, String(candidate.eval))

            currentGen += 1
        }

        return MainGeneticFactory.composeEvolvedCircuit(with: candidate, useCases: useCases)
    }
}

// MARK: - Private body

private extension MainGeneticFactory {

    // MARK: - Private class methods

    private static func produceInitialPopulation(configuration: GeneticConfiguration,
                                                 operators: Operators) -> [EvalCircuit]? {
        guard let initialSize = configuration.populationSize.first, initialSize > 0 else {
            os_log("produceInitialPopulation failed: population size has to be bigger than 0",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return nil
        }

        var population: [EvalCircuit] = []
        let queue = DispatchQueue(label: "com.indisoluble.SwiftQuantumComputing.MainGeneticFactory.produceInitialPopulation.queue")

        DispatchQueue.concurrentPerform(iterations: initialSize) { _ in
            let generator = operators.generator
            let evaluator = operators.evaluator
            let depth = Int.random(in: configuration.depth)

            guard let circuit = generator.make(depth: depth) else {
                return
            }

            guard let eval = MainGeneticFactory.evaluateCircuit(circuit, with: evaluator) else {
                return
            }

            queue.sync {
                population.append((eval, circuit))
            }
        }

        if (population.count != initialSize) {
            os_log("produceInitialPopulation failed: unable to fill initial population",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return nil
        }

        return population
    }

    private static func produceOffspring(configuration: GeneticConfiguration,
                                         operators: Operators,
                                         population: [EvalCircuit]) -> [EvalCircuit] {
        var offspring: [EvalCircuit] = []

        let prob = Double.random(in: 0...1)
        if (prob < configuration.mutationProbability) {
            if let mutation = produceMutation(configuration: configuration,
                                              operators: operators,
                                              population: population) {
                os_log("produceOffspring: mutation produced",
                       log: MainGeneticFactory.logger,
                       type: .info)

                offspring.append(mutation)
            }
        } else {
            let crosses = produceCrossover(configuration: configuration,
                                           operators: operators,
                                           population: population)
            os_log("produceOffspring: crossover produced",
                   log: MainGeneticFactory.logger,
                   type: .info)

            offspring.append(contentsOf: crosses)
        }

        return offspring
    }

    private static func produceCrossover(configuration: GeneticConfiguration,
                                         operators: Operators,
                                         population: [EvalCircuit]) -> [EvalCircuit] {
        guard let maxDepth = configuration.depth.last else {
            os_log("produceCrossover failed: unable to produce a crossover without a max. depth",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return []
        }

        let firstSample = population.randomElements(count: configuration.tournamentSize)
        guard let firstWinner = fittest(in: firstSample) else {
            return []
        }

        let secondSample = population.randomElements(count: configuration.tournamentSize)
        guard let secondWinner = fittest(in: secondSample) else {
            return []
        }

        let (firstCross, secondCross) = GeneticCrossover.execute(firstWinner.circuit,
                                                                 secondWinner.circuit)

        var firstEval: Double? = nil
        var secondEval: Double? = nil
        DispatchQueue.concurrentPerform(iterations: 2) { index in
            if (index == 0) {
                if (firstCross.count <= maxDepth) {
                    firstEval = evaluateCircuit(firstCross, with: operators.evaluator)
                } else {
                    os_log("produceCrossover: first exceeded max. depth",
                           log: MainGeneticFactory.logger,
                           type: .info)
                }
            } else if (secondCross.count <= maxDepth) {
                secondEval = evaluateCircuit(secondCross, with: operators.evaluator)
            } else {
                os_log("produceCrossover: second exceeded max. depth",
                       log: MainGeneticFactory.logger,
                       type: .info)
            }
        }

        var crosses: [EvalCircuit] = []
        if let firstEval = firstEval {
            crosses.append((firstEval, firstCross))
        }
        if let secondEval = secondEval {
            crosses.append((secondEval, secondCross))
        }

        return crosses
    }

    private static func produceMutation(configuration: GeneticConfiguration,
                                        operators: Operators,
                                        population: [EvalCircuit]) -> EvalCircuit? {
        let sample = population.randomElements(count: configuration.tournamentSize)
        guard let winner = fittest(in: sample) else {
            return nil
        }

        guard let mutated = operators.mutation.execute(winner.circuit) else {
            return nil
        }

        guard let eval = evaluateCircuit(mutated, with: operators.evaluator) else {
            return nil
        }

        return (eval, mutated)
    }

    private static func fittest(in population:[EvalCircuit]) -> EvalCircuit? {
        return population.min { $0.eval < $1.eval }
    }

    static func evaluateCircuit(_ circuit: [GeneticGate],
                                with evaluator: GeneticCircuitEvaluator) -> Double? {
        guard let eval = evaluator.evaluateCircuit(circuit) else {
            return nil
        }

        return (Double(eval.misses) + eval.maxProbability)
    }

    private static func composeEvolvedCircuit(with candidate: EvalCircuit,
                                              useCases: [GeneticUseCase]) -> EvolvedCircuit? {
        guard let firstCase = useCases.first else {
            os_log("composeEvolvedCircuit failed: at least one use case required",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return nil
        }

        let cc = candidate.circuit
        guard let fixed = GeneticUseCaseEvaluator.toFixedGates(cc, using: firstCase) else {
            return nil
        }

        return (candidate.eval, fixed.gates, fixed.oracleAt)
    }

    private static func makeOperators(configuration: GeneticConfiguration,
                                      useCases: [GeneticUseCase],
                                      gates: [Gate]) -> Operators? {
        let evaluator = makeEvaluator(configuration: configuration, useCases: useCases)

        guard let generator = makeGenerator(configuration: configuration, gates: gates) else {
            return nil
        }

        guard let mutation = makeMutation(configuration: configuration, generator: generator) else {
            return nil
        }

        return Operators(generator: generator, evaluator: evaluator, mutation: mutation)
    }

    static func makeEvaluator(configuration: GeneticConfiguration,
                              useCases: [GeneticUseCase]) -> GeneticCircuitEvaluator {
        return GeneticCircuitEvaluator(qubitCount: configuration.qubitCount,
                                       factory: MainCircuitFactory(),
                                       threshold: configuration.threshold,
                                       useCases: useCases)
    }

    static func makeGenerator(configuration: GeneticConfiguration,
                              gates: [Gate]) -> GeneticGatesRandomizer? {
        var facts: [GeneticGateFactory] = gates.map { SimpleGeneticGateFactory(gate: $0) }
        facts.append(ConfigurableGeneticGateFactory())

        return GeneticGatesRandomizer(qubitCount: configuration.qubitCount, factories: facts)
    }

    static func makeMutation(configuration: GeneticConfiguration,
                             generator: GeneticGatesRandomizer) -> GeneticMutation? {
        guard let maxDepth = configuration.depth.last else {
            os_log("makeMutation failed: unable to produce a mutation without a max. depth",
                   log: MainGeneticFactory.logger,
                   type: .debug)

            return nil
        }

        return GeneticMutation(maxDepth: maxDepth, randomizer: generator)
    }
}
