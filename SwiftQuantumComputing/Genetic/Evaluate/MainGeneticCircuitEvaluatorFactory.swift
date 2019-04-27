//
//  MainGeneticCircuitEvaluatorFactory.swift
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

struct MainGeneticCircuitEvaluatorFactory {

    // MARK: - Private properties

    private let factory: GeneticUseCaseEvaluatorFactory

    // MARK: - Internal init methods

    init(factory: GeneticUseCaseEvaluatorFactory) {
        self.factory = factory
    }
}

// MARK: - GeneticCircuitEvaluatorFactory methods

extension MainGeneticCircuitEvaluatorFactory: GeneticCircuitEvaluatorFactory {
    func makeEvaluator(qubitCount: Int,
                       threshold: Double,
                       useCases: [GeneticUseCase]) throws -> GeneticCircuitEvaluator {
        let evaluators = try useCases.map {
            try factory.makeEvaluator(qubitCount: qubitCount, useCase: $0)
        }

        return MainGeneticCircuitEvaluator(threshold: threshold, evaluators: evaluators)
    }
}
