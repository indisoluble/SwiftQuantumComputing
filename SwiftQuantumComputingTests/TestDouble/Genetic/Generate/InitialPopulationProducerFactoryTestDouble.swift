//
//  InitialPopulationProducerFactoryTestDouble.swift
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

final class InitialPopulationProducerFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeProducerCount = 0
    private (set) var lastMakeProducerQubitCount: Int?
    private (set) var lastMakeProducerThreshold: Double?
    private (set) var lastMakeProducerUseCases: [GeneticUseCase]?
    private (set) var lastMakeProducerGates: [Gate]?
    var makeProducerResult: InitialPopulationProducer?
    var makeProducerError = EvolveCircuitError.useCaseCircuitQubitCountHasToBeBiggerThanZero
}

// MARK: - InitialPopulationProducerFactory methods

extension InitialPopulationProducerFactoryTestDouble: InitialPopulationProducerFactory {
    func makeProducer(qubitCount: Int,
                      threshold: Double,
                      useCases: [GeneticUseCase],
                      gates: [Gate]) throws -> InitialPopulationProducer {
        makeProducerCount += 1

        lastMakeProducerQubitCount = qubitCount
        lastMakeProducerThreshold = threshold
        lastMakeProducerUseCases = useCases
        lastMakeProducerGates = gates

        if let makeProducerResult = makeProducerResult {
            return makeProducerResult
        }

        throw makeProducerError
    }
}
