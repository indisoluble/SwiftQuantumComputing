//
//  GeneticPopulationMutationFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/03/2019.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class GeneticPopulationMutationFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeMutationCount = 0
    private (set) var lastMakeMutationQubitCount: Int?
    private (set) var lastMakeMutationTournamentSize: Int?
    private (set) var lastMakeMutationMaxDepth: Int?
    private (set) var lastMakeMutationEvaluator: GeneticCircuitEvaluator?
    private (set) var lastMakeMutationGates: [Gate]?
    var makeMutationResult: GeneticPopulationMutation?
}

// MARK: - GeneticPopulationMutationFactory methods

extension GeneticPopulationMutationFactoryTestDouble: GeneticPopulationMutationFactory {
    func makeMutation(qubitCount: Int,
                      tournamentSize: Int,
                      maxDepth: Int,
                      evaluator: GeneticCircuitEvaluator,
                      gates: [Gate]) throws -> GeneticPopulationMutation {
        makeMutationCount += 1

        lastMakeMutationQubitCount = qubitCount
        lastMakeMutationTournamentSize = tournamentSize
        lastMakeMutationMaxDepth = maxDepth
        lastMakeMutationEvaluator = evaluator
        lastMakeMutationGates = gates

        if let makeMutationResult = makeMutationResult {
            return makeMutationResult
        }

        throw GeneticPopulationMutationFactoryMakeMutationError.qubitCountHasToBeBiggerThanZero
    }
}
