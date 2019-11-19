//
//  Drawable.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/12/2018.
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

/// Errors throwed by `Drawable.drawCircuit(_:qubitCount:)`
public enum DrawCircuitError: Error {
    /// Throwed when `qubitCount` is 0, i.e. a circuit requires at least 1 qubit
    case qubitCountHasToBeBiggerThanZero
    /// Throwed when one or more of the inputs/targets/controls in `gate` reference a qubit that does not exist
    case gateWithOneOrMoreInputsOutOfRange(gate: FixedGate)
    /// Throwed when `gate` informs no inputs/controls
    case gateWithEmptyInputList(gate: FixedGate)
    /// Throwed when `gate` tries to use a target qubit also as a control qubit
    case gateTargetIsAlsoAControl(gate: FixedGate)
}

// MARK: - Protocol definition

/// Print/draw a quantum circuit
public protocol Drawable {

    /**
     Prints a `circuit` with the given `qubitCount` in a view.

     - Parameter circuit: Circuit to be printed in a view..
     - Parameter qubitCount: Number of qubits in the `circuit`.

     - Throws: `DrawCircuitError`.

     - Returns: A view with a representation of the `circuit` inside.
     */
    func drawCircuit(_ circuit: [FixedGate], qubitCount: Int) throws -> SQCView
}
