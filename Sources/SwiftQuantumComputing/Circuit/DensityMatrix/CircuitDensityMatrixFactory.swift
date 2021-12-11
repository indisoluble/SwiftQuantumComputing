//
//  CircuitDensityMatrixFactory.swift
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

// MARK: - Errors

/// Errors throwed by `CircuitDensityMatrixFactory.makeDensityMatrix(matrix:)`
public enum MakeDensityMatrixError: Error {
    /// Throwed when `matrix` is not a valid density matrix: its eigenvalues do not add to one
    case matrixEigenvaluesDoesNotAddUpToOne
    /// Throwed when `matrix` is not a valid density matrix: it is not hermitian
    case matrixIsNotHermitian
    /// Throwed when `matrix` is not a valid density matrix: at least one of its eigenvalues is negative
    case matrixWithNegativeEigenvalues
    /// Throwed if it was not possible to get the eigenvalues for the given `matrix`
    case unableToComputeMatrixEigenvalues
}

// MARK: - Protocol definition

/// Factory to build `CircuitDensityMatrix` instances
public protocol CircuitDensityMatrixFactory {

    /**
     Builds `CircuitDensityMatrix` instances.

     - Parameter matrix: State of a quantum circuit expressed as a `Matrix`.

     - Returns: A `CircuitDensityMatrix` instance. Or `MakeDensityMatrixError` error.
     */
    func makeDensityMatrix(matrix: Matrix) -> Result<CircuitDensityMatrix & CircuitProbabilities, MakeDensityMatrixError>
}
