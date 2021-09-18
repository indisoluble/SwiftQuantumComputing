//
//  NoiseCircuit.swift
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

// MARK: - Errors

/// Errors throwed by `Circuit.densityMatrix(withInitialState:)`
public enum DensityMatrixError: Error, Hashable {
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: QuantumOperatorError)
    /// Throwed when the resulting density matrix is not a valid: its eigenvalues do not add to one
    case resultingDensityMatrixEigenvaluesDoesNotAddUpToOne
    /// Throwed when the resulting density matrix is not a valid: it is not hermitian
    case resultingDensityMatrixIsNotHermitian
    /// Throwed when the resulting density matrix is not a valid: at least one of its eigenvalues is negative
    case resultingDensityMatrixWithNegativeEigenvalues
    /// Throwed if it was not possible to get the eigenvalues for the resulting density matrix
    case unableToComputeResultingDensityMatrixEigenvalues

}

// MARK: - Protocol definition

/// A quantum circuit with noise
public protocol NoiseCircuit {
    /// Gates in the circuit
    var gates: [Gate] { get }

    /**
     Applies `gates` to `initialState` to produce a new density matrix.

     - Parameter initialState: Used to initialized circuit to given state.

     - Returns: Another `CircuitDensityMatrix` instance, result of applying `gates` to `initialState`. Or
     `DensityMatrixError` error.
     */
    func densityMatrix(withInitialState initialState: CircuitDensityMatrix) -> Result<CircuitDensityMatrix, DensityMatrixError>
}
