//
//  FixedMatrixGate+SimulatorGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/11/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

// MARK: - SimulatorGate methods

extension FixedMatrixGate: SimulatorGate {}

// MARK: - SimulatorComponents methods

extension FixedMatrixGate: SimulatorComponents {
    func extractRawInputs() -> [Int] {
        return inputs
    }

    func extractMatrix() -> Result<SimulatorGateMatrix, GateError> {
        guard matrix.rowCount.isPowerOfTwo else {
            return .failure(.gateMatrixRowCountHasToBeAPowerOfTwo)
        }
        // Validate matrix before expanding it so the operation requires less time
        guard matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance) else {
            return .failure(.gateMatrixIsNotUnitary)
        }

        return .success(.matrix(matrix: matrix))
    }
}
