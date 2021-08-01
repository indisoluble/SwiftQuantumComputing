//
//  CSMRowByRowDensityMatrixTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/08/2021.
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

struct CSMRowByRowDensityMatrixTransformation {

    // MARK: - Private properties

    private let calculationConcurrency: Int
    private let expansionConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case calculationConcurrencyHasToBiggerThanZero
        case expansionConcurrencyHasToBiggerThanZero
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

// MARK: - DensityMatrixTransformation methods

extension CSMRowByRowDensityMatrixTransformation: DensityMatrixTransformation {}

// MARK: - CircuitSimulatorMatrixDensityMatrixTransformation methods

extension CSMRowByRowDensityMatrixTransformation: CircuitSimulatorMatrixDensityMatrixTransformation {
    func apply(matrix: CircuitSimulatorMatrix, toDensityMatrix densityMatrix: Matrix) -> Matrix {
        let count = matrix.count
        let dmcc = calculationConcurrency
        let rec = expansionConcurrency

        let rowValues: (Int) -> Vector = { rowIndex in
            let matrixRow = try! matrix.row(rowIndex, maxConcurrency: rec).get()

            return try! Vector.makeVector(count: count, value: { idx in
                let column = try! densityMatrix.makeSlice(startColumn: idx, columnCount: 1).get()

                return try! (matrixRow * column).get().first
            }).get()
        }

        let customValue: (Int, Int, Vector) -> Complex<Double> = { rowIndex, columnIndex, row in
            let conjugatedColumn = try! matrix.row(columnIndex,
                                                   maxConcurrency: rec,
                                                   transform: { $0.conjugate }).get()

            return try! (row * conjugatedColumn).get()
        }

        return try! Matrix.makeMatrix(rowCount: count,
                                      columnCount: count,
                                      maxConcurrency: dmcc,
                                      rowValues: rowValues,
                                      customValue: customValue).get()
    }
}
