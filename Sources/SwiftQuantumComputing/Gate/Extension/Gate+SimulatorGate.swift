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

        var matrix: Matrix!
        var matrixType: SimulatorGateMatrixType!
        switch extractMatrix() {
        case .success((let extractedMatrix, let extractedType)):
            matrix = extractedMatrix
            matrixType = extractedType
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

        return .success((matrix, matrixType, inputs))
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private types

    typealias ExtractMatrixResult = (matrix: Matrix, matrixType: SimulatorGateMatrixType)

    // MARK: - Constants

    enum Constants {
        static let matrixHadamard = Matrix.makeHadamard()
        static let matrixNot = Matrix.makeNot()
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

    func extractMatrix() -> Result<ExtractMatrixResult, GateError> {
        var result: Result<ExtractMatrixResult, GateError>!

        switch self {
        case .not:
            result = .success((Constants.matrixNot, .singleQubitMatrix))
        case .hadamard:
            result = .success((Constants.matrixHadamard, .singleQubitMatrix))
        case .phaseShift(let radians, _):
            result = .success((Matrix.makePhaseShift(radians: radians), .singleQubitMatrix))
        case .rotation(let axis, let radians, _):
            result = .success((Matrix.makeRotation(axis: axis, radians: radians),
                               .singleQubitMatrix))
        case .matrix(let matrix, _):
            result = makeMatrixResult(matrix: matrix)
        case .oracle(let truthTable, let controls, let gate):
            result = makeOracleResult(truthTable: truthTable, controls: controls, gate: gate)
        case .controlled(let gate, let controls):
            result = makeControlledResult(gate: gate, controls: controls)
        }

        return result
    }

    func makeMatrixResult(matrix: Matrix) -> Result<ExtractMatrixResult, GateError> {
        guard matrix.rowCount.isPowerOfTwo else {
            return .failure(.gateMatrixRowCountHasToBeAPowerOfTwo)
        }
        // Validate matrix before expanding it so the operation requires less time
        guard matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance) else {
            return .failure(.gateMatrixIsNotUnitary)
        }

        return .success((matrix,
                         matrix.rowCount == 2 ? .singleQubitMatrix : .otherMultiQubitMatrix))
    }

    func makeOracleResult(truthTable: [String],
                          controls: [Int],
                          gate: Gate) -> Result<ExtractMatrixResult, GateError> {
        switch gate.extractMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success((let matrix, _)):
            switch Matrix.makeOracle(truthTable: truthTable,
                                     controlCount: controls.count,
                                     controlledMatrix: matrix) {
            case .failure(.matrixIsNotSquare), .failure(.matrixRowCountHasToBeAPowerOfTwo):
                fatalError("Unexpected error.")
            case .failure(.controlCountHasToBeBiggerThanZero):
                return .failure(.gateControlsCanNotBeAnEmptyList)
            case .success(let oracleMatrix):
                return .success((oracleMatrix, .otherMultiQubitMatrix))
            }
        }
    }

    func makeControlledResult(gate: Gate,
                              controls: [Int]) -> Result<ExtractMatrixResult, GateError> {
        switch gate.extractMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success((let matrix, let matrixType)):
            switch Matrix.makeControlledMatrix(matrix: matrix, controlCount: controls.count) {
            case .failure(.matrixIsNotSquare), .failure(.matrixRowCountHasToBeAPowerOfTwo):
                fatalError("Unexpected error.")
            case .failure(.controlCountHasToBeBiggerThanZero):
                return .failure(.gateControlsCanNotBeAnEmptyList)
            case .success(let controlledMatrix):
                switch matrixType {
                case .singleQubitMatrix, .fullyControlledSingleQubitMatrix:
                    return .success((controlledMatrix, .fullyControlledSingleQubitMatrix))
                case .otherMultiQubitMatrix:
                    return .success((controlledMatrix, .otherMultiQubitMatrix))
                }
            }
        }
    }
}
