//
//  FixedMatricesNoise+SimulatorKrausMatrixExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/09/2021.
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

// MARK: - SimulatorKrausMatrixExtracting methods

extension FixedMatricesNoise: SimulatorKrausMatrixExtracting {
    func extractKrausMatrix() -> Result<SimulatorKrausMatrix, QuantumOperatorError> {
        guard let firstMatrix = matrices.first else {
            return .failure(.noiseError(error: .noiseMatricesCanNotBeAnEmptyList))
        }

        guard firstMatrix.isSquare else {
            return .failure(.noiseError(error: .noiseMatricesAreNotSquare))
        }

        let rowCount = firstMatrix.rowCount
        guard rowCount.isPowerOfTwo else {
            return .failure(.noiseError(error: .noiseMatricesRowCountHasToBeAPowerOfTwo))
        }

        var total = try! (Matrix.Transformation.adjointed(firstMatrix) * firstMatrix).get()
        for matrix in matrices[1...] {
            if !matrix.isSquare {
                return .failure(.noiseError(error: .noiseMatricesAreNotSquare))
            }

            if matrix.rowCount != rowCount {
                return .failure(.noiseError(error: .noiseMatricesDoNotHaveSameRowCount))
            }

            total = try! (total + (Matrix.Transformation.adjointed(matrix) * matrix).get()).get()
        }

        let identity = try! Matrix.makeIdentity(count: rowCount).get()
        if !total.isApproximatelyEqual(to: identity,
                                       absoluteTolerance: SharedConstants.tolerance) {
            return .failure(.noiseError(error: .noiseMatricesDoNotSatisfyIdentity))
        }

        return .success(AnySimulatorKrausMatrix(matrices: matrices))
    }
}
