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

/// Errors throwed  while acting on or using a `Gate` in a `Circuit`
public enum GateError: Error {
    /// Throwed when the number of qubits (informed or inferred) to create a circuit is 0
    case circuitQubitCountHasToBeBiggerThanZero
    /// Throwed when a gate does not use as many qubits as its matrix is able to handle
    case gateInputCountDoesNotMatchGateMatrixQubitCount
    /// Throwed when a gate references one or more qubits that do not exist
    case gateInputsAreNotInBound
    /// Throwed when a gate references same qubit/s multiple times
    case gateInputsAreNotUnique
    /// Throwed when the matrix provided by a gate can not be extended to produce an unitary that applies to entire circuit
    case gateMatrixCanNotBeExtendedIntoACircuitUnitary
    /// Throwed when a gate requires more qubits that the circuit actually has
    case gateMatrixHandlesMoreQubitsThatCircuitActuallyHas
    /// Throwed when the matrix provided by a gate is not unitary
    case gateMatrixIsNotUnitary
    /// Throwed when the number of rows in a matrix used to build a quantum gate is not a power of 2. A matrix has to
    /// handle all possible combinations for a given number of qubits which is (number of qubits)^2
    case gateMatrixRowCountHasToBeAPowerOfTwo
    /// Throwed when a `Gate.oracle(truthTable:target:controls:)` without `controls` is used in a circuit
    case gateOracleControlsCanNotBeAnEmptyList
    /// Throwed when the resulting matrix after applying a gate is no longer unitary
    case resultingMatrixIsNotUnitaryAfterApplyingGateToUnitary
}

/// Errors throwed by `Circuit.statevector(withInitialStatevector:)`
public enum StatevectorWithInitialStatevectorError: Error, Equatable {
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: GateError)
    /// Throwed when `initialStatevector` is not valid or the resulting state vector lost too much precision
    /// after applying `gates`
    case initialStatevectorAdditionOfSquareModulusIsNotEqualToOne
    /// Throwed when the length of `initialStatevector` is not a power of 2. An `initialStatevector` represents
    /// all possible qubit combinations, tnis is (qubitCount)^2
    case initialStatevectorCountHasToBeAPowerOfTwo
    /// Throwed when the resulting state vector lost too much precision after applying `gates`
    case resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne
}

/// Errors throwed by `Circuit.unitary(withQubitCount:)`
public enum UnitaryError: Error, Equatable {
    /// Throwed when the circuit has no gate from which to produce an unitary matrix
    case circuitCanNotBeAnEmptyList
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: GateError)
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

     - Throws: `UnitaryError`.

     - Returns: Unitary matrix that represents entire list of `gates`.
     */
    func unitary(withQubitCount qubitCount: Int) throws -> Matrix

    /**
     Applies `gates` to `initialStatevector` to produce a new statevector.

     - Parameter initialStatevector: Used to initialized circuit to given state.

     - Throws: `StatevectorWithInitialStatevectorError`.

     - Returns: Another statevector, result of applying `gates` to `initialStatevector`.
     */
    func statevector(withInitialStatevector initialStatevector: Vector) throws -> Vector
}
