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

    private let maxConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case maxConcurrencyHasToBiggerThanZero
    }

    init(maxConcurrency: Int) throws {
        guard maxConcurrency > 0 else {
            throw InitError.maxConcurrencyHasToBiggerThanZero
        }

        self.maxConcurrency = maxConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension DirectStatevectorTransformation: StatevectorTransformation {
    func apply(components: SimulatorGate.Components, toStatevector vector: Vector) -> Vector {
        var nextVector: Vector!

        switch components.simulatorGateMatrix {
        case .fullyControlledSingleQubitMatrix(let controlledMatrix, _):
            let lastIndex = components.inputs.count - 1

            let target = components.inputs[lastIndex]

            let controls = Array(components.inputs[0..<lastIndex])
            let filter = Int.mask(activatingBitsAt: controls)

            nextVector = apply(oneQubitMatrix: controlledMatrix,
                               toStatevector: vector,
                               atInput: target,
                               selectingStatesWith: filter)
        case .singleQubitMatrix(let matrix):
            let idxTransformation = DirectStatevectorSingleQubitGateIndexTransformation(gateInput: components.inputs[0])

            nextVector = apply(multiQubitMatrix: matrix,
                               toStatevector: vector,
                               withIndexTransformation: idxTransformation)
        case .otherMultiQubitMatrix(let matrix):
            let idxTransformation = DirectStatevectorMultiQubitGateIndexTransformation(gateInputs: components.inputs)

            nextVector = apply(multiQubitMatrix: matrix,
                               toStatevector: vector,
                               withIndexTransformation: idxTransformation)
        }

        return nextVector
    }
}

// MARK: - Private body

private extension DirectStatevectorTransformation {

    // MARK: - Private methods

    func apply(oneQubitMatrix: SimulatorMatrix,
               toStatevector vector: Vector,
               atInput input: Int,
               selectingStatesWith filter: Int? = nil) -> Vector {
        let mask = Int.mask(activatingBitAt: input)
        let invMask = ~mask

        return try! Vector.makeVector(count: vector.count, maxConcurrency: maxConcurrency, value: { index in
            var value: Complex<Double>!

            if let filter = filter, index & filter != filter {
                value = vector[index]
            } else if index & mask == 0 {
                let otherIndex = index | mask

                value = oneQubitMatrix[0, 0] * vector[index] + oneQubitMatrix[0, 1] * vector[otherIndex]
            } else {
                let otherIndex = index & invMask

                value = oneQubitMatrix[1, 0] * vector[otherIndex] + oneQubitMatrix[1, 1] * vector[index]
            }

            return value
        }).get()
    }

    func apply(multiQubitMatrix matrix: SimulatorMatrix,
               toStatevector vector: Vector,
               withIndexTransformation idxTransformation: DirectStatevectorIndexTransformation) -> Vector {
        return try! Vector.makeVector(count: vector.count, maxConcurrency: maxConcurrency, value: { vectorIndex in
            let (matrixRow, multiplications) = idxTransformation.indexesToCalculateStatevectorValueAtPosition(vectorIndex)

            return multiplications.reduce(.zero) { (acc, indexes) in
                return acc + matrix[matrixRow, indexes.gateMatrixColumn] * vector[indexes.inputStatevectorPosition]
            }
        }).get()
    }
}
