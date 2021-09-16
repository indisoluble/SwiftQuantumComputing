//
//  QuantumOperatorError.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 18/09/2021.
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

/// Errors throwed  while acting on a `QuantumOperator` in a `Circuit` or `NoiseCircuit`
public enum QuantumOperatorError: Error, Hashable {
    /// Throwed when the number of qubits (informed or inferred) to create a circuit is 0
    case circuitQubitCountHasToBeBiggerThanZero
    /// Throwed when the `Gate` used to create the `QuantumOperator` is not valid
    case gateError(error: GateError)
    /// Throwed when an operator does not use as many qubits as its matrix is able to handle
    case operatorInputCountDoesNotMatchOperatorMatrixQubitCount
    /// Throwed when an operator references one or more qubits that do not exist
    case operatorInputsAreNotInBound
    /// Throwed when an operator references same qubit/s multiple times
    case operatorInputsAreNotUnique
    /// Throwed when an operator requires more qubits than the circuit actually has
    case operatorHandlesMoreQubitsThanCircuitActuallyHas
}
