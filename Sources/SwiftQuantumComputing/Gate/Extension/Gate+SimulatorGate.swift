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
        case .not(let target):
            resultInputs = [target]
        case .hadamard(let target):
            resultInputs = [target]
        case .phaseShift(_, let target):
            resultInputs = [target]
        case .rotation(_, _, let target):
            resultInputs = [target]
        case .matrix(_, let inputs):
            resultInputs = inputs
        case .oracle(_, let controls, let gate):
            resultInputs = controls + gate.extractInputs()
        case .controlled(let gate, let controls):
            resultInputs = controls + gate.extractInputs()
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

        var simulatorGateMatrix: SimulatorGateMatrix!
        switch extractMatrix() {
        case .success(let extractedMatrix):
            simulatorGateMatrix = extractedMatrix
        case .failure(let error):
            return .failure(error)
        }

        guard doesInputCountMatchMatrixQubitCount(inputs, matrix: simulatorGateMatrix) else {
            return .failure(.gateInputCountDoesNotMatchGateMatrixQubitCount)
        }

        guard qubitCount > 0 else {
            return .failure(.circuitQubitCountHasToBeBiggerThanZero)
        }

        guard doesMatrixFitInCircuit(simulatorGateMatrix, qubitCount: qubitCount) else {
            return .failure(.gateMatrixHandlesMoreQubitsThatCircuitActuallyHas)
        }

        guard areInputsInBound(inputs, qubitCount: qubitCount) else {
            return .failure(.gateInputsAreNotInBound)
        }

        return .success((simulatorGateMatrix, inputs))
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Constants

    enum Constants {
        static let matrixHadamard = Matrix.makeHadamard()
        static let matrixNot = Matrix.makeNot()
    }

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func doesInputCountMatchMatrixQubitCount(_ inputs: [Int], matrix: SimulatorGateMatrix) -> Bool {
        let matrixQubitCount = Int.log2(matrix.count)

        return (inputs.count == matrixQubitCount)
    }

    func doesMatrixFitInCircuit(_ matrix: SimulatorGateMatrix, qubitCount: Int) -> Bool {
        let matrixQubitCount = Int.log2(matrix.count)

        return matrixQubitCount <= qubitCount
    }

    func areInputsInBound(_ inputs: [Int], qubitCount: Int) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }

    func extractMatrix() -> Result<SimulatorGateMatrix, GateError> {
        var result: Result<SimulatorGateMatrix, GateError>!

        switch self {
        case .not:
            result = .success(.singleQubitMatrix(matrix: Constants.matrixNot))
        case .hadamard:
            result = .success(.singleQubitMatrix(matrix: Constants.matrixHadamard))
        case .phaseShift(let radians, _):
            result = .success(.singleQubitMatrix(matrix: Matrix.makePhaseShift(radians: radians)))
        case .rotation(let axis, let radians, _):
            result = .success(.singleQubitMatrix(matrix: Matrix.makeRotation(axis: axis,
                                                                             radians: radians)))
        case .matrix(let matrix, _):
            result = makeMatrixResult(matrix: matrix)
        case .oracle(let truthTable, let controls, let gate):
            result = makeOracleResult(truthTable: truthTable, controls: controls, gate: gate)
        case .controlled(let gate, let controls):
            result = makeControlledResult(gate: gate, controls: controls)
        }

        return result
    }

    func makeMatrixResult(matrix: Matrix) -> Result<SimulatorGateMatrix, GateError> {
        guard matrix.rowCount.isPowerOfTwo else {
            return .failure(.gateMatrixRowCountHasToBeAPowerOfTwo)
        }
        // Validate matrix before expanding it so the operation requires less time
        guard matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance) else {
            return .failure(.gateMatrixIsNotUnitary)
        }

        return .success(matrix.rowCount == 2 ?
                            .singleQubitMatrix(matrix: matrix) :
                            .otherMultiQubitMatrix(matrix: matrix))
    }

    func makeOracleResult(truthTable: [String],
                          controls: [Int],
                          gate: Gate) -> Result<SimulatorGateMatrix, GateError> {
        guard !controls.isEmpty else {
            return .failure(.gateControlsCanNotBeAnEmptyList)
        }

        switch gate.extractMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(let simulatorGateMatrix):
            let controlledMatrix: SimulatorMatrix!
            switch simulatorGateMatrix {
            case .singleQubitMatrix(let matrix):
                controlledMatrix = matrix
            case .otherMultiQubitMatrix(let matrix):
                controlledMatrix = matrix
            case .fullyControlledSingleQubitMatrix(let ctrlMatrix, let ctrlCount):
                let truth = String(repeating: "1", count: ctrlCount)
                controlledMatrix = OracleSimulatorMatrix(truthTable: [truth],
                                                         controlCount: ctrlCount,
                                                         controlledMatrix: ctrlMatrix)
            }

            let result = OracleSimulatorMatrix(truthTable: truthTable,
                                               controlCount: controls.count,
                                               controlledMatrix: controlledMatrix)
            return .success(.otherMultiQubitMatrix(matrix: result))
        }
    }

    func makeControlledResult(gate: Gate,
                              controls: [Int]) -> Result<SimulatorGateMatrix, GateError> {
        guard !controls.isEmpty else {
            return .failure(.gateControlsCanNotBeAnEmptyList)
        }

        switch gate.extractMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(.singleQubitMatrix(let matrix)):
            return .success(.fullyControlledSingleQubitMatrix(controlledMatrix: matrix,
                                                              controlCount: controls.count))
        case .success(.fullyControlledSingleQubitMatrix(let ctrlMatrix, let ctrlCount)):
            return .success(.fullyControlledSingleQubitMatrix(controlledMatrix: ctrlMatrix,
                                                              controlCount: ctrlCount + controls.count))
        case .success(.otherMultiQubitMatrix(let matrix)):
            let truth = String(repeating: "1", count: controls.count)
            let result = OracleSimulatorMatrix(truthTable: [truth],
                                               controlCount: controls.count,
                                               controlledMatrix: matrix)
            return .success(.otherMultiQubitMatrix(matrix: result))
        }
    }
}
