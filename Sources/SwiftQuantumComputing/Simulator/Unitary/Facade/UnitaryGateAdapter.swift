//
//  UnitaryGateAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

struct UnitaryGateAdapter {

    // MARK: - Private properties

    private let matrix: Matrix
    private let matrixFactory: SimulatorCircuitMatrixFactory

    private let qubitCount: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case matrixIsNotSquare
        case matrixRowCountHasToBeAPowerOfTwo
    }

    init(matrix: Matrix, matrixFactory: SimulatorCircuitMatrixFactory) throws {
        guard matrix.isSquare else {
            throw InitError.matrixIsNotSquare
        }

        guard matrix.rowCount.isPowerOfTwo else {
            throw InitError.matrixRowCountHasToBeAPowerOfTwo
        }

        qubitCount = Int.log2(matrix.rowCount)

        self.matrix = matrix
        self.matrixFactory = matrixFactory
    }
}

// MARK: - UnitaryMatrix methods

extension UnitaryGateAdapter: UnitaryMatrix {
    func unitary() throws -> Matrix {
        guard matrix.isUnitary(accuracy: Constants.accuracy) else {
            throw UnitaryMatrixError.matrixIsNotUnitary
        }

        return matrix
    }
}

// MARK: - SimulatorTransformation methods

extension UnitaryGateAdapter: SimulatorTransformation {
    func applying(_ gate: SimulatorGate) throws -> UnitaryGateAdapter {
        let components = try gate.extractComponents(restrictedToCircuitQubitCount: qubitCount).get()
        let circuitMatrix = matrixFactory.makeCircuitMatrix(qubitCount: qubitCount,
                                                            baseMatrix: components.matrix,
                                                            inputs: components.inputs)
        let nextMatrix = try! (circuitMatrix.rawMatrix * matrix).get()

        return try! UnitaryGateAdapter(matrix: nextMatrix, matrixFactory: matrixFactory)
    }
}

// MARK: - Private body

private extension UnitaryGateAdapter {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }
}
