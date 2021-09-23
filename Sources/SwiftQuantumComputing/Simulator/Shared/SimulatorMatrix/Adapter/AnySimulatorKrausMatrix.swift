//
//  AnySimulatorKrausMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 28/08/2021.
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

struct AnySimulatorKrausMatrix {

    // MARK: - MatrixCountable properties

    let count: Int

    // MARK: - SimulatorKrausMatrix properties

    let matrices: [SimulatorMatrix]

    // MARK: - Internal init methods

    init(matrix: SimulatorMatrix) {
        self.init(count: matrix.count, matrices: [matrix])
    }

    init(matrix: SimulatorKrausMatrix) {
        self.init(count: matrix.count, matrices: matrix.matrices)
    }

    init(matrices: [SimulatorMatrix]) {
        self.init(count: matrices.first?.count ?? 0, matrices: matrices)
    }

    // MARK: - Private init methods

    private init(count: Int, matrices: [SimulatorMatrix]) {
        self.count = count
        self.matrices = matrices
    }
}

// MARK: - MatrixCountable methods

extension AnySimulatorKrausMatrix: MatrixCountable {}

// MARK: - SimulatorKrausMatrix methods

extension AnySimulatorKrausMatrix: SimulatorKrausMatrix {}
