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

    private let indexingFactory: DirectStatevectorIndexingFactory
    private let maxConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case maxConcurrencyHasToBiggerThanZero
    }

    init(indexingFactory: DirectStatevectorIndexingFactory,
         maxConcurrency: Int) throws {
        guard maxConcurrency > 0 else {
            throw InitError.maxConcurrencyHasToBiggerThanZero
        }

        self.indexingFactory = indexingFactory
        self.maxConcurrency = maxConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension DirectStatevectorTransformation: StatevectorTransformation {
    func apply(gate: Gate, toStatevector vector: Vector) -> Result<Vector, GateError> {
        let extractor = SimulatorControlledMatrixExtractor(extractor: gate)
        let qubitCount = Int.log2(vector.count)

        let gateMatrix: SimulatorControlledMatrix
        let gateInputs: [Int]
        switch extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let matrix, let inputs)):
            gateMatrix = matrix
            gateInputs = inputs
        case .failure(let error):
            return .failure(error)
        }

        let matrix = gateMatrix.controlledCountableMatrix
        let controlCount = gateMatrix.controlCount

        let controls = Array(gateInputs[0..<controlCount])
        let inputs = Array(gateInputs[controlCount..<gateInputs.count])

        var filter: Int? = nil
        if controlCount > 0 {
            filter = Int.mask(activatingBitsAt: controls)
        }

        let indexer = (inputs.count == 1 ?
                        indexingFactory.makeSingleQubitGateIndexer(gateInput: inputs[0]) :
                        indexingFactory.makeMultiQubitGateIndexer(gateInputs: inputs))
        let nextVector = apply(matrix: matrix,
                               toStatevector: vector,
                               transformingIndexesWith: indexer,
                               selectingStatesWith: filter)

        return .success(nextVector)
    }
}

// MARK: - Private body

private extension DirectStatevectorTransformation {

    // MARK: - Private methods

    func apply(matrix: SimulatorMatrix,
               toStatevector vector: Vector,
               transformingIndexesWith indexer: DirectStatevectorIndexing,
               selectingStatesWith filter: Int? = nil) -> Vector {
        return try! Vector.makeVector(count: vector.count, maxConcurrency: maxConcurrency, value: { vectorIndex in
            if let filter = filter, vectorIndex & filter != filter {
                return vector[vectorIndex]
            }

            let (matrixRow, multiplications) = indexer.indexesToCalculateStatevectorValueAtPosition(vectorIndex)
            return multiplications.reduce(.zero) { (acc, indexes) in
                return acc + matrix[matrixRow, indexes.gateMatrixColumn] * vector[indexes.inputStatevectorPosition]
            }
        }).get()
    }
}
