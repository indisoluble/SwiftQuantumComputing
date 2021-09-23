//
//  SimulatorMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 30/10/2020.
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

import ComplexModule
import Foundation

// MARK: - Protocol definition

enum ExpandedRawMatrixError: Error {
    case passMaxConcurrencyBiggerThanZero
}

protocol SimulatorMatrix: MatrixCountable {
    subscript(row: Int, column: Int) -> Complex<Double> { get }

    func expandedRawMatrix(maxConcurrency: Int) -> Result<Matrix, ExpandedRawMatrixError>
}

// MARK: - SimulatorMatrix default implementations

extension SimulatorMatrix {
    func expandedRawMatrix(maxConcurrency: Int) -> Result<Matrix, ExpandedRawMatrixError> {
        switch Matrix.makeMatrix(rowCount: count,
                                 columnCount: count,
                                 maxConcurrency: maxConcurrency,
                                 value: { self[$0, $1] }) {
        case .success(let matrix):
            return .success(matrix)
        case .failure(.passMaxConcurrencyBiggerThanZero):
            return .failure(.passMaxConcurrencyBiggerThanZero)
        case .failure(.passRowCountBiggerThanZero), .failure(.passColumnCountBiggerThanZero):
            fatalError("Unexpected error.")
        }
    }
}
