//
//  ControlledMatrixGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/03/2020.
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

/// A quantum gate used on genetic programming: ControlledMatrix
public struct ControlledMatrixGate {

    // MARK: - Private properties

    private let matrix: Matrix
    private let matrixQubitCount: Int

    // MARK: - Public init methods

    /// Errors throwed by `ControlledMatrixGate.init(matrix:)`
    public enum InitError: Error {
        /// Throwed when `matrix` is not able to handle at least 1 qubit
        case matrixQubitCountHasToBeBiggerThanZero
    }

    /**
     Initializes a `ConfigurableGate` instance with a given `matrix`.

     - Parameter matrix: A matrix able to handle at least 1 qubits, i.e. with 2^qubitCount rows.

     - Throws: `ControlledMatrixGate.InitError`.

     - Returns: A `ConfigurableGate` instance.
     */
    public init(matrix: Matrix) throws {
        let qc = Int.log2(matrix.rowCount)
        guard qc > 0 else {
            throw InitError.matrixQubitCountHasToBeBiggerThanZero
        }

        self.matrix = matrix
        matrixQubitCount = qc
    }
}

// MARK: - ConfigurableGate methods

extension ControlledMatrixGate: ConfigurableGate {

    /// Check `ConfigurableGate.makeFixed(inputs:)`
    public func makeFixed(inputs: [Int]) throws -> Gate {
        guard inputs.count >= (matrixQubitCount + 1) else {
            throw EvolveCircuitError.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self)
        }

        return .controlledMatrix(matrix: matrix,
                                 inputs: Array(inputs[0..<matrixQubitCount]),
                                 control: inputs[matrixQubitCount])
    }
}
