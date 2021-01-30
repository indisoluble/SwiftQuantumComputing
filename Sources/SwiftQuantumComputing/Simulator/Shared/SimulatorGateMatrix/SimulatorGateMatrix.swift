//
//  SimulatorGateMatrix.swift
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

struct SimulatorGateMatrix {

    // MARK: - Internal properties

    let controlCount: Int
    let controlledMatrix: SimulatorMatrix

    // MARK: - Internal init methods

    init(matrix: SimulatorMatrix) {
        self.init(controlCount: 0, controlledMatrix: matrix)
    }

    // MARK: - Private internal methods

    private init(controlCount: Int, controlledMatrix: SimulatorMatrix) {
        self.controlCount = controlCount
        self.controlledMatrix = controlledMatrix
    }

    // MARK: - Internal methods

    func addingControlCount(_ controlCount: Int) -> SimulatorGateMatrix {
        return SimulatorGateMatrix(controlCount: self.controlCount + controlCount,
                                   controlledMatrix: controlledMatrix)
    }
}
