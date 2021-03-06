//
//  Gate+Rotation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/11/2020.
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

// MARK: - Main body

extension Gate {

    // MARK: - Public types

    /// Paulis P = {X, Y, Z}
    public enum Axis {
        /// Pauli X
        case x
        /// Pauli Y
        case y
        /// Pauli Z
        case z
    }

    // MARK: - Public class methods

    /// Returns a quantum gate that defines a rotation of `radians` around `axis` of the quantum state in `target`
    public static func rotation(axis: Axis, radians: Double, target: Int) -> Gate {
        return Gate(gate: FixedRotationGate(axis: axis, radians: radians, target: target))
    }
}
