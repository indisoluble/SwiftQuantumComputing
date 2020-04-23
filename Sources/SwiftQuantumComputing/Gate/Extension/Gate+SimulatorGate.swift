//
//  Gate+SimulatorGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

// MARK: - SimulatorGate methods

extension Gate: SimulatorGate {
    var gate: Gate {
        return self
    }

    func extract() throws -> (matrix: Matrix, inputs: [Int]) {
        let inputs = extractRawInputs()
        guard areInputsUnique(inputs) else {
            throw GateError.gateInputsAreNotUnique
        }

        let matrix = try extractMatrix()
        guard doesInputCountMatchMatrixQubitCount(inputs, matrix: matrix) else {
            throw GateError.gateInputCountDoesNotMatchGateMatrixQubitCount
        }

        return (matrix, inputs)
    }

    func extractRawInputs() -> [Int] {
        var resultInputs: [Int]!

        switch self {
        case .controlledMatrix(_, let inputs, let control):
            resultInputs = [control] + inputs
        case .controlledNot(let target, let control):
            resultInputs = [control, target]
        case .hadamard(let target):
            resultInputs = [target]
        case .matrix(_, let inputs):
            resultInputs = inputs
        case .not(let target):
            resultInputs = [target]
        case .oracle(_, let target, let controls):
            resultInputs = controls + [target]
        case .phaseShift(_, let target):
            resultInputs = [target]
        }

        return resultInputs
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Constants

    enum Constants {
        static let matrixControlledNot = Matrix.makeControlledNot()
        static let matrixHadamard = Matrix.makeHadamard()
        static let matrixNot = Matrix.makeNot()
        static let unitaryAccuracy = 0.001
    }

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func doesInputCountMatchMatrixQubitCount(_ inputs: [Int], matrix: Matrix) -> Bool {
        let matrixQubitCount = Int.log2(matrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }

    func extractMatrix() throws -> Matrix {
        var resultMatrix: Matrix!

        switch self {
        case .controlledMatrix(let matrix, _, _):
            guard matrix.rowCount.isPowerOfTwo else {
                throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
            }
            // Validate matrix before expanding it so the operation requires less time
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                throw GateError.gateMatrixIsNotUnitary
            }

            resultMatrix = Matrix.makeControlledMatrix(matrix: matrix)
        case .controlledNot:
            resultMatrix = Constants.matrixControlledNot
        case .hadamard:
            resultMatrix = Constants.matrixHadamard
        case .matrix(let matrix, _):
            guard matrix.rowCount.isPowerOfTwo else {
                throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
            }
            // Validate matrix before expanding it so the operation requires less time
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                throw GateError.gateMatrixIsNotUnitary
            }

            resultMatrix = matrix
        case .not:
            resultMatrix = Constants.matrixNot
        case .oracle(let truthTable, _, let controls):
            resultMatrix = try Matrix.makeOracle(truthTable: truthTable,
                                                 controlCount: controls.count)
        case .phaseShift(let radians, _):
            resultMatrix = Matrix.makePhaseShift(radians: radians)
        }

        return resultMatrix
    }
}
