//
//  AnySimulatorOracleMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/04/2021.
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

struct AnySimulatorOracleMatrix {

    // MARK: - Private properties

    private let matrix: SimulatorOracleMatrix

    // MARK: - Internal init methods

    init(matrix: SimulatorOracleMatrix) {
        self.matrix = matrix
    }
}

// MARK: - SimulatorOracleMatrix methods

extension AnySimulatorOracleMatrix: SimulatorOracleMatrix {
    var truthTable: TruthTable {
        return matrix.truthTable
    }

    var controlCount_: Int {
        return matrix.controlCount_
    }

    var controlledCountableMatrix_: SimulatorMatrixExtracting.SimulatorMatrixCountable {
        return matrix.controlledCountableMatrix_
    }
}

