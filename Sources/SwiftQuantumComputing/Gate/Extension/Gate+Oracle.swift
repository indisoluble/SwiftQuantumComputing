//
//  Gate+Oracle.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/09/2020.
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

    // MARK: - Public class methods

    /**
     Produces a `Gate.oracle(truthTable:controls:gate:)` with a `Gate.not(target:)` in target.

     - Parameter truthTable: Oracle truthtable.
     - Parameter controls: Control qubits.
     - Parameter target: Target of `Gate.not(target:)`.

     - Returns: A `Gate.oracle(truthTable:controls:gate:)` instance.
     */
    public static func oracle(truthTable: [String], controls: [Int], target: Int) -> Gate {
        return .oracle(truthTable: truthTable, controls: controls, gate: .not(target: target))
    }
}
