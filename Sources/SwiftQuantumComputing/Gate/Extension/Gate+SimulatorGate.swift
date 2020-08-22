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

// MARK: - Main body

extension Gate {

    // MARK: - Internal methods

    func extractInputs() -> [Int] {
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

// MARK: - SimulatorRawGate methods

extension Gate: SimulatorRawGate {
    var gate: Gate {
        return self
    }
}

// MARK: - SimulatorGate methods

extension Gate: SimulatorGate {
    func extractComponents(restrictedToCircuitQubitCount qubitCount: Int) -> Result<Components, GateError> {
        let inputs = extractInputs()
        guard areInputsUnique(inputs) else {
            return .failure(.gateInputsAreNotUnique)
        }

        var matrix: Matrix!
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

    func doesMatrixFitInCircuit(_ matrix: Matrix, qubitCount: Int) -> Bool {
        let matrixQubitCount = Int.log2(matrix.rowCount)

        return matrixQubitCount <= qubitCount
    }

    func areInputsInBound(_ inputs: [Int], qubitCount: Int) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }

    func extractMatrix() -> Result<Matrix, GateError> {
        var resultMatrix: Matrix!

        switch self {
        case .controlledMatrix(let matrix, _, _):
            guard matrix.rowCount.isPowerOfTwo else {
                return .failure(.gateMatrixRowCountHasToBeAPowerOfTwo)
            }
            // Validate matrix before expanding it so the operation requires less time
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                return .failure(.gateMatrixIsNotUnitary)
            }

            resultMatrix = try! Matrix.makeControlledMatrix(matrix: matrix, controlCount: 1).get()
        case .controlledNot:
            resultMatrix = Constants.matrixControlledNot
        case .hadamard:
            resultMatrix = Constants.matrixHadamard
        case .matrix(let matrix, _):
            guard matrix.rowCount.isPowerOfTwo else {
                return .failure(.gateMatrixRowCountHasToBeAPowerOfTwo)
            }
            // Validate matrix before expanding it so the operation requires less time
            guard matrix.isUnitary(accuracy: Constants.unitaryAccuracy) else {
                return .failure(.gateMatrixIsNotUnitary)
            }

            resultMatrix = matrix
        case .not:
            resultMatrix = Constants.matrixNot
        case .oracle(let truthTable, _, let controls):
            switch Matrix.makeOracle(truthTable: truthTable, controlCount: controls.count) {
            case .success(let matrix):
                resultMatrix = matrix
            case .failure(.controlsCanNotBeAnEmptyList):
                return .failure(.gateOracleControlsCanNotBeAnEmptyList)
            }
        case .phaseShift(let radians, _):
            resultMatrix = Matrix.makePhaseShift(radians: radians)
        }

        return .success(resultMatrix)
    }
}
