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

struct TwoLevelDecompositionSolver {

    // MARK: - Internal methods

    static func decomposeGate(_ gate: Gate,
                              restrictedToCircuitQubitCount qubitCount: Int) -> Result<[Gate], GateError> {
        let gateMatrix: Matrix!
        let gateInputs: [Int]!
        switch gate.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let matrix, let inputs)):
            gateMatrix = matrix
            gateInputs = inputs
        case .failure(let error):
            return .failure(error)
        }

        let matrixCount = gateMatrix.rowCount
        if matrixCount == 2 {
            return .success([gate])
        }

        let grayCodes = (0..<matrixCount).grayCodes()

        let inputCount = gateInputs.count
        let controlRange = (0..<inputCount)
        var subGateInputs: [(Int, [Int], [Int])] = []
        for idx in 0..<(matrixCount - 1) {
            var activatedBits = (grayCodes[idx] ^ grayCodes[idx + 1]).activatedBits(count: inputCount)

            let targetIndex = inputCount - 1 - activatedBits.first!
            let controlIndexes = controlRange.filter { $0 != targetIndex }

            activatedBits = grayCodes[idx].activatedBits(count: inputCount)
            let notTargetIndexes = controlIndexes.filter { !activatedBits.contains(inputCount - 1 - $0) }

            subGateInputs.append((gateInputs[targetIndex],
                                  controlIndexes.map { gateInputs[$0] },
                                  notTargetIndexes.map { gateInputs[$0] }))
        }

        let permutation = try! Matrix.makePermutation(permutation: grayCodes).get()
        var permutated = try! (permutation * (gateMatrix * permutation.transposed()).get()).get()

        var decomposition: [Gate] = []
        for row in 0..<(matrixCount - 2) {
            for col in stride(from: matrixCount - 1, to: row, by: -1) {
                let b = permutated[row, col]
                if b.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
                    continue
                }

                let a = permutated[row, col - 1]
                let eliminationMatrix: Matrix!
                if a.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
                    eliminationMatrix = Matrix.makeNot()
                } else {
                    eliminationMatrix = try! Vector([a, b]).eliminationMatrix().get()
                }

                let twoLevelMatrix = try! Matrix.makeTwoLevelUnitary(count: matrixCount,
                                                                     submatrix: eliminationMatrix,
                                                                     firstIndex: col - 1,
                                                                     secondIndex: col).get()
                permutated = try! (permutated * twoLevelMatrix).get()

                let (target, controls, notTargets) = subGateInputs[col - 1]

                let notGates = Gate.not(targets: notTargets)
                let subGate = Gate.controlled(gate: .matrix(matrix: eliminationMatrix.conjugateTransposed(),
                                                            inputs: [target]),
                                              controls: controls)

                decomposition.insert(contentsOf: notGates, at: 0)
                decomposition.insert(subGate, at: 0)
                decomposition.insert(contentsOf: notGates, at: 0)
            }
        }

        let lastMatrix = try! Matrix.makeMatrix(rowCount: 2, columnCount: 2, value: { row, col in
            return permutated[matrixCount - 2 + row, matrixCount - 2 + col]
        }).get()
        if !lastMatrix.isApproximatelyEqual(to: try! Matrix.makeIdentity(count: 2).get(),
                                            absoluteTolerance: SharedConstants.tolerance) {
            let (target, controls, notTargets) = subGateInputs[matrixCount - 2]

            let notGates = Gate.not(targets: notTargets)
            let subGate = Gate.controlled(gate: .matrix(matrix: lastMatrix, inputs: [target]),
                                          controls: controls)

            decomposition.insert(contentsOf: notGates, at: 0)
            decomposition.insert(subGate, at: 0)
            decomposition.insert(contentsOf: notGates, at: 0)
        }

        return .success(decomposition)
    }
}
