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

    private static let logger = Logger()

    // MARK: - Internal init methods

    init(tournamentSize: Int,
         maxDepth: Int,
         fitness: Fitness,
         crossover: GeneticCircuitCrossover,
         evaluator: GeneticCircuitEvaluator,
         score: GeneticCircuitScore,
         randomElements: @escaping RandomElements = { $0.randomElements(count: $1) } ) {
        assert(tournamentSize > 0, "tournamentSize has to be bigger than zero")

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
    func applied(to population: [Fitness.EvalCircuit]) -> Result<[Fitness.EvalCircuit], EvolveCircuitError> {
        let firstSample = randomElements(population, tournamentSize)
        guard let firstWinner = fitness.fittest(in: firstSample) else {
            return .success([])
        }

        let secondSample = randomElements(population, tournamentSize)
        guard let secondWinner = fitness.fittest(in: secondSample) else {
            return .success([])
        }

        let (firstCross, secondCross) = crossover.execute(firstWinner.circuit, secondWinner.circuit)

        var firstEval: Double?
        var firstError: EvolveCircuitError?
        var secondEval: Double?
        var secondError: EvolveCircuitError?
        DispatchQueue.concurrentPerform(iterations: 2) { index in
            if (index == 0) {
                if (firstCross.count <= maxDepth) {
                    switch evaluateCircuit(firstCross) {
                    case .success(let result):
                        firstEval = result
                    case .failure(let error):
                        firstError = error
                    }
                } else {
                    MainGeneticPopulationCrossover.logger.info("croossover: first exceeded max. depth")
                }
            } else if (secondCross.count <= maxDepth) {
                switch evaluateCircuit(secondCross) {
                case .success(let result):
                    secondEval = result
                case .failure(let error):
                    secondError = error
                }
            } else {
                MainGeneticPopulationCrossover.logger.info("croossover: second exceeded max. depth")
            }
        }

        if let firstError = firstError {
            return .failure(firstError)
        }

        if let secondError = secondError {
            return .failure(secondError)
        }

        var crosses: [Fitness.EvalCircuit] = []
        if let firstEval = firstEval {
            crosses.append((firstEval, firstCross))
        }
        if let secondEval = secondEval {
            crosses.append((secondEval, secondCross))
        }

        return .success(crosses)
    }
}

// MARK: - Private body

private extension MainGeneticPopulationCrossover {

    // MARK: - Private methods

    func evaluateCircuit(_ circuit: [GeneticGate]) -> Result<Double, EvolveCircuitError> {
        switch evaluator.evaluateCircuit(circuit) {
        case .success(let evaluation):
            return .success(score.calculate(evaluation))
        case .failure(let error):
            return .failure(error)
        }
    }
}
