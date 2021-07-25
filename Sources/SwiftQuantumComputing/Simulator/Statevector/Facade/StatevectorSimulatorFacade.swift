//
//  StatevectorSimulatorFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

struct StatevectorSimulatorFacade {

    // MARK: - Private properties

    private let timeEvolutionFactory: StatevectorTimeEvolutionFactory
    private let statevectorFactory: CircuitStatevectorFactory

    // MARK: - Private class properties

    private static let logger = Logger()

    // MARK: - Internal init methods

    init(timeEvolutionFactory: StatevectorTimeEvolutionFactory,
         statevectorFactory: CircuitStatevectorFactory) {
        self.timeEvolutionFactory = timeEvolutionFactory
        self.statevectorFactory = statevectorFactory
    }
}

// MARK: - StatevectorSimulator methods

extension StatevectorSimulatorFacade: StatevectorSimulator {
    func apply(circuit: [Gate],
               to initialState: CircuitStatevector) -> Result<CircuitStatevector, StatevectorError> {
        StatevectorSimulatorFacade.logger.debug("Producing initial register...")
        var evolution = timeEvolutionFactory.makeTimeEvolution(state: initialState)

        for (index, gate) in circuit.enumerated() {
            StatevectorSimulatorFacade.logger.debug("Applying gate: \(index + 1) of \(circuit.count)...")

            switch evolution.applying(gate) {
            case .success(let nextEvolution):
                evolution = nextEvolution
            case .failure(let error):
                return .failure(.gateThrowedError(gate: gate, error: error))
            }
        }

        StatevectorSimulatorFacade.logger.debug("Getting measurement...")
        switch statevectorFactory.makeStatevector(vector: evolution.measure()) {
        case .success(let finalStateVector):
            return .success(finalStateVector)
        case .failure(.vectorAdditionOfSquareModulusIsNotEqualToOne):
            return .failure(.resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne)
        case .failure(.vectorCountHasToBeAPowerOfTwo):
            fatalError("Unexpected error: \(MakeStatevectorError.vectorCountHasToBeAPowerOfTwo).")
        }
    }
}
