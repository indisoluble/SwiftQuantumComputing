//
//  GeneticCircuitEvaluator.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/01/2019.
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

struct GeneticCircuitEvaluator {

    // MARK: - Internal types

    typealias Result = (misses: Int, maxProbability: Double)

    // MARK: - Private properties

    private let threshold: Double
    private let evaluators: [GeneticUseCaseEvaluator]
    private let queue = DispatchQueue(label: "com.indisoluble.SwiftQuantumComputing.GeneticCircuitEvaluator.queue")

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(qubitCount: Int,
         useCases: [GeneticUseCase],
         threshold: Double,
         factory: CircuitFactory,
         oracleFactory: OracleCircuitFactory) {
        self.threshold = threshold
        evaluators = useCases.map {
            GeneticUseCaseEvaluator(qubitCount: qubitCount,
                                    useCase: $0,
                                    factory: factory,
                                    oracleFactory: oracleFactory)
        }
    }

    // MARK: - Internal methods

    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) -> Result? {
        var success = true
        var misses = 0
        var maxProbability = 0.0

        DispatchQueue.concurrentPerform(iterations: evaluators.count) { index in
            let prob = evaluators[index].evaluateCircuit(geneticCircuit)

            queue.sync {
                if let prob = prob {
                    misses += (prob > threshold ? 1 : 0)
                    maxProbability = max(maxProbability, prob)
                } else {
                    success = false

                    os_log("evaluateCircuit: unable to get all error probabilities",
                           log: GeneticCircuitEvaluator.logger,
                           type: .debug)
                }
            }
        }

        return (success ? (misses, maxProbability) : nil)
    }
}
