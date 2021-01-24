//
//  TwoLevelDecompositionSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/10/2020.
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

/// A quantum gate can be decomposed into a sequence of fully controlled two-level matrix gates and not gates.
/// The following implementation is based on:
/// [Decomposition of unitary matrices and quantum gates](https://arxiv.org/abs/1210.7366) &
/// [Decomposition of unitary matrix into quantum gates](https://github.com/fedimser/quantum_decomp/blob/master/res/Fedoriaka2019Decomposition.pdf)
public struct TwoLevelDecompositionSolver {

    // MARK: - Public class methods

    /**
     Decompose `gate` into a sequence of fully controlled two-level matrix gates and not gates.

     - Parameter gate: `Gate` instance to decompose.
     - Parameter qubitCount: Number of qubits in the circuit.

     - Returns: A sequence of `Gate` instances that replace the input `gate`. Or `GateError` error.
     */
    public static func decomposeGate(_ gate: Gate,
                                     restrictedToCircuitQubitCount qubitCount: Int? = nil) -> Result<[Gate], GateError> {
        let actualQubitCount = (qubitCount == nil ? [gate].qubitCount() : qubitCount!)

        var gateMatrix: Matrix!
        let gateInputs: [Int]!
        switch gate.extractComponents(restrictedToCircuitQubitCount: actualQubitCount) {
        case .success((let simulatorGateMatrix, let simulatorInputs)):
            switch simulatorGateMatrix {
            case .matrix(let matrix), .fullyControlledMatrix(let matrix, _):
                if matrix.count == 2 {
                    return .success([gate])
                }
            }

            gateMatrix = simulatorGateMatrix.matrix.rawMatrix
            gateInputs = simulatorInputs
        case .failure(let error):
            return .failure(error)
        }

        let matrixCount = gateMatrix.rowCount
        let grayCodes = (0..<matrixCount).grayCodes()
        let controlledGateInputs = deriveControlledGateInputs(fromInputs: gateInputs,
                                                              withGrayCodes: grayCodes)
        let identity = try! Matrix.makeIdentity(count: 2).get()
        let swapRows = try! Matrix.makePermutation(permutation: [1, 0]).get()
        let swapColumns = swapRows.transposed()

        var decomposition: [Gate] = []
        for rowIdx in 0...(matrixCount - 2) {
            let row = grayCodes[rowIdx]

            for typeIdx in stride(from: matrixCount - 2, through: rowIdx, by: -1) {
                let col = grayCodes[typeIdx]
                let colToDelete = grayCodes[typeIdx + 1]

                let colValue = gateMatrix[row, col]
                let colValueToDelete = gateMatrix[row, colToDelete]

                let vector = try! Vector([colValue, colValueToDelete])
                var elimination = try! vector.eliminationMatrix().get()
                if elimination.isApproximatelyEqual(to: identity,
                                                    absoluteTolerance: SharedConstants.tolerance) {
                    continue
                }

                var indexes = (col, colToDelete)
                if colToDelete < col {
                    indexes = (colToDelete, col)
                    elimination = try! (swapRows * (elimination * swapColumns).get()).get()
                }

                let twoLevelMatrix = try! Matrix.makeTwoLevelUnitary(count: matrixCount,
                                                                     submatrix: elimination,
                                                                     indexes: indexes).get()
                gateMatrix = try! (gateMatrix * twoLevelMatrix).get()

                let subGates = controlledGate(withInputs: controlledGateInputs[typeIdx],
                                              matrix: elimination.conjugateTransposed())
                decomposition.append(contentsOf: subGates)
            }
        }

        for typeIdx in stride(from: 0, through: matrixCount - 2, by: 2) {
            let row = grayCodes[typeIdx]
            let nextRow = grayCodes[typeIdx + 1]

            let diagonal = (row < nextRow ? row : nextRow)
            let nextDiagonal = (row < nextRow ? nextRow : row)

            let matrix = try! Matrix([
                [gateMatrix[diagonal, diagonal], .zero],
                [.zero, gateMatrix[nextDiagonal, nextDiagonal]]
            ])
            if matrix.isApproximatelyEqual(to: identity,
                                           absoluteTolerance: SharedConstants.tolerance) {
                continue
            }

            let subGates = controlledGate(withInputs: controlledGateInputs[typeIdx], matrix: matrix)
            decomposition.append(contentsOf: subGates)
        }

        return .success(decomposition)
    }
}

// MARK: - Private body

private extension TwoLevelDecompositionSolver {

    // MARK: - Private types

    typealias ControlledGateInputs = (target: Int, inputs: [Int], notTargets: [Int])

    // MARK: - Private class methods

    static func deriveControlledGateInputs(fromInputs inputs: [Int],
                                           withGrayCodes grayCodes: [Int]) -> [ControlledGateInputs] {
        let inputCount = inputs.count
        let controlRange = (0..<inputCount)

        var result: [ControlledGateInputs] = []
        for idx in 0..<(grayCodes.count - 1) {
            var activatedBits = (grayCodes[idx] ^ grayCodes[idx + 1]).activatedBits(count: inputCount)

            let targetIndex = inputCount - 1 - activatedBits.first!
            let controlIndexes = controlRange.filter { $0 != targetIndex }

            activatedBits = grayCodes[idx].activatedBits(count: inputCount)
            let notTargetIndexes = controlIndexes.filter { !activatedBits.contains(inputCount - 1 - $0) }

            result.append((inputs[targetIndex],
                           controlIndexes.map { inputs[$0] },
                           notTargetIndexes.map { inputs[$0] }))
        }

        return result
    }

    static func controlledGate(withInputs inputs: ControlledGateInputs, matrix: Matrix) -> [Gate] {
        let (target, controls, notTargets) = inputs
        let notGates = Gate.not(targets: notTargets)
        let subGate = Gate.controlled(gate: .matrix(matrix: matrix, inputs: [target]),
                                      controls: controls)

        var result = notGates
        result.append(subGate)
        result.append(contentsOf: notGates)

        return result
    }
}
