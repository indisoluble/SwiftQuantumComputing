//
//  NoiseCircuitTestDouble.swift
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class NoiseCircuitTestDouble {

    // MARK: - Internal properties

    private (set) var gatesCount = 0
    var gatesResult: [Gate] = []

    private (set) var circuitDensityMatrixCount = 0
    private (set) var lastCircuitDensityMatrixInitialState: CircuitDensityMatrix?
    var circuitDensityMatrixResult: CircuitDensityMatrix?
    var circuitDensityMatrixError = DensityMatrixError.resultingDensityMatrixEigenvaluesDoesNotAddUpToOne
}

// MARK: - NoiseCircuit methods

extension NoiseCircuitTestDouble: NoiseCircuit {
    var gates: [Gate] {
        gatesCount += 1

        return gatesResult
    }

    func densityMatrix(withInitialState initialState: CircuitDensityMatrix) -> Result<CircuitDensityMatrix, DensityMatrixError> {
        circuitDensityMatrixCount += 1

        lastCircuitDensityMatrixInitialState = initialState

        if let densityMatrixResult = circuitDensityMatrixResult {
            return .success(densityMatrixResult)
        }

        return .failure(circuitDensityMatrixError)
    }
}
