//
//  CircuitDensityMatrixAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/07/2021.
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

struct CircuitDensityMatrixAdapter {

    // MARK: - CircuitDensityMatrix properties

    let densityMatrix: Matrix

    // MARK: - Internal init methods

    enum InitError: Error {
        case eigenvaluesDoesNotAddUpToOne
        case negativeEigenvalues
        case matrixIsNotHermitian
        case unableToComputeEigenvalues
    }

    init(densityMatrix: Matrix) throws {
        let eigenvalues: [Double]
        switch densityMatrix.eigenvalues() {
        case .success(let values):
            eigenvalues = values
        case .failure(.matrixIsNotHermitian):
            throw InitError.matrixIsNotHermitian
        case .failure(.unableToComputeEigenvalues):
            throw InitError.unableToComputeEigenvalues
        }

        let total = try eigenvalues.reduce(0.0) { acc, value in
            if value < 0.0 &&
                !value.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
                throw InitError.negativeEigenvalues
            }

            return acc + value
        }

        if !total.isApproximatelyEqual(to: 1.0, absoluteTolerance: SharedConstants.tolerance) {
            throw InitError.eigenvaluesDoesNotAddUpToOne
        }

        self.densityMatrix = densityMatrix
    }
}

// MARK: - CircuitDensityMatrix methods

extension CircuitDensityMatrixAdapter: CircuitDensityMatrix {}

// MARK: - CircuitProbabilities methods

extension CircuitDensityMatrixAdapter: CircuitProbabilities {}
