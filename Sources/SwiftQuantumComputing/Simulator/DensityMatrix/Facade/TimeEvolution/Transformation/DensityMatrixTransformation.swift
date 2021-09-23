//
//  DensityMatrixTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/07/2021.
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

protocol DensityMatrixTransformation {
    func apply(quantumOperator: QuantumOperator,
               toDensityMatrix matrix: Matrix) -> Result<Matrix, QuantumOperatorError>
}

// MARK: - DensityMatrixTransformation default implementations

extension DensityMatrixTransformation where Self: CircuitSimulatorMatrixDensityMatrixTransformation {
    func apply(quantumOperator: QuantumOperator,
               toDensityMatrix matrix: Matrix) -> Result<Matrix, QuantumOperatorError> {
        let extractor = SimulatorKrausMatrixComponentsExtractor(extractor: quantumOperator)
        let qubitCount = Int.log2(matrix.rowCount)

        let krausInputs: [Int]
        let krausMatrix: SimulatorKrausMatrix
        switch extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let gateMatrix, let gateInputs)):
            krausInputs = gateInputs
            krausMatrix = gateMatrix
        case .failure(let error):
            return .failure(error)
        }

        let firstOperand = krausMatrix.matrices[0]
        let firstCircuitMatrix = CircuitSimulatorMatrix(qubitCount: qubitCount,
                                                        baseMatrix: firstOperand,
                                                        inputs: krausInputs)
        let firstResult = apply(matrix: firstCircuitMatrix, toDensityMatrix: matrix)

        let finalResult = krausMatrix.matrices[1...].reduce(firstResult) { result, nextOperand in
            let circuitMatrix = CircuitSimulatorMatrix(qubitCount: qubitCount,
                                                       baseMatrix: nextOperand,
                                                       inputs: krausInputs)

            return try! (result + apply(matrix: circuitMatrix, toDensityMatrix: matrix)).get()
        }

        return .success(finalResult)
    }
}
