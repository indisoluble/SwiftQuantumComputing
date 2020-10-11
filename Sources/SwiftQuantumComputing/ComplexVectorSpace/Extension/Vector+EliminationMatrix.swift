//
//  Vector+EliminationMatrix.swift
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

import ComplexModule
import Foundation

// MARK: - Main body

extension Vector {

    // MARK: - Internal methods

    enum EliminationMatrixError: Error {
        case vectorCountIsNotTwo
    }

    func eliminationMatrix() -> Result<Matrix, EliminationMatrixError> {
        guard count == 2 else {
            return .failure(.vectorCountIsNotTwo)
        }

        let valueToDelete = self[1]
        if valueToDelete.isApproximatelyEqual(to: .zero,
                                              absoluteTolerance: SharedConstants.tolerance) {
            return .success(try! Matrix.makeIdentity(count: count).get())
        }

        let value = self[0]
        if value.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
            return .success(.makeNot())
        }

        let denom = Complex(sqrt(.pow(value.length, 2) + .pow(valueToDelete.length, 2)))
        let matrix = try! Matrix([
            [value.conjugate / denom, -valueToDelete / denom],
            [valueToDelete.conjugate / denom, value / denom]
        ])

        return .success(matrix)
    }
}
