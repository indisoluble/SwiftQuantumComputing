//
//  GeneticCircuitMutationFactoryTestDouble.swift
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

final class GeneticCircuitMutationFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeMutationCount = 0
    private (set) var lastMakeMutationQubitCount: Int?
    private (set) var lastMakeMutationMaxDepth: Int?
    private (set) var lastMakeMutationGates: [Gate]?
    var makeMutationResult: GeneticCircuitMutation?
}

// MARK: - GeneticCircuitMutationFactory methods

extension GeneticCircuitMutationFactoryTestDouble: GeneticCircuitMutationFactory {
    func makeMutation(qubitCount: Int, maxDepth: Int, gates: [Gate]) -> GeneticCircuitMutation? {
        makeMutationCount += 1

        lastMakeMutationQubitCount = qubitCount
        lastMakeMutationMaxDepth = maxDepth
        lastMakeMutationGates = gates

        return makeMutationResult
    }
}
