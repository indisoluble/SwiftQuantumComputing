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

    private let matrixFactory: SimulatorCircuitMatrixElementFactory

    // MARK: - Internal init methods

    init(matrixFactory: SimulatorCircuitMatrixElementFactory) {
        self.matrixFactory = matrixFactory
    }
}

// MARK: - StatevectorTransformation methods

extension CircuitMatrixElementStatevectorTransformation: StatevectorTransformation {
    func apply(gateMatrix: Matrix, toStatevector vector: Vector, atInputs inputs: [Int]) -> Vector {
        let circuitElement = matrixFactory.makeCircuitMatrixElement(qubitCount: Int.log2(vector.count),
                                                                    baseMatrix: gateMatrix,
                                                                    inputs: inputs)
        return try! Vector.makeVector(count: vector.count, value: { idx in
            return vector.enumerated().reduce(Complex.zero) { acc, val in
                return acc + val.element * circuitElement[idx, val.offset]
            }
        }).get()
    }
}
