//
//  DensityMatrixTransformationTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/07/2021.
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

final class DensityMatrixTransformationTestDouble {

    // MARK: - Internal properties

    private (set) var applyCount = 0
    private (set) var lastApplyGate: Gate?
    private (set) var lastApplyDensityMatrix: Matrix?
    var applyResult: Matrix?
    var applyError = QuantumOperatorError.circuitQubitCountHasToBeBiggerThanZero
}

// MARK: - DensityMatrixTransformation methods

extension DensityMatrixTransformationTestDouble: DensityMatrixTransformation {
    func apply(gate: Gate, toDensityMatrix matrix: Matrix) -> Result<Matrix, QuantumOperatorError> {
        applyCount += 1

        lastApplyGate = gate
        lastApplyDensityMatrix = matrix

        if let applyResult = applyResult {
            return .success(applyResult)
        }

        return .failure(applyError)
    }
}
