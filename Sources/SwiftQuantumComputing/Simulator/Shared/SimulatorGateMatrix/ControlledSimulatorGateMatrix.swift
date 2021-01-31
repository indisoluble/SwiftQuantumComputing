//
//  ControlledSimulatorGateMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/01/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

struct ControlledSimulatorGateMatrix {

    // MARK: - SimulatorGateMatrix properties

    let controlCount: Int
    let controlledMatrix: SimulatorMatrix
}

// MARK: - SimulatorGateMatrix methods

extension ControlledSimulatorGateMatrix: SimulatorGateMatrix {
    var matrix: SimulatorMatrix {
        return OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: controlCount,
                                     controlledMatrix: controlledMatrix)
    }

    var matrixCount: Int {
        return Int.pow(2, controlCount) *  controlledMatrix.count
    }
}
