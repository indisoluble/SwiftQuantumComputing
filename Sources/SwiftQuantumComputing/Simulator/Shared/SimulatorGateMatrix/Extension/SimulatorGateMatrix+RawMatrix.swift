//
//  SimulatorGateMatrix+RawMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/10/2020.
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

extension SimulatorGateMatrix {

    // MARK: - Internal properties

    var count: Int {
        switch self {
        case .singleQubitMatrix(let matrix):
            return matrix.count
        case .otherMultiQubitMatrix(let matrix):
            return matrix.count
        case .fullyControlledSingleQubitMatrix(let controlledMatrix, let controlCount):
            return Int.pow(2, controlCount) *  controlledMatrix.count
        }
    }

    var rawMatrix: Matrix {
        switch self {
        case .singleQubitMatrix(let matrix):
            return matrix.rawMatrix
        case .otherMultiQubitMatrix(let matrix):
            return matrix.rawMatrix
        case .fullyControlledSingleQubitMatrix(let controlledMatrix, let controlCount):
            let truth = String(repeating: "1", count: controlCount)
            let matrix = OracleSimulatorMatrix(truthTable: [truth],
                                               controlCount: controlCount,
                                               controlledMatrix: controlledMatrix)

            return matrix.rawMatrix
        }
    }
}
