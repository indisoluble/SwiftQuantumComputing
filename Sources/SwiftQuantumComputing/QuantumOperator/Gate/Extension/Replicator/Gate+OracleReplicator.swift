//
//  Gate+OracleReplicator.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/12/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

    /// Represents the `activation` (or bits) produded by a function after inputting a given `truth`
    public typealias ExtendedTruth = (truth: String, activation: String)

    // MARK: - Public class methods

    /**
     Produces a list of `Gate.oracle(truthTable:controls:gate:)`. A `Gate.not(target:)` is produced for each target
     in `targets` if at least one `activation` in `truthTable` has the bit correspoding to the target activated.

     - Parameter truthTable: List of `Gate.ExtendedTruth` instances.
     - Parameter controls: Control qubits for each oracle in the list.
     - Parameter targets: Targets for each oracle in the list.

     - Returns: List of `Gate.oracle(truthTable:controls:gate:)`.
     */
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: [Int],
                              targets: [Int]) -> [Gate] {
        return targets.reversed().enumerated().compactMap { (i, tg) -> Gate? in
            let tt = truthTable.compactMap { $0.activation.isBitActivated(at: i) ? $0.truth : nil }

            return (tt.isEmpty ? nil : Gate.oracle(truthTable: tt, controls: controls, target: tg))
        }
    }
}
