//
//  Matrix+ControlledMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/03/2020.
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

extension Matrix {

    // MARK: - Internal class methods

    enum MakeControlledMatrixError: Error {
        case controlCountHasToBeBiggerThanZero
        case matrixIsNotSquare
        case matrixRowCountHasToBeAPowerOfTwo
    }

    static func makeControlledMatrix(matrix: Matrix, controlCount: Int) -> Result<Matrix, MakeControlledMatrixError> {
        guard matrix.isSquare else {
            return .failure(.matrixIsNotSquare)
        }

        guard matrix.rowCount.isPowerOfTwo else {
            return .failure(.matrixRowCountHasToBeAPowerOfTwo)
        }

        guard controlCount > 0 else {
            return .failure(.controlCountHasToBeBiggerThanZero)
        }

        let count = Int.pow(2, controlCount) *  matrix.rowCount
        let fourthQuadrantIndex = count - matrix.rowCount
        let result = try! Matrix.makeMatrix(rowCount: count, columnCount: count, value: { row, col in
            let quad = Quadrant(row: row, column: col, fourthQuadrantIndex: fourthQuadrantIndex)
            switch quad {
            case .first(let quadRow, let quadCol):
                return (quadRow == quadCol ? .one : .zero)
            case .second:
                return .zero
            case .third:
                return .zero
            case .fourth(let quadRow, let quadCol):
                return matrix[quadRow, quadCol]
            }
        }).get()

        return .success(result)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private types

    enum Quadrant {
        case first(quadrantRow: Int, quadrantColumn: Int)
        case second(quadrantRow: Int, quadrantColumn: Int)
        case third(quadrantRow: Int, quadrantColumn: Int)
        case fourth(quadrantRow: Int, quadrantColumn: Int)

        init(row: Int, column: Int, fourthQuadrantIndex: Int) {
            if (row < fourthQuadrantIndex) {
                if (column < fourthQuadrantIndex) {
                    self = .first(quadrantRow: row, quadrantColumn: column)
                } else {
                    self = .second(quadrantRow: row, quadrantColumn: column - fourthQuadrantIndex)
                }
            } else {
                if (column < fourthQuadrantIndex) {
                    self = .third(quadrantRow: row - fourthQuadrantIndex, quadrantColumn: column)
                } else {
                    self = .fourth(quadrantRow: row - fourthQuadrantIndex,
                                   quadrantColumn: column - fourthQuadrantIndex)
                }
            }
        }
    }
}
