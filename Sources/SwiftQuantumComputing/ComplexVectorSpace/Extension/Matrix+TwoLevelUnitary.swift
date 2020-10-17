//
//  Matrix+TwoLevelUnitary.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/10/2020.
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

    enum MakeTwoLevelUnitaryError: Error {
        case passCountBiggerThanTwo
        case submatrixIsNot2x2
        case submatrixIsNotUnitary
        case firstIndexIsNotSmallerThanSecondIndex
        case indexesOutOfRange
    }

    static func makeTwoLevelUnitary(count: Int,
                                    submatrix: Matrix,
                                    indexes: (Int, Int)) -> Result<Matrix, MakeTwoLevelUnitaryError> {
        guard count > 2 else {
            return .failure(.passCountBiggerThanTwo)
        }

        guard submatrix.isSquare, submatrix.rowCount == 2 else {
            return .failure(.submatrixIsNot2x2)
        }

        guard submatrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance) else {
            return .failure(.submatrixIsNotUnitary)
        }

        guard indexes.0 < indexes.1 else {
            // To do this, swap rows & columns and then swap indexes
            return .failure(.firstIndexIsNotSmallerThanSecondIndex)
        }

        guard indexes.0 >= 0, indexes.1 < count else {
            return .failure(.indexesOutOfRange)
        }

        let matrix = try! Matrix.makeMatrix(rowCount: count, columnCount: count, value: { row, col in
            if row == indexes.0 && col == indexes.0 {
                return submatrix[0, 0]
            } else if row == indexes.0 && col == indexes.1 {
                return submatrix[0, 1]
            } else if row == indexes.1 && col == indexes.0 {
                return submatrix[1, 0]
            } else if row == indexes.1 && col == indexes.1 {
                return submatrix[1, 1]
            } else {
                return row == col ? .one : .zero
            }
        }).get()

        return .success(matrix)
    }
}
