//
//  DensityMatrixSimulatorFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

struct DensityMatrixSimulatorFacade {

    // MARK: - Private properties

    private let timeEvolutionFactory: DensityMatrixTimeEvolutionFactory
    private let densityMatrixFactory: CircuitDensityMatrixFactory

    // MARK: - Private class properties

    private static let logger = Logger()

    // MARK: - Internal init methods

    init(timeEvolutionFactory: DensityMatrixTimeEvolutionFactory,
         densityMatrixFactory: CircuitDensityMatrixFactory) {
        self.timeEvolutionFactory = timeEvolutionFactory
        self.densityMatrixFactory = densityMatrixFactory
    }
}

// MARK: - DensityMatrixSimulator methods

extension DensityMatrixSimulatorFacade: DensityMatrixSimulator {
    func apply(circuit: [Gate], to initialState: CircuitDensityMatrix) -> Result<CircuitDensityMatrix, DensityMatrixError> {
        DensityMatrixSimulatorFacade.logger.debug("Preparing time evolution...")
        var evolution = timeEvolutionFactory.makeTimeEvolution(state: initialState)

        for (index, gate) in circuit.enumerated() {
            DensityMatrixSimulatorFacade.logger.debug("Applying gate: \(index + 1) of \(circuit.count)...")

            switch evolution.applying(gate) {
            case .success(let nextEvolution):
                evolution = nextEvolution
            case .failure(let error):
                return .failure(.gateThrowedError(gate: gate, error: error))
            }
        }

        DensityMatrixSimulatorFacade.logger.debug("Getting final state...")
        switch densityMatrixFactory.makeDensityMatrix(matrix: evolution.state) {
        case .success(let finalDensityMatrix):
            return .success(finalDensityMatrix)
        case .failure(.matrixEigenvaluesDoesNotAddUpToOne):
            return .failure(.resultingDensityMatrixEigenvaluesDoesNotAddUpToOne)
        case .failure(.matrixIsNotHermitian):
            return .failure(.resultingDensityMatrixIsNotHermitian)
        case .failure(.matrixWithNegativeEigenvalues):
            return .failure(.resultingDensityMatrixWithNegativeEigenvalues)
        case .failure(.unableToComputeMatrixEigenvalues):
            return .failure(.unableToComputeresultingDensityMatrixEigenvalues)
        }
    }
}
