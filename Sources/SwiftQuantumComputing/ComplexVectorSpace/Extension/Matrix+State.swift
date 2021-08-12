//
//  Matrix+State.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/08/2021.
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

extension Matrix {

    // MARK: - Internal class methods

    enum MakeStateError: Error {
        case qubitCountHasToBeBiggerThanZero
        case valueHasToBeContainedInQubits
    }

    static func makeState(value: Int, qubitCount: Int) -> Result<Matrix, MakeStateError> {
        guard qubitCount > 0 else {
            return .failure(.qubitCountHasToBeBiggerThanZero)
        }

        let count = Int.pow(2, qubitCount)
        guard value >= 0 && value < count else {
            return .failure(.valueHasToBeContainedInQubits)
        }

        let matrix = try! makeMatrix(rowCount: count, columnCount: count, value: { row, col in
            return row == col && row == value ? .one : .zero
        }).get()

        return .success(matrix)
    }
}
