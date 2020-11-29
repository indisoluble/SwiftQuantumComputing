//
//  SimplifiedGateConvertible.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/11/2020.
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

// MARK: - Public types

/// Simplified representation of a quantum gate. Use to easily identify the type of a quantum gate and its components
public indirect enum SimplifiedGate {
    /// Not gate with 1 input: `target`
    case not(target: Int)
    /// Hadamard gate with 1 input: `target`
    case hadamard(target: Int)
    /// Quantum gate that shifts phase of the quantum state in `target` by `radians`
    case phaseShift(radians: Double, target: Int)
    /// Quantum gate that defines a rotation of `radians` around `axis` of the quantum state in `target`
    case rotation(axis: Gate.Axis, radians: Double, target: Int)
    /// Quantum gate built with a `matrix` and any number of `inputs`
    case matrix(matrix: Matrix, inputs: [Int])
    /// Oracle gate composed of a `truthtable` that specifies which `controls` activate a `gate`
    case oracle(truthTable: [String], controls: [Int], gate: SimplifiedGate)
    /// Quantum `gate` controlled with `controls`
    case controlled(gate: SimplifiedGate, controls: [Int])
}

// MARK: - Hashable methods

extension SimplifiedGate: Hashable {}

// MARK: - Protocol definition

/// A type with a simplified representation of a quantum gate
public protocol SimplifiedGateConvertible {
    /// Simplified representation of the gate
    var simplified: SimplifiedGate { get }
}
