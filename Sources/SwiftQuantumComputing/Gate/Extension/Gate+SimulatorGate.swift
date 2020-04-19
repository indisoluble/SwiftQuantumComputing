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
        var resultMatrix: Matrix!
        var resultInputs: [Int]!

        switch self {
        case .controlledMatrix(let matrix, let inputs, let control):
            guard matrix.rowCount.isPowerOfTwo else {
                throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
            }
            // Validate matrix before expanding it so there is work to do
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                throw GateError.gateMatrixIsNotUnitary
            }

            resultMatrix = Matrix.makeControlledMatrix(matrix: matrix)
            resultInputs = [control] + inputs
        case .controlledNot(let target, let control):
            resultMatrix = Constants.matrixControlledNot
            resultInputs = [control, target]
        case .hadamard(let target):
            resultMatrix = Constants.matrixHadamard
            resultInputs = [target]
        case .matrix(let matrix, let inputs):
            guard matrix.rowCount.isPowerOfTwo else {
                throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
            }
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                throw GateError.gateMatrixIsNotUnitary
            }

            resultMatrix = matrix
            resultInputs = inputs
        case .not(let target):
            resultMatrix = Constants.matrixNot
            resultInputs = [target]
        case .oracle(let truthTable, let target, let controls):
            resultMatrix = try Matrix.makeOracle(truthTable: truthTable,
                                                 controlCount: controls.count)
            resultInputs = controls + [target]
        case .phaseShift(let radians, let target):
            resultMatrix = Matrix.makePhaseShift(radians: radians)
            resultInputs = [target]
        }

        if !doesInputCountMatchBaseMatrixQubitCount(resultInputs, baseMatrix: resultMatrix) {
            throw GateError.gateInputCountDoesNotMatchGateMatrixQubitCount
        }

        if !areInputsUnique(resultInputs) {
            throw GateError.gateInputsAreNotUnique
        }

        return (resultMatrix, resultInputs)
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

    func doesInputCountMatchBaseMatrixQubitCount(_ inputs: [Int], baseMatrix: Matrix) -> Bool {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }
}
