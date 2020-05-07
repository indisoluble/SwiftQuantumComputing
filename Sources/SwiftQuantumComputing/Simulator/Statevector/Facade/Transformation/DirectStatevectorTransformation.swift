//
//  DirectStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/04/2020.
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

struct DirectStatevectorTransformation {

    // MARK: - Private properties

    private let transformation: StatevectorTransformation

    // MARK: - Internal init methods

    init(transformation: StatevectorTransformation) {
        self.transformation = transformation
    }
}

// MARK: - StatevectorTransformation methods

extension DirectStatevectorTransformation: StatevectorTransformation {
    func apply(gateMatrix: Matrix, toStatevector vector: Vector, atInputs inputs: [Int]) -> Vector {
        var nextVector: Vector!

        if inputs.count == 1 {
            nextVector = apply(oneQubitMatrix: gateMatrix,
                               toStatevector: vector,
                               atInput: inputs.first!)
        } else {
            nextVector = transformation.apply(gateMatrix: gateMatrix,
                                              toStatevector: vector,
                                              atInputs: inputs)
        }

        return nextVector
    }
}

// MARK: - Private body

private extension DirectStatevectorTransformation {

    // MARK: - Private methods

    func apply(oneQubitMatrix matrix: Matrix,
               toStatevector vector: Vector,
               atInput input: Int) -> Vector {
        let mask = 1 << input
        let invMask = ~mask

        return try! Vector.makeVector(count: vector.count) { index in
            var value: Complex!

            if index & mask == 0 {
                let otherIndex = index | mask

                value = matrix[0, 0] * vector[index] + matrix[0, 1] * vector[otherIndex]
            } else {
                let otherIndex = index & invMask

                value = matrix[1, 0] * vector[otherIndex] + matrix[1, 1] * vector[index]
            }

            return value
        }
    }
}
