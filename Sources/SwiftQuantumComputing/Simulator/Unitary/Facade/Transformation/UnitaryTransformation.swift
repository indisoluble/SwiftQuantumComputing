//
//  UnitaryTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/06/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

protocol UnitaryTransformation {
    func apply(gate: Gate, toUnitary matrix: Matrix) -> Result<Matrix, QuantumOperatorError>
}

// MARK: - UnitaryTransformation default implementations

extension UnitaryTransformation where Self: CircuitSimulatorMatrixUnitaryTransformation {
    func apply(gate: Gate, toUnitary matrix: Matrix) -> Result<Matrix, QuantumOperatorError> {
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)
        let qubitCount = Int.log2(matrix.rowCount)

        switch extractor.extractCircuitMatrix(restrictedToCircuitQubitCount: qubitCount) {
        case .success(let circuitMatrix):
            return .success(apply(circuitMatrix: circuitMatrix, toUnitary: matrix))
        case .failure(let error):
            return .failure(error)
        }
    }
}
