//
//  GateError.swift
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

/// Errors throwed  while acting on a `Gate` in a `Circuit`
public enum GateError: Error {
    /// Throwed when a gate without `controls` is used in a circuit
    case gateControlsCanNotBeAnEmptyList
    /// Throwed when the matrix provided by a gate is not unitary
    case gateMatrixIsNotUnitary
    /// Throwed when the number of rows in a matrix used to build a quantum gate is not a power of 2. A matrix has to
    /// handle all possible combinations for a given number of qubits which is (number of qubits)^2
    case gateMatrixRowCountHasToBeAPowerOfTwo
    /// Throwed when an entry in `truthTable` uses more qubits than are availble in `controls`
    case gateTruthTableCanNotBeRepresentedWithGivenControlCount
    /// Throwed when an entry in `truthTable` is either an emptry string or it is not composed only of 0's and 1's
    case gateTruthTableEntriesHaveToBeNonEmptyStringsComposedOnlyOfZerosAndOnes
}
