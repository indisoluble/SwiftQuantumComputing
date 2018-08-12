//
//  GateFactory.swift
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

struct GateFactory {

    // MARK: - Private properties

    private let qubitCount: Int
    private let baseMatrix: Matrix

    // MARK: - Init methods

    init?(qubitCount: Int, baseMatrix: Matrix) {
        guard baseMatrix.isSquare else {
            return nil
        }

        guard baseMatrix.rowCount.isPowerOfTwo else {
            return nil
        }

        let matrixQubitCount = Int.log2(baseMatrix.rowCount)
        guard (matrixQubitCount <= qubitCount) else {
            return nil
        }

        self.qubitCount = qubitCount
        self.baseMatrix = baseMatrix
    }

    // MARK: - Public methods

    func makeGate(inputs: Int...) -> Gate? {
        guard areInputsValid(inputs) else {
            return nil
        }

        let extended = makeExtendedMatrix(inputs: inputs)
        return Gate(matrix: extended)
    }
}

// MARK: - Private body

private extension GateFactory {

    // MARK: - Constants

    enum Constants {
        static let baseIdentity = Matrix.makeIdentity(count: 2)!
        static let baseSwap = Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                                      [Complex(0), Complex(0), Complex(1), Complex(0)],
                                      [Complex(0), Complex(1), Complex(0), Complex(0)],
                                      [Complex(0), Complex(0), Complex(0), Complex(1)]])!
    }

    // MARK: - Private methods

    func areInputsValid(_ inputs: [Int]) -> Bool {
        return (!areInputsRepeated(inputs) &&
            !areInputsOutOfBound(inputs) &&
            doesInputCountMatchBaseMatrixQubitCount(inputs))
    }

    func areInputsRepeated(_ inputs: [Int]) -> Bool {
        return (inputs.count != Set(inputs).count)
    }

    func areInputsOutOfBound(_ inputs: [Int]) -> Bool {
        return (inputs.index(where: { $0 >= qubitCount }) != nil)
    }

    func doesInputCountMatchBaseMatrixQubitCount(_ inputs: [Int]) -> Bool {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }

    func makeExtendedMatrix(inputs: [Int]) -> Matrix {
        guard let (index, input) = firstInputNotAlignedToBaseMatrix(inputs) else {
            return makeExtendedMatrixWithBaseMatrixOnTopLeftCorner()
        }

        let swappedInput = (input - 1)
        var swappedInputs = inputs.map { ($0 == swappedInput) ? input : $0 }
        swappedInputs[index] = swappedInput

        let extended = makeExtendedMatrix(inputs: swappedInputs)
        let swap = makeSwapMatrix(input: swappedInput)

        return (swap * (extended * swap)!)!
    }

    func firstInputNotAlignedToBaseMatrix(_ inputs: [Int]) -> (index: Int, input: Int)? {
        return zip((0..<inputs.count), inputs).first(where: !=)
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

    func makeSwapMatrix(input: Int) -> Matrix {
        let topQubitCount = input
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
