//
//  CSMRowByRowUnitaryTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/06/2021.
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

import ComplexModule
import Foundation

// MARK: - Main body

struct CSMRowByRowUnitaryTransformation {

    // MARK: - Private properties

    private let calculationConcurrency: Int
    private let expansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case expansionConcurrencyHasToBiggerThanZero
        case calculationConcurrencyHasToBiggerThanZero
    }

    init(calculationConcurrency: Int, expansionConcurrency: Int) throws {
        guard calculationConcurrency > 0 else {
            throw InitError.calculationConcurrencyHasToBiggerThanZero
        }

        guard expansionConcurrency > 0 else {
            throw InitError.expansionConcurrencyHasToBiggerThanZero
        }

        self.calculationConcurrency = calculationConcurrency
        self.expansionConcurrency = expansionConcurrency
    }
}

// MARK: - UnitaryTransformation methods

extension CSMRowByRowUnitaryTransformation: UnitaryTransformation {}

// MARK: - CircuitSimulatorMatrixUnitaryTransformation methods

extension CSMRowByRowUnitaryTransformation: CircuitSimulatorMatrixUnitaryTransformation {
    func apply(circuitMatrix: CircuitSimulatorMatrix, toUnitary matrix: Matrix) -> Matrix {
        let count = circuitMatrix.count
        let ucc = calculationConcurrency
        let rec = expansionConcurrency

        return try! Matrix.makeMatrix(rowCount: count,
                                      columnCount: count,
                                      maxConcurrency: ucc,
                                      rowValues: { rowIndex in
                                        return try! circuitMatrix.row(rowIndex,
                                                                      maxConcurrency: rec).get()
                                      },
                                      customValue: { rowIndex, columnIndex, row in
                                        let column = try! matrix.makeSlice(startColumn: columnIndex,
                                                                           columnCount: 1).get()

                                        return try! (row * column).get().first
                                      }).get()
    }
}
