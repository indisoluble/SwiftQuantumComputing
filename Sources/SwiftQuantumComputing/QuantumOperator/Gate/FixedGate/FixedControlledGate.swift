//
//  FixedControlledGate.swift
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

struct FixedControlledGate {

    // MARK: - Internal types

    typealias InternalGate = RawInputsExtracting &
        SimulatorControlledMatrixExtracting &
        SimplifiedGateConvertible

    // MARK: - Internal properties

    let gate: InternalGate
    let controls: [Int]

    // MARK: - Private properties

    private let gateHash: AnyHashable

    // MARK: - Internal init methods

    init<T: InternalGate & Hashable>(gate: T, controls: [Int]) {
        self.init(gate: gate, gateHash: AnyHashable(gate), controls: controls)
    }

    init(gate: InternalGate, gateHash: AnyHashable, controls: [Int]) {
        self.gate = gate
        self.gateHash = gateHash
        self.controls = controls
    }
}

// MARK: - Hashable methods

extension FixedControlledGate: Hashable {
    static func == (lhs: FixedControlledGate, rhs: FixedControlledGate) -> Bool {
        return lhs.controls == rhs.controls && lhs.gateHash == rhs.gateHash
    }

    func hash(into hasher: inout Hasher) {
        controls.hash(into: &hasher)
        gateHash.hash(into: &hasher)
    }
}

// MARK: - SimplifiedGateConvertible methods

extension FixedControlledGate: SimplifiedGateConvertible {
    var simplified: SimplifiedGate {
        return .controlled(gate: gate.simplified, controls: controls)
    }
}
