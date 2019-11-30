//
//  FixedGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/12/2018.
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

// MARK: - Public types

/// A quantum gate. with fixed inputs
public enum FixedGate {
    /// Controlled not gate with 2 inputs: `target` & `control`
    case controlledNot(target: Int, control: Int)
    /// Hadamard gate with 1 input: `target`
    case hadamard(target: Int)
    /// Generic quantum gate built with a `matrix` (it is expected to be unitary) and any number of `inputs`
    /// (as many inputs as `matrix` is able to handle)
    case matrix(matrix: Matrix, inputs: [Int])
    /// Not gate with 1 input: `target`
    case not(target: Int)
    /// Oracle gate composed of a `truthtable` that specifies which `controls` activate a controlled not
    /// gate applied to `target`
    case oracle(truthTable: [String], target: Int, controls: [Int])
    /// Quantum gate that shifts phase of the quantum state in `target` by `radians`
    case phaseShift(radians: Double, target: Int)
}

// MARK: - Equatable methods

extension FixedGate: Equatable {
    public static func ==(lhs: FixedGate, rhs: FixedGate) -> Bool {
        switch (lhs, rhs) {
        case (let .controlledNot(t1, c1), let .controlledNot(t2, c2)):
            return ((t1 == t2) && (c1 == c2))
        case (let .hadamard(t1), let .hadamard(t2)):
            return (t1 == t2)
        case (let .matrix(m1, i1), let .matrix(m2, i2)):
            return ((m1 == m2) && (i1 == i2))
        case (let .not(t1), let .not(t2)):
            return (t1 == t2)
        case (let .oracle(tt1, t1, c1), let .oracle(tt2, t2, c2)):
            return ((tt1 == tt2) && (t1 == t2) && (c1 == c2))
        case (let .phaseShift(r1, t1), let .phaseShift(r2, t2)):
            return ((r1 == r2) && (t1 == t2))
        default:
            return false
        }
    }
}
