//
//  CircuitMatrixElementStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/05/2020.
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

struct CircuitMatrixElementStatevectorTransformation {

    // MARK: - Private properties

    private let matrixFactory: SimulatorCircuitMatrixFactory
    private let maxConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case maxConcurrencyHasToBiggerThanZero
    }

    init(matrixFactory: SimulatorCircuitMatrixFactory, maxConcurrency: Int) throws {
        guard maxConcurrency > 0 else {
            throw InitError.maxConcurrencyHasToBiggerThanZero
        }

        self.matrixFactory = matrixFactory
        self.maxConcurrency = maxConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension CircuitMatrixElementStatevectorTransformation: StatevectorTransformation {}

// MARK: - StatevectorComponentsTransformation methods

extension CircuitMatrixElementStatevectorTransformation: StatevectorComponentsTransformation {
    func apply(components: SimulatorGate.Components, toStatevector vector: Vector) -> Vector {
        let qubitCount = Int.log2(vector.count)
        let baseMatrix = components.simulatorGateMatrix.matrix
        let inputs = components.inputs
        let circuitElement = matrixFactory.makeCircuitMatrix(qubitCount: qubitCount,
                                                             baseMatrix: baseMatrix,
                                                             inputs: inputs)
        let count = vector.count
        return try! Vector.makeVector(count: count, maxConcurrency: maxConcurrency, value: { idx in
            return vector.enumerated().reduce(.zero) { acc, val in
                return acc + val.element * circuitElement[idx, val.offset]
            }
        }).get()
    }
}
