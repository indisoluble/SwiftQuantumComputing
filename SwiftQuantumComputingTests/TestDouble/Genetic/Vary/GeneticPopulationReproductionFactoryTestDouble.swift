//
//  GeneticPopulationReproductionFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/03/2019.
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

final class GeneticPopulationReproductionFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeReproductionCount = 0
    private (set) var lastMakeReproductionQubitCount: Int?
    private (set) var lastMakeReproductionTournamentSize: Int?
    private (set) var lastMakeReproductionMutationProbability: Double?
    private (set) var lastMakeReproductionThreshold: Double?
    private (set) var lastMakeReproductionMaxDepth: Int?
    private (set) var lastMakeReproductionUseCases: [GeneticUseCase]?
    private (set) var lastMakeReproductionGates: [Gate]?
    var makeReproductionResult: GeneticPopulationReproduction?
    var makeReproductionError = GeneticPopulationReproductionFactoryMakeReproductionError.qubitCountHasToBeBiggerThanZero
}

// MARK: - GeneticPopulationReproductionFactory methods

extension GeneticPopulationReproductionFactoryTestDouble: GeneticPopulationReproductionFactory {
    func makeReproduction(qubitCount: Int,
                          tournamentSize: Int,
                          mutationProbability: Double,
                          threshold: Double,
                          maxDepth: Int,
                          useCases: [GeneticUseCase],
                          gates: [Gate]) throws -> GeneticPopulationReproduction {
        makeReproductionCount += 1

        lastMakeReproductionQubitCount = qubitCount
        lastMakeReproductionTournamentSize = tournamentSize
        lastMakeReproductionMutationProbability = mutationProbability
        lastMakeReproductionThreshold = threshold
        lastMakeReproductionMaxDepth = maxDepth
        lastMakeReproductionUseCases = useCases
        lastMakeReproductionGates = gates

        if let makeReproductionResult = makeReproductionResult {
            return makeReproductionResult
        }

        throw makeReproductionError
    }
}
