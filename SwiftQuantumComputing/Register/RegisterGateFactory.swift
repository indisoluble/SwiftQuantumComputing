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

// MARK: - Main body

struct RegisterGateFactory {

    // MARK: - Private properties

    private let qubitCount: Int
    private let baseMatrix: Matrix

    // MARK: - Internal init methods

    enum InitError: Error {
        case matrixIsNotSquare
        case matrixRowCountHasToBeAPowerOfTwo
        case qubitCountHasToBeBiggerThanZero
        case matrixHandlesMoreQubitsThanAreAvailable
    }

    init(qubitCount: Int, baseMatrix: Matrix) throws {
        guard baseMatrix.isSquare else {
            throw InitError.matrixIsNotSquare
        }

        guard baseMatrix.rowCount.isPowerOfTwo else {
            throw InitError.matrixRowCountHasToBeAPowerOfTwo
        }

        guard qubitCount > 0 else {
            throw InitError.qubitCountHasToBeBiggerThanZero
        }

        let matrixQubitCount = Int.log2(baseMatrix.rowCount)
        guard (matrixQubitCount <= qubitCount) else {
            throw InitError.matrixHandlesMoreQubitsThanAreAvailable
        }

        self.qubitCount = qubitCount
        self.baseMatrix = baseMatrix
    }

    // MARK: - Internal methods

    enum MakeGateError: Error {
        case inputCountDoesNotMatchBaseMatrixQubitCount
        case inputsAreNotUnique
        case inputsAreNotInBound
        case gateIsNotUnitary
    }

    func makeGate(inputs: [Int]) throws -> RegisterGate {
        guard doesInputCountMatchBaseMatrixQubitCount(inputs) else {
            throw MakeGateError.inputCountDoesNotMatchBaseMatrixQubitCount
        }

        guard areInputsUnique(inputs) else {
            throw MakeGateError.inputsAreNotUnique
        }

        guard areInputsInBound(inputs) else {
            throw MakeGateError.inputsAreNotInBound
        }

        let extended = makeExtendedMatrix(indices: inputs.map { qubitCount - $0 - 1 })

        do {
            return try RegisterGate(matrix: extended)
        } catch RegisterGate.InitError.matrixIsNotUnitary {
            throw MakeGateError.gateIsNotUnitary
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}

// MARK: - Private body

private extension RegisterGateFactory {

    // MARK: - Constants

    enum Constants {
        static let baseIdentity = try! Matrix.makeIdentity(count: 2)
        static let baseSwap = Matrix.makeSwap()
    }

    // MARK: - Private methods

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

        return (try! swap * (try! extended * swap))
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
