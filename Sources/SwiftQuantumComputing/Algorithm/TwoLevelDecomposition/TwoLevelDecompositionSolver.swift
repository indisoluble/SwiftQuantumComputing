//
//  TwoLevelDecompositionSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/10/2020.
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

// MARK: - Protocol definition

/// A quantum gate can be decomposed into a sequence of fully controlled two-level matrix gates and not gates.
/// The following implementation is based on:
/// [Decomposition of unitary matrices and quantum gates](https://arxiv.org/abs/1210.7366) &
/// [Decomposition of unitary matrix into quantum gates](https://github.com/fedimser/quantum_decomp/blob/master/res/Fedoriaka2019Decomposition.pdf)
public protocol TwoLevelDecompositionSolver {

    /**
     Decompose `gate` into a sequence of fully controlled two-level matrix gates and not gates.

     - Parameter gate: `Gate` instance to decompose.
     - Parameter qubitCount: Number of qubits in the circuit.

     - Returns: A sequence of `Gate` instances that replace the input `gate`. Or `QuantumOperatorError` error.
     */
    func decomposeGate(_ gate: Gate,
                       restrictedToCircuitQubitCount qubitCount: Int) -> Result<[Gate], QuantumOperatorError>
}
