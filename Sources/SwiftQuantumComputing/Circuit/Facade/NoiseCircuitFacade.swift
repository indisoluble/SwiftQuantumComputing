//
//  NoiseCircuitFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/09/2021.
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

struct NoiseCircuitFacade {

    // MARK: - Circuit properties

    let quantumOperators: [QuantumOperator]

    // MARK: - Private properties

    private let densityMatrixSimulator: DensityMatrixSimulator

    // MARK: - Internal init methods

    init(quantumOperators: [QuantumOperator], densityMatrixSimulator: DensityMatrixSimulator) {
        self.quantumOperators = quantumOperators
        self.densityMatrixSimulator = densityMatrixSimulator
    }
}

// MARK: - CustomStringConvertible methods

extension NoiseCircuitFacade: CustomStringConvertible {
    var description: String {
        return quantumOperators.description
    }
}

// MARK: - NoiseCircuit methods

extension NoiseCircuitFacade: NoiseCircuit {
    func densityMatrix(withInitialState initialState: CircuitDensityMatrix) -> Result<CircuitDensityMatrix & CircuitProbabilities, DensityMatrixError> {
        return densityMatrixSimulator.apply(circuit: quantumOperators, to: initialState)
    }
}
