//
//  FixedOracleGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/11/2020.
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

struct FixedOracleGate {

    // MARK: - Internal properties

    let truthTable: [String]
    let controls: [Int]
    let gate: SimulatorComponents & SimplifiedGateConvertible

    // MARK: - AnyHashableContainer properties

    let anyHash: AnyHashable

    // MARK: - Internal init methods

    init<T: SimulatorComponents & SimplifiedGateConvertible & Hashable>(truthTable: [String],
                                                                        controls: [Int],
                                                                        gate: T) {
        self.truthTable = truthTable
        self.controls = controls
        self.gate = gate

        anyHash = AnyHashable(gate)
    }
}

// MARK: - Hashable methods

extension FixedOracleGate: Hashable {}

// MARK: - AnyHashableContainer methods

extension FixedOracleGate: AnyHashableContainer {}

// MARK: - SimplifiedGateConvertible methods

extension FixedOracleGate: SimplifiedGateConvertible {
    var simplified: SimplifiedGate {
        return .oracle(truthTable: truthTable, controls: controls, gate: gate.simplified)
    }
}
