//
//  MainGeneticCircuitMutationFactory.swift
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

struct MainGeneticCircuitMutationFactory {

    // MARK: - Private properties

    private let factory: GeneticGatesRandomizerFactory

    // MARK: - Internal init methods

    init(factory: GeneticGatesRandomizerFactory) {
        self.factory = factory
    }
}

// MARK: - GeneticCircuitMutationFactory methods

extension MainGeneticCircuitMutationFactory: GeneticCircuitMutationFactory {
    func makeMutation(qubitCount: Int,
                      maxDepth: Int,
                      gates: [Gate]) throws -> GeneticCircuitMutation {
        var randomizer: GeneticGatesRandomizer!
        do {
            randomizer = try factory.makeRandomizer(qubitCount: qubitCount, gates: gates)
        } catch GeneticGatesRandomizerFactoryMakeRandomizerError.qubitCountHasToBeBiggerThanZero {
            throw GeneticCircuitMutationFactoryMakeMutationError.qubitCountHasToBeBiggerThanZero
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return MainGeneticCircuitMutation(maxDepth: maxDepth, randomizer: randomizer)
    }
}
