//
//  Matrix+Oracle.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/01/2019.
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

import ComplexModule
import Foundation

// MARK: - Main body

extension Matrix {

    // MARK: - Internal class methods

    enum MakeOracleError: Error {
        case controlCountHasToBeBiggerThanZero
        case matrixIsNotSquare
        case matrixRowCountHasToBeAPowerOfTwo
    }

    static func makeOracle(truthTable: [String],
                           controlCount: Int,
                           controlledMatrix: Matrix) -> Result<Matrix, MakeOracleError> {
        guard controlledMatrix.isSquare else {
            return .failure(.matrixIsNotSquare)
        }

        guard controlledMatrix.rowCount.isPowerOfTwo else {
            return .failure(.matrixRowCountHasToBeAPowerOfTwo)
        }

        guard controlCount > 0 else {
            return .failure(.controlCountHasToBeBiggerThanZero)
        }

        let activatedSections = Matrix.truthTableAsInts(truthTable)

        let controlledMatrixSize = controlledMatrix.columnCount
        let count = Int.pow(2, controlCount) * controlledMatrixSize

        let matrix = try! Matrix.makeMatrix(rowCount: count, columnCount: count, value: { row, col in
            let section = row / controlledMatrixSize

            let isDiagonalSection = section == (col / controlledMatrixSize)
            if !isDiagonalSection {
                return .zero
            }

            if !activatedSections.contains(section) {
                return (row == col ? .one : .zero)
            }

            let sectionFirstPosition = section * controlledMatrixSize
            return controlledMatrix[row - sectionFirstPosition, col - sectionFirstPosition]
        }).get()

        return .success(matrix)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private class methods

    static func truthTableAsInts(_ truthTable: [String]) -> Set<Int> {
        var result: Set<Int> = []

        for truth in truthTable {
            guard let truthAsInt = Int(truth, radix: 2) else {
                continue
            }

            result.update(with: truthAsInt)
        }

        return result
    }
}
