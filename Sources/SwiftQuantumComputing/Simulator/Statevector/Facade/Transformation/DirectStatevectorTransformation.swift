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

import ComplexModule
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

        if isSingleQubitMatrix(gateMatrix) {
            nextVector = apply(oneQubitMatrix: gateMatrix,
                               toStatevector: vector,
                               atInput: inputs[0])
        } else if isFullyControlledSingleQubitMatrix(gateMatrix) {
            let lastIndex = inputs.count - 1

            nextVector = apply(controlledMatrix: gateMatrix,
                               toStatevector: vector,
                               atTarget: inputs[lastIndex],
                               withControls: Array(inputs[0..<lastIndex]))
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

    func isSingleQubitMatrix(_ matrix: Matrix) -> Bool {
        return matrix.rowCount == 2
    }

    func isFullyControlledSingleQubitMatrix(_ matrix: Matrix) -> Bool {
        return (0..<matrix.rowCount - 2).lazy.allSatisfy { matrix[$0, $0] == .one }
    }

    func apply(oneQubitMatrix matrix: Matrix,
               toStatevector vector: Vector,
               atInput input: Int) -> Vector {
        return apply(matrix: matrix, toStatevector: vector, atInput: input)
    }

    func apply(controlledMatrix matrix: Matrix,
               toStatevector vector: Vector,
               atTarget target: Int,
               withControls controls: [Int]) -> Vector {
        let firstIndex = matrix.rowCount - 2
        let submatrix = try! Matrix.makeMatrix(rowCount: 2, columnCount: 2, value: { row, col in
            return matrix[firstIndex + row, firstIndex + col]
        }).get()

        let filter = Int.mask(activatingBitsAt: controls)

        return apply(matrix: submatrix,
                     toStatevector: vector,
                     atInput: target,
                     selectingStatesWith:filter)
    }

    func apply(matrix: Matrix,
               toStatevector vector: Vector,
               atInput input: Int,
               selectingStatesWith filter: Int? = nil) -> Vector {
        let mask = 1 << input
        let invMask = ~mask

        return try! Vector.makeVector(count: vector.count, value: { index in
            var value: Complex<Double>!

            if let filter = filter, index & filter != filter {
                value = vector[index]
            } else if index & mask == 0 {
                let otherIndex = index | mask

                value = matrix[0, 0] * vector[index] + matrix[0, 1] * vector[otherIndex]
            } else {
                let otherIndex = index & invMask

                value = matrix[1, 0] * vector[otherIndex] + matrix[1, 1] * vector[index]
            }

            return value
        }).get()
    }
}
