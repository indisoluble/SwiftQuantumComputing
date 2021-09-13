//
//  Gate+OracleWithRangeControls.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/12/2019.
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

    // MARK: - Public class methods

    /// Produces an oracle gate
    public static func oracle(truthTable: [String], controls: Range<Int>, gate: Gate) -> Gate {
        return oracle(truthTable: truthTable, controls: Array(controls), gate: gate)
    }

    /// Produces an oracle gate
    public static func oracle(truthTable: [String],
                              controls: ClosedRange<Int>,
                              gate: Gate) -> Gate {
        return oracle(truthTable: truthTable, controls: Array(controls), gate: gate)
    }

    /// Produces an oracle gate
    public static func oracle(truthTable: [String], controls: Range<Int>, target: Int) -> Gate {
        return oracle(truthTable: truthTable, controls: Array(controls), target: target)
    }

    /// Produces an oracle gate
    public static func oracle(truthTable: [String],
                              controls: ClosedRange<Int>,
                              target: Int) -> Gate {
        return oracle(truthTable: truthTable, controls: Array(controls), target: target)
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: [Int],
                              targets: Range<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: controls, targets: Array(targets))
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: Range<Int>,
                              targets: Range<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: Array(controls), targets: Array(targets))
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: ClosedRange<Int>,
                              targets: Range<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: Array(controls), targets: Array(targets))
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: [Int],
                              targets: ClosedRange<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: controls, targets: Array(targets))
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: Range<Int>,
                              targets: ClosedRange<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: Array(controls), targets: Array(targets))
    }

    /// Produces a list of oracle gates
    public static func oracle(truthTable: [ExtendedTruth],
                              controls: ClosedRange<Int>,
                              targets: ClosedRange<Int>) -> [Gate] {
        return oracle(truthTable: truthTable, controls: Array(controls), targets: Array(targets))
    }
}
