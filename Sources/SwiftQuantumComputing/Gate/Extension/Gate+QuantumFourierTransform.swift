//
//  Gate+QuantumFourierTransform.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/03/2020.
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

extension Gate {

    // MARK: - Public class methods

    /// Errors throwed by `Gate.makeQuantumFourierTransform(inputs:inverse:)`
    public enum MakeQuantumFourierTransformError: Error {
        /// Throwed if `inputs` is an empty list
        case inputsCanNotBeAnEmptyList
    }

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that performs a Quantum Fourier Transform over `inputs`
    /// if `inverse` is `false` or an inverse Quantum Fourier Transform otherwise
    public static func makeQuantumFourierTransform(inputs: [Int],
                                                   inverse: Bool = false) throws -> Gate {
        let count = inputs.count
        guard count > 0 else {
            throw MakeQuantumFourierTransformError.inputsCanNotBeAnEmptyList
        }

        let matrixCount = Int.pow(2, count)
        let matrix = try! Matrix.makeQuantumFourierTransform(count: matrixCount).get()

        return .matrix(matrix: inverse ? matrix.conjugateTransposed() : matrix, inputs: inputs)
    }
}
