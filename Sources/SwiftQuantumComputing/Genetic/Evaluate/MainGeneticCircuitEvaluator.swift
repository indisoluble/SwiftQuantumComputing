//
//  MainGeneticCircuitEvaluator.swift
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

// MARK: - Main body

struct MainGeneticCircuitEvaluator {

    // MARK: - Private properties

    private let threshold: Double
    private let evaluators: [GeneticUseCaseEvaluator]

    // MARK: - Internal init methods

    init(threshold: Double, evaluators: [GeneticUseCaseEvaluator]) {
        self.threshold = threshold
        self.evaluators = evaluators
    }
}

// MARK: - GeneticCircuitEvaluator methods

extension MainGeneticCircuitEvaluator: GeneticCircuitEvaluator {
    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) -> Result<Evaluation, EvolveCircuitError> {
        var misses = 0
        var maxProbability = 0.0
        var anyUseCaseError: EvolveCircuitError?

        let queue = DispatchQueue(label: String(reflecting: type(of: self)))
        DispatchQueue.concurrentPerform(iterations: evaluators.count) { index in
            let result = evaluators[index].evaluateCircuit(geneticCircuit)

            queue.sync {
                switch result {
                case .success(let probability):
                    misses += (probability > threshold ? 1 : 0)
                    maxProbability = max(maxProbability, probability)
                case .failure(let error):
                    anyUseCaseError = error
                }
            }
        }

        if let anyUseCaseError = anyUseCaseError {
            return .failure(anyUseCaseError)
        }

        return .success((misses, maxProbability))
    }
}
