//
//  StatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/05/2020.
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

// MARK: - Protocol definition

protocol StatevectorTransformation {
    func apply(gate: Gate, toStatevector vector: Vector) -> Result<Vector, GateError>
}

// MARK: - StatevectorTransformation default implementations

extension StatevectorTransformation where Self: CircuitSimulatorMatrixStatevectorTransformation {
    func apply(gate: Gate, toStatevector vector: Vector) -> Result<Vector, GateError> {
        let extractor = SimulatorMatrixExtractor(extractor: gate)
        let qubitCount = Int.log2(vector.count)

        switch extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let baseMatrix, let inputs)):
            let circuitMatrix = CircuitSimulatorMatrix(qubitCount: qubitCount,
                                                       baseMatrix: baseMatrix,
                                                       inputs: inputs)

            return .success(apply(matrix: circuitMatrix, toStatevector: vector))
        case .failure(let error):
            return .failure(error)
        }
    }
}
