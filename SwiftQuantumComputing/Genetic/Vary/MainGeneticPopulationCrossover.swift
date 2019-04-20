//
//  MainGeneticPopulationCrossover.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/02/2019.
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

struct MainGeneticPopulationCrossover {

    // MARK: - Internal types

    typealias RandomElements = ([Fitness.EvalCircuit], Int) -> [Fitness.EvalCircuit]

    // MARK: - Private properties

    private let tournamentSize: Int
    private let maxDepth: Int
    private let fitness: Fitness
    private let crossover: GeneticCircuitCrossover
    private let evaluator: GeneticCircuitEvaluator
    private let score: GeneticCircuitScore
    private let randomElements: RandomElements

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    enum InitError: Error {
        case tournamentSizeHasToBeBiggerThanZero
    }

    init(tournamentSize: Int,
         maxDepth: Int,
         fitness: Fitness,
         crossover: GeneticCircuitCrossover,
         evaluator: GeneticCircuitEvaluator,
         score: GeneticCircuitScore,
         randomElements: @escaping RandomElements = { $0.randomElements(count: $1) } ) throws {
        guard tournamentSize > 0 else {
            throw InitError.tournamentSizeHasToBeBiggerThanZero
        }

        self.tournamentSize = tournamentSize
        self.maxDepth = maxDepth
        self.fitness = fitness
        self.crossover = crossover
        self.evaluator = evaluator
        self.score = score
        self.randomElements = randomElements
    }
}

// MARK: - GeneticPopulationCrossover methods

extension MainGeneticPopulationCrossover: GeneticPopulationCrossover {
    func applied(to population: [Fitness.EvalCircuit]) throws -> [Fitness.EvalCircuit] {
        let firstSample = randomElements(population, tournamentSize)
        let secondSample = randomElements(population, tournamentSize)
        guard let firstWinner = fitness.fittest(in: firstSample),
            let secondWinner = fitness.fittest(in: secondSample) else {
                throw GeneticPopulationCrossoverAppliedError.populationIsEmpty
        }

        let (firstCross, secondCross) = crossover.execute(firstWinner.circuit, secondWinner.circuit)

        var firstEval: Double?
        var firstError: GeneticPopulationCrossoverAppliedError?
        var secondEval: Double?
        var secondError: GeneticPopulationCrossoverAppliedError?
        DispatchQueue.concurrentPerform(iterations: 2) { index in
            if (index == 0) {
                if (firstCross.count <= maxDepth) {
                    do {
                        firstEval = try evaluateCircuit(firstCross)
                    } catch {
                        firstError = error as? GeneticPopulationCrossoverAppliedError
                    }
                } else {
                    os_log("croossover: first exceeded max. depth",
                           log: MainGeneticPopulationCrossover.logger,
                           type: .info)
                }
            } else if (secondCross.count <= maxDepth) {
                do {
                    secondEval = try evaluateCircuit(secondCross)
                } catch {
                    secondError = error as? GeneticPopulationCrossoverAppliedError
                }
            } else {
                os_log("croossover: second exceeded max. depth",
                       log: MainGeneticPopulationCrossover.logger,
                       type: .info)
            }
        }

        if let firstError = firstError {
            throw firstError
        }

        if let secondError = secondError {
            throw secondError
        }

        var crosses: [Fitness.EvalCircuit] = []
        if let firstEval = firstEval {
            crosses.append((firstEval, firstCross))
        }
        if let secondEval = secondEval {
            crosses.append((secondEval, secondCross))
        }

        return crosses
    }
}

// MARK: - Private body

private extension MainGeneticPopulationCrossover {

    // MARK: - Private methods

    func evaluateCircuit(_ circuit: [GeneticGate]) throws -> Double {
        var evaluation: GeneticCircuitEvaluator.Evaluation!
        do {
            evaluation = try evaluator.evaluateCircuit(circuit)
        } catch GeneticCircuitEvaluatorEvaluateCircuitError.useCaseEvaluatorsThrowed(let errors) {
            throw GeneticPopulationCrossoverAppliedError.useCaseEvaluatorsThrowed(errors: errors)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return score.calculate(evaluation)
    }
}
