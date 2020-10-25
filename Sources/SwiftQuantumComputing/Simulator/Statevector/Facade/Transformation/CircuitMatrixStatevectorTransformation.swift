//
//  CircuitMatrixStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

struct CircuitMatrixStatevectorTransformation {

    // MARK: - Private properties

    private let matrixFactory: SimulatorCircuitMatrixFactory

    // MARK: - Internal init methods

    init(matrixFactory: SimulatorCircuitMatrixFactory) {
        self.matrixFactory = matrixFactory
    }
}

// MARK: - StatevectorTransformation methods

extension CircuitMatrixStatevectorTransformation: StatevectorTransformation {
    func apply(components: SimulatorGate.Components, toStatevector vector: Vector) -> Vector {
        let qubitCount = Int.log2(vector.count)
        let baseMatrix = components.simulatorGateMatrix.rawMatrix
        let inputs = components.inputs
        let circuitMatrix = matrixFactory.makeCircuitMatrix(qubitCount: qubitCount,
                                                            baseMatrix: baseMatrix,
                                                            inputs: inputs)
        return try! (circuitMatrix.rawMatrix * vector).get()
    }
}
