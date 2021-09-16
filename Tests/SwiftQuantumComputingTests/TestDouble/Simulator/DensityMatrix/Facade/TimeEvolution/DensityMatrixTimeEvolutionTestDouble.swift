//
//  DensityMatrixTimeEvolutionTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/07/2021.
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

final class DensityMatrixTimeEvolutionTestDouble {

    // MARK: - Internal properties

    private (set) var stateCount = 0
    var stateResult = Matrix.makeNot()

    private (set) var applyingCount = 0
    private (set) var lastApplyingGate: Gate?
    var applyingResult: DensityMatrixTimeEvolution?
    var applyingError = QuantumOperatorError.circuitQubitCountHasToBeBiggerThanZero
}

// MARK: - DensityMatrixTimeEvolution methods

extension DensityMatrixTimeEvolutionTestDouble: DensityMatrixTimeEvolution {
    var state: Matrix {
        stateCount += 1

        return stateResult
    }

    func applying(_ gate: Gate) -> Result<DensityMatrixTimeEvolution, QuantumOperatorError> {
        applyingCount += 1

        lastApplyingGate = gate

        if let applyResult = applyingResult {
            return .success(applyResult)
        }

        return .failure(applyingError)
    }
}
