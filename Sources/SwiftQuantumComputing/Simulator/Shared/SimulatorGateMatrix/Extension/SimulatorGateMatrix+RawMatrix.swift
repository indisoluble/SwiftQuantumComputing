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

    var rowCount: Int {
        switch self {
        case .singleQubitMatrix(let matrix):
            return matrix.rowCount
        case .otherMultiQubitMatrix(let matrix):
            return matrix.rowCount
        case .fullyControlledSingleQubitMatrix(let controlledMatrix, let controlCount):
            return Int.pow(2, controlCount) *  controlledMatrix.rowCount
        }
    }

    var rawMatrix: Matrix {
        switch self {
        case .singleQubitMatrix(let matrix):
            return matrix
        case .otherMultiQubitMatrix(let matrix):
            return matrix
        case .fullyControlledSingleQubitMatrix(let controlledMatrix, let controlCount):
            return try! Matrix.makeControlledMatrix(matrix: controlledMatrix,
                                                    controlCount: controlCount).get()
        }
    }
}
