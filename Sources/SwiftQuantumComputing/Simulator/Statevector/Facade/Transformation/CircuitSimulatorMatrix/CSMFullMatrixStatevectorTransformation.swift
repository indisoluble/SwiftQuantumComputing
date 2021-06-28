//
//  CSMFullMatrixStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/10/2019.
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

struct CSMFullMatrixStatevectorTransformation {

    // MARK: - Private properties

    private let matrixExpansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case matrixExpansionConcurrencyHasToBiggerThanZero
    }

    init(matrixExpansionConcurrency: Int) throws {
        guard matrixExpansionConcurrency > 0 else {
            throw InitError.matrixExpansionConcurrencyHasToBiggerThanZero
        }

        self.matrixExpansionConcurrency = matrixExpansionConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension CSMFullMatrixStatevectorTransformation: StatevectorTransformation {}

// MARK: - CircuitSimulatorMatrixStatevectorTransformation methods

extension CSMFullMatrixStatevectorTransformation: CircuitSimulatorMatrixStatevectorTransformation {
    func apply(matrix: CircuitSimulatorMatrix, toStatevector vector: Vector) -> Vector {
        let lhs = try! matrix.expandedRawMatrix(maxConcurrency: matrixExpansionConcurrency).get()

        return try! (lhs * vector).get()
    }
}
