//
//  Matrix+QuantumFourierTransform.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/03/2020.
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

    enum MakeQuantumFourierTransformError: Error {
        case passCountBiggerThanZero
    }

    static func makeQuantumFourierTransform(count: Int) -> Result<Matrix, MakeQuantumFourierTransformError> {
        guard count > 0 else {
            return .failure(.passCountBiggerThanZero)
        }

        let n = Double(count)
        let normalization = Complex(1 / sqrt(n))
        let matrix = try! Matrix.makeMatrix(rowCount: count, columnCount: count) { row, column in
            let power = row * column

            var value = Complex.one
            if power > 0 {
                let radians = ((2 * Double(power)) / n) * Double.pi
                value = Complex(real: cos(radians), imag: sin(radians))
            }

            return normalization * value
        }

        return .success(matrix)
    }
}
