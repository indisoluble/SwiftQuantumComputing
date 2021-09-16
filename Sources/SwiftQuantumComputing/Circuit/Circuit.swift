//
//  Circuit.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

/// Errors throwed by `Circuit.statevector(withInitialState:)`
public enum StatevectorError: Error, Hashable {
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: QuantumOperatorError)
    /// Throwed when the resulting state vector lost too much precision after applying `gates`
    case resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne
}

/// Errors throwed by `Circuit.unitary(withQubitCount:)`
public enum UnitaryError: Error, Hashable {
    /// Throwed when the circuit has no gate from which to produce an unitary matrix
    case circuitCanNotBeAnEmptyList
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: QuantumOperatorError)
    /// Throwed when the resulting matrix lost too much precision after applying `gates`
    case resultingMatrixIsNotUnitary
}

// MARK: - Protocol definition

/// A quantum circuit
public protocol Circuit {
    /// Gates in the circuit
    var gates: [Gate] { get }

    /**
     Produces unitary matrix that represents entire list of `gates`.

     - Parameter qubitCount: Number of qubits in the circuit.

     - Returns: Unitary matrix that represents entire list of `gates`. Or `UnitaryError` error.
     */
    func unitary(withQubitCount qubitCount: Int) -> Result<Matrix, UnitaryError>

    /**
     Applies `gates` to `initialState` to produce a new statevector.

     - Parameter initialState: Used to initialized circuit to given state.

     - Returns: Another `CircuitStatevector` instance, result of applying `gates` to `initialState`. Or
     `StatevectorError` error.
     */
    func statevector(withInitialState initialState: CircuitStatevector) -> Result<CircuitStatevector, StatevectorError>
}
