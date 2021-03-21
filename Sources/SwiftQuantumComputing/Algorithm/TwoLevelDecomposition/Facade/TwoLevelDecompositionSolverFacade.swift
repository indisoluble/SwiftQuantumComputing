//
//  TwoLevelDecompositionSolverFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/03/2021.
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

// MARK: - Main body

struct TwoLevelDecompositionSolverFacade {

    // MARK: - Private properties

    private let singleQubitGateDecomposer: SingleQubitGateDecompositionSolver

    // MARK: - Internal init methods

    init(singleQubitGateDecomposer: SingleQubitGateDecompositionSolver) {
        self.singleQubitGateDecomposer = singleQubitGateDecomposer
    }
}

// MARK: - TwoLevelDecompositionSolver methods

extension TwoLevelDecompositionSolverFacade: TwoLevelDecompositionSolver {
    func decomposeGate(_ gate: Gate,
                       restrictedToCircuitQubitCount qubitCount: Int) -> Result<[Gate], GateError> {
        let extractor = SimulatorMatrixExtractor(extractor: gate)

        var gateMatrix: Matrix
        let gateInputs: [Int]
        switch extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let simulatorGateMatrix, let simulatorInputs)):
            if simulatorGateMatrix.count == 2 {
                return .success(singleQubitGateDecomposer.decomposeGate(gate))
            }

            gateMatrix = simulatorGateMatrix.expandedRawMatrix()
            gateInputs = simulatorInputs
        case .failure(let error):
            return .failure(error)
        }

        let matrixCount = gateMatrix.rowCount
        let grayCodes = (0..<matrixCount).grayCodes()
        let controlledGateInputs = deriveControlledGateInputs(fromInputs: gateInputs,
                                                              withGrayCodes: grayCodes)
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
                if elimination.isApproximatelyEqual(to: Constants.matrixIdentity,
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
            if matrix.isApproximatelyEqual(to: Constants.matrixIdentity,
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

private extension TwoLevelDecompositionSolverFacade {

    // MARK: - Private types

    typealias ControlledGateInputs = (target: Int, inputs: [Int], notTargets: [Int])

    // MARK: - Constants

    enum Constants {
        static let matrixIdentity = try! Matrix.makeIdentity(count: 2).get()
    }

    // MARK: - Private methods

    func deriveControlledGateInputs(fromInputs inputs: [Int],
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

    func controlledGate(withInputs inputs: ControlledGateInputs, matrix: Matrix) -> [Gate] {
        let (target, controls, notTargets) = inputs

        let notGates = Gate.not(targets: notTargets)

        let matrixGate = Gate.matrix(matrix: matrix, inputs: [target])
        let decomposedGates = singleQubitGateDecomposer.decomposeGate(matrixGate)
        let controlledGates = decomposedGates.map { Gate.controlled(gate: $0, controls: controls) }

        var result = notGates
        result.append(contentsOf: controlledGates)
        result.append(contentsOf: notGates)

        return result
    }
}
