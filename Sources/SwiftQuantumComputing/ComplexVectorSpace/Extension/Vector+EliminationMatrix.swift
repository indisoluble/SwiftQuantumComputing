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

        let b = self[1]
        if b.isZero {
            return .success(try! Matrix.makeIdentity(count: count).get())
        }

        let a = self[0]
        if a.isZero {
            return .success(Matrix.makeNot())
        }

        let theta = atan((b / a).length)
        let lambda = -a.phase
        let mu = Double.pi + b.phase

        let cosTheta = Complex(cos(theta))
        let sinTheta = Complex(sin(theta))

        let matrix = try! Matrix(
            [[cosTheta * Complex.euler(lambda), sinTheta * Complex.euler(mu)],
             [-sinTheta * Complex.euler(-mu), cosTheta * Complex.euler(-lambda)]]
        )

        return .success(matrix)
    }
}
