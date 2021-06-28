//
//  CSMRowByRowStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/05/2020.
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

struct CSMRowByRowStatevectorTransformation {

    // MARK: - Private properties

    private let statevectorCalculationConcurrency: Int
    private let rowExpansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case statevectorCalculationConcurrencyHasToBiggerThanZero
        case rowExpansionConcurrencyHasToBiggerThanZero
    }

    init(statevectorCalculationConcurrency: Int, rowExpansionConcurrency: Int) throws {
        guard statevectorCalculationConcurrency > 0 else {
            throw InitError.statevectorCalculationConcurrencyHasToBiggerThanZero
        }

        guard rowExpansionConcurrency > 0 else {
            throw InitError.rowExpansionConcurrencyHasToBiggerThanZero
        }

        self.statevectorCalculationConcurrency = statevectorCalculationConcurrency
        self.rowExpansionConcurrency = rowExpansionConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension CSMRowByRowStatevectorTransformation: StatevectorTransformation {}

// MARK: - CircuitSimulatorMatrixStatevectorTransformation methods

extension CSMRowByRowStatevectorTransformation: CircuitSimulatorMatrixStatevectorTransformation {
    func apply(matrix: CircuitSimulatorMatrix, toStatevector vector: Vector) -> Vector {
        let stcc = statevectorCalculationConcurrency

        return try! Vector.makeVector(count: vector.count, maxConcurrency: stcc, value: { idx in
            let lhs = try! matrix.row(idx, maxConcurrency: rowExpansionConcurrency).get()

            return try! (lhs * vector).get()
        }).get()
    }
}
