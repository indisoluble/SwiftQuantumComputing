//
//  RegisterGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/08/2018.
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
import os.log

// MARK: - Main body

struct RegisterGateFactory {

    // MARK: - Private properties

    private let qubitCount: Int
    private let baseMatrix: Matrix

    // MARK: - Private class methods

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init?(qubitCount: Int, baseMatrix: Matrix) {
        guard baseMatrix.isSquare else {
            os_log("init failed: matrix is not square",
                   log: RegisterGateFactory.logger,
                   type: .debug)

            return nil
        }

        guard baseMatrix.rowCount.isPowerOfTwo else {
            os_log("init failed: matrix row count has to be a power of 2",
                   log: RegisterGateFactory.logger,
                   type: .debug)

            return nil
        }

        guard qubitCount > 0 else {
            os_log("init failed: a register has to have at least 1 qubit",
                   log: RegisterGateFactory.logger,
                   type: .debug)

            return nil
        }

        let matrixQubitCount = Int.log2(baseMatrix.rowCount)
        guard (matrixQubitCount <= qubitCount) else {
            os_log("init failed: matrix handles more qubits than are available",
                   log: RegisterGateFactory.logger,
                   type: .debug)

            return nil
        }

        self.qubitCount = qubitCount
        self.baseMatrix = baseMatrix
    }

    // MARK: - Internal methods

    func makeGate(inputs: [Int]) -> RegisterGate? {
        guard areInputsValid(inputs) else {
            os_log("makeGate failed: provide as many unique qubits as required by the matrix",
                   log: RegisterGateFactory.logger,
                   type: .debug)

            return nil
        }

        let extended = makeExtendedMatrix(indices: inputs.map { qubitCount - $0 - 1 })
        return RegisterGate(matrix: extended)
    }
}

// MARK: - Private body

private extension RegisterGateFactory {

    // MARK: - Constants

    enum Constants {
        static let baseIdentity = Matrix.makeIdentity(count: 2)!
        static let baseSwap = Matrix.makeSwap()
    }

    // MARK: - Private methods

    func areInputsValid(_ inputs: [Int]) -> Bool {
        return (doesInputCountMatchBaseMatrixQubitCount(inputs) &&
            areInputsUnique(inputs) &&
            areInputsInBound(inputs))
    }

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func areInputsInBound(_ inputs: [Int]) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }

    func doesInputCountMatchBaseMatrixQubitCount(_ inputs: [Int]) -> Bool {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }

    func makeExtendedMatrix(indices: [Int]) -> Matrix {
        guard let (pos, index) = firstIndexNotAlignedToBaseMatrix(indices) else {
            return makeExtendedMatrixWithBaseMatrixOnTopLeftCorner()
        }

        let swappedIndex = (index - 1)
        var swappedIndices = indices.map { ($0 == swappedIndex) ? index : $0 }
        swappedIndices[pos] = swappedIndex

        let extended = makeExtendedMatrix(indices: swappedIndices)
        let swap = makeSwapMatrix(index: swappedIndex)

        return (swap * (extended * swap)!)!
    }

    func firstIndexNotAlignedToBaseMatrix(_ indices: [Int]) -> (pos: Int, index: Int)? {
        return zip((0..<indices.count), indices).first(where: !=)
    }

    func makeExtendedMatrixWithBaseMatrixOnTopLeftCorner() -> Matrix {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)
        let remainingQubits = (qubitCount - matrixQubitCount)
        guard (remainingQubits > 0) else {
            return baseMatrix
        }

        let identity = makeIdentityMatrix(qubits: remainingQubits)
        return Matrix.tensorProduct(baseMatrix, identity)
    }

    func makeIdentityMatrix(qubits: Int) -> Matrix {
        return (1..<qubits).reduce(Constants.baseIdentity) { (partial, _) in
            return Matrix.tensorProduct(partial, Constants.baseIdentity)
        }
    }

    func makeSwapMatrix(index: Int) -> Matrix {
        let topQubitCount = index
        let swapQubitCount = Int.log2(Constants.baseSwap.rowCount)
        let bottomQubitCount = (qubitCount - topQubitCount - swapQubitCount)

        var swap = Constants.baseSwap
        if (bottomQubitCount > 0) {
            swap = Matrix.tensorProduct(swap, makeIdentityMatrix(qubits: bottomQubitCount))
        }
        if (topQubitCount > 0) {
            swap = Matrix.tensorProduct(makeIdentityMatrix(qubits: topQubitCount), swap)
        }

        return swap
    }
}
