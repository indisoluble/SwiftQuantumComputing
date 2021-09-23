//
//  DensityMatrixSimulatorTestDouble.swift
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class DensityMatrixSimulatorTestDouble {

    // MARK: - Internal properties

    private (set) var applyStateCount = 0
    private (set) var lastApplyStateCircuit: [QuantumOperator]?
    private (set) var lastApplyStateInitialState: CircuitDensityMatrix?
    var applyStateResult: CircuitDensityMatrix?
    var applyStateError = DensityMatrixError.resultingDensityMatrixEigenvaluesDoesNotAddUpToOne
}

// MARK: - DensityMatrixSimulator methods

extension DensityMatrixSimulatorTestDouble: DensityMatrixSimulator  {
    func apply(circuit: [QuantumOperator],
               to initialState: CircuitDensityMatrix) -> Result<CircuitDensityMatrix, DensityMatrixError> {
        applyStateCount += 1

        lastApplyStateInitialState = initialState
        lastApplyStateCircuit = circuit

        if let applyResult = applyStateResult {
            return .success(applyResult)
        }

        return .failure(applyStateError)
    }
}
