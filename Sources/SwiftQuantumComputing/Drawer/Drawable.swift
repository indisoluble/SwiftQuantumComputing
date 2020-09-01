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
public enum DrawCircuitError: Error, Equatable {
    /// Throwed when `qubitCount` is 0, i.e. a circuit requires at least 1 qubit
    case qubitCountHasToBeBiggerThanZero
    /// Throwed when `gate` informs no inputs/controls
    case gateWithEmptyInputList(gate: Gate)
    /// Throwed when `gate` informs the same input qubit twice (or more)
    case gateWithRepeatedInputs(gate: Gate)
    /// Throwed when `gate` informs the same control qubit twice (or more)
    /// in the same controlled/oracle gate or in different controlled/oracle gates
    case gateWithRepeatedControls(gate: Gate)
    /// Throwed when `gate` tries to use one or more input qubits also as control qubits
    case gateWithOneOrMoreInputsAlsoControls(gate: Gate)
    /// Throwed when one or more of the inputs/targets/controls in `gate` reference a qubit that does not exist
    case gateWithOneOrMoreInputsOrControlsOutOfRange(gate: Gate)
}

// MARK: - Protocol definition

/// Print/draw a quantum circuit
public protocol Drawable {

    /**
     Prints a `circuit` with the given `qubitCount` in a view.

     - Parameter circuit: Circuit to be printed in a view..
     - Parameter qubitCount: Number of qubits in the `circuit`.

     - Returns: A view with a representation of the `circuit` inside. Or `DrawCircuitError` error.
     */
    func drawCircuit(_ circuit: [Gate], qubitCount: Int) -> Result<SQCView, DrawCircuitError>
}
