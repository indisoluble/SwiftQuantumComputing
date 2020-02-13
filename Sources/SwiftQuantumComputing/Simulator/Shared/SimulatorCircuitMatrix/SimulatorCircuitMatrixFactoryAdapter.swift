//
//  SimulatorCircuitMatrixFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/02/2020.
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

// MARK: - Main body

struct SimulatorCircuitMatrixFactoryAdapter {}

// MARK: - SimulatorCircuitMatrixFactory methods

extension SimulatorCircuitMatrixFactoryAdapter: SimulatorCircuitMatrixFactory {
    func makeCircuitMatrix(qubitCount: Int, gate: SimulatorGate) throws -> Matrix {
        let components = try gate.extract()
        let matrix = components.matrix
        let inputs = components.inputs

        guard matrix.rowCount.isPowerOfTwo else {
            throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
        }

        guard matrix.isUnitary(accuracy: Constants.accuracy) else {
            throw GateError.gateMatrixIsNotUnitary
        }

        guard qubitCount > 0 else {
            throw GateError.circuitQubitCountHasToBeBiggerThanZero
        }

        let matrixQubitCount = Int.log2(matrix.rowCount)
        guard (matrixQubitCount <= qubitCount) else {
            throw GateError.gateMatrixHandlesMoreQubitsThatCircuitActuallyHas
        }

        guard doesInputCountMatchBaseMatrixQubitCount(inputs, baseMatrix: matrix) else {
            throw GateError.gateInputCountDoesNotMatchGateMatrixQubitCount
        }

        guard areInputsUnique(inputs) else {
            throw GateError.gateInputsAreNotUnique
        }

        guard areInputsInBound(inputs, qubitCount: qubitCount) else {
            throw GateError.gateInputsAreNotInBound
        }

        return makeExtendedMatrix(qubitCount: qubitCount, inputs: inputs, baseMatrix: matrix)
    }
}

// MARK: - Private body

private extension SimulatorCircuitMatrixFactoryAdapter {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func areInputsInBound(_ inputs: [Int], qubitCount: Int) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }

    func doesInputCountMatchBaseMatrixQubitCount(_ inputs: [Int], baseMatrix: Matrix) -> Bool {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }

    func makeExtendedMatrix(qubitCount: Int, inputs: [Int], baseMatrix: Matrix) -> Matrix {
        let zero = Complex(0)
        let count = Int.pow(2, qubitCount)

        let remainingInputs = (0..<qubitCount).reversed().filter { !inputs.contains($0) }

        var derives: [Int: (base: Int, remaining: Int)] = [:]
        for value in 0..<count {
            derives[value] = (value.derived(takingBitsAt: inputs),
                              value.derived(takingBitsAt: remainingInputs))
        }

        return try! Matrix.makeMatrix(rowCount: count, columnCount: count) { r, c -> Complex in
            let baseRow = derives[r]!.base
            let baseColumn = derives[c]!.base

            let remainingRow = derives[r]!.remaining
            let remainingColumn = derives[c]!.remaining

            return (remainingRow == remainingColumn ? baseMatrix[baseRow, baseColumn] : zero)
        }
    }
}
