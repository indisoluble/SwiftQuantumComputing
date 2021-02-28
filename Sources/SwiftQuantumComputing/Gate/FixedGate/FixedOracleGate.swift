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
    let gate: Gate.InternalGate

    // MARK: - Private properties

    private let gateHash: AnyHashable

    // MARK: - Internal init methods

    init<T: Gate.InternalGate & Hashable>(truthTable: [String], controls: [Int], gate: T) {
        self.init(truthTable: truthTable,
                  controls: controls,
                  gate: gate,
                  gateHash: AnyHashable(gate))
    }

    init(truthTable: [String], controls: [Int], gate: Gate.InternalGate, gateHash: AnyHashable) {
        self.truthTable = truthTable
        self.controls = controls
        self.gate = gate
        self.gateHash = gateHash
    }
}

// MARK: - Hashable methods

extension FixedOracleGate: Hashable {
    static func == (lhs: FixedOracleGate, rhs: FixedOracleGate) -> Bool {
        return lhs.truthTable == rhs.truthTable &&
            lhs.controls == rhs.controls &&
            lhs.gateHash == rhs.gateHash
    }

    func hash(into hasher: inout Hasher) {
        truthTable.hash(into: &hasher)
        controls.hash(into: &hasher)
        gateHash.hash(into: &hasher)
    }
}

// MARK: - SimplifiedGateConvertible methods

extension FixedOracleGate: SimplifiedGateConvertible {
    var simplified: SimplifiedGate {
        return .oracle(truthTable: truthTable, controls: controls, gate: gate.simplified)
    }
}
