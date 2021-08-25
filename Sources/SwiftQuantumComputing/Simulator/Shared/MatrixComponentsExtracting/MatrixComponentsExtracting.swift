//
//  MatrixComponentsExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/02/2021.
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

protocol MatrixComponentsExtracting {
    associatedtype ExtractedMatrix

    func extractMatrix() -> Result<ExtractedMatrix, GateError>
}

// MARK: - MatrixComponentsExtracting default implementations

extension MatrixComponentsExtracting where Self: RawInputsExtracting, ExtractedMatrix: MatrixCountable {
    typealias Components = (matrix: ExtractedMatrix, inputs: [Int])

    func extractComponents(restrictedToCircuitQubitCount qubitCount: Int) -> Result<Components, GateError> {
        let inputs = extractRawInputs()
        guard areInputsUnique(inputs) else {
            return .failure(.gateInputsAreNotUnique)
        }

        let matrix: ExtractedMatrix
        switch extractMatrix() {
        case .success(let extractedMatrix):
            matrix = extractedMatrix
        case .failure(let error):
            return .failure(error)
        }

        guard doesInputCountMatchMatrixQubitCount(inputs, matrix: matrix) else {
            return .failure(.gateInputCountDoesNotMatchGateMatrixQubitCount)
        }

        guard qubitCount > 0 else {
            return .failure(.circuitQubitCountHasToBeBiggerThanZero)
        }

        guard doesMatrixFitInCircuit(matrix, qubitCount: qubitCount) else {
            return .failure(.gateMatrixHandlesMoreQubitsThatCircuitActuallyHas)
        }

        guard areInputsInBound(inputs, qubitCount: qubitCount) else {
            return .failure(.gateInputsAreNotInBound)
        }

        return .success((matrix, inputs))
    }
}

extension MatrixComponentsExtracting where Self: RawInputsExtracting, ExtractedMatrix: SimulatorMatrix {
    func extractCircuitMatrix(restrictedToCircuitQubitCount qubitCount: Int) -> Result<CircuitSimulatorMatrix, GateError> {
        switch extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let baseMatrix, let inputs)):
            return .success(CircuitSimulatorMatrix(qubitCount: qubitCount,
                                                   baseMatrix: baseMatrix,
                                                   inputs: inputs))
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Private body

private extension MatrixComponentsExtracting {

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func doesInputCountMatchMatrixQubitCount(_ inputs: [Int], matrix: MatrixCountable) -> Bool {
        let matrixQubitCount = Int.log2(matrix.count)

        return (inputs.count == matrixQubitCount)
    }

    func doesMatrixFitInCircuit(_ matrix: MatrixCountable, qubitCount: Int) -> Bool {
        let matrixQubitCount = Int.log2(matrix.count)

        return matrixQubitCount <= qubitCount
    }

    func areInputsInBound(_ inputs: [Int], qubitCount: Int) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }
}
