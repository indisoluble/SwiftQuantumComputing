//
//  CSMFullMatrixDensityMatrixTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/07/2021.
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

struct CSMFullMatrixDensityMatrixTransformation {

    // MARK: - Private properties

    private let expansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case expansionConcurrencyHasToBiggerThanZero
    }

    init(expansionConcurrency: Int) throws {
        guard expansionConcurrency > 0 else {
            throw InitError.expansionConcurrencyHasToBiggerThanZero
        }

        self.expansionConcurrency = expansionConcurrency
    }
}

// MARK: - DensityMatrixTransformation methods

extension CSMFullMatrixDensityMatrixTransformation: DensityMatrixTransformation {}

// MARK: - CircuitSimulatorMatrixDensityMatrixTransformation methods

extension CSMFullMatrixDensityMatrixTransformation: CircuitSimulatorMatrixDensityMatrixTransformation {
    func apply(matrix: CircuitSimulatorMatrix, toDensityMatrix densityMatrix: Matrix) -> Matrix {
        let lhs = try! matrix.expandedRawMatrix(maxConcurrency: expansionConcurrency).get()

        return try! ((lhs * densityMatrix).get() * Matrix.Transformation.adjointed(lhs)).get()
    }
}

