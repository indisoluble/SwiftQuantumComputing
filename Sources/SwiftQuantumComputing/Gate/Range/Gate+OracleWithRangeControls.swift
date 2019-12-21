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
    public static func oracle(truthTable: [String], target: Int, controls: Range<Int>) -> Gate {
        return oracle(truthTable: truthTable, target: target, controls: Array(controls))
    }

    /// Produces an oracle gate
    public static func oracle(truthTable: [String],
                              target: Int,
                              controls: ClosedRange<Int>) -> Gate {
        return oracle(truthTable: truthTable, target: target, controls: Array(controls))
    }

    /// Produces an oracle gate reversing `reversedControls` before creating the gate
    public static func oracle(truthTable: [String],
                              target: Int,
                              reversedControls: Range<Int>) -> Gate {
        return oracle(truthTable: truthTable,
                      target: target,
                      controls: Array(reversedControls.reversed()))
    }

    /// Produces an oracle gate reversing `reversedControls` before creating the gate
    public static func oracle(truthTable: [String],
                              target: Int,
                              reversedControls: ClosedRange<Int>) -> Gate {
        return oracle(truthTable: truthTable,
                      target: target,
                      controls: Array(reversedControls.reversed()))
    }
}
