//
//  Gate.swift
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

public struct Gate {

    // MARK: - Internal properties

    let gate: SimulatorComponents & SimplifiedGateConvertible

    // MARK: - Private properties

    private let anyHash: AnyHashable

    // MARK: - Internal init methods

    init<T: SimulatorComponents & SimplifiedGateConvertible & Hashable>(gate: T) {
        self.gate = gate

        anyHash = AnyHashable(gate)
    }
}

// MARK: - Hashable methods

extension Gate: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.anyHash == rhs.anyHash
    }

    public func hash(into hasher: inout Hasher) {
        anyHash.hash(into: &hasher)
    }
}

// MARK: - SimplifiedGateConvertible methods

extension Gate: SimplifiedGateConvertible {
    public var simplified: SimplifiedGate {
        return gate.simplified
    }
}
