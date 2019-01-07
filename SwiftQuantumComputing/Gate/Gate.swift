//
//  Gate.swift
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

// MARK: - Types

public enum Gate {
    case controlledNot(target: Int, control: Int)
    case hadamard(target: Int)
    case matrix(matrix: Matrix, inputs: [Int])
    case not(target: Int)
    case phaseShift(radians: Double, target: Int)
}

// MARK: - Equatable methods

extension Gate: Equatable {
    public static func ==(lhs: Gate, rhs: Gate) -> Bool {
        switch (lhs, rhs) {
        case (let .controlledNot(t1, c1), let .controlledNot(t2, c2)):
            return ((t1 == t2) && (c1 == c2))
        case (let .hadamard(t1), let .hadamard(t2)):
            return (t1 == t2)
        case (let .matrix(m1, i1), let .matrix(m2, i2)):
            return ((m1 == m2) && (i1 == i2))
        case (let .not(t1), let .not(t2)):
            return (t1 == t2)
        case (let .phaseShift(r1, t1), let .phaseShift(r2, t2)):
            return ((r1 == r2) && (t1 == t2))
        default:
            return false
        }
    }
}
