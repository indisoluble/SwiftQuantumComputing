//
//  OracleXGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/08/2020.
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

/// A quantum gate used on genetic programming: OracleX
public struct OracleXGate {

    // MARK: - Private properties

    private let truthTable: [String]
    private let truthTableQubitCount: Int
    private let gate: ConfigurableGate

    // MARK: - Public init methods

    /// Errors throwed by `OracleXGate.init(truthTable:truthTableQubitCount:gate:)`
    public enum InitError: Error {
        /// Throwed when `truthTableQubitCount` is 0 or less
        case truthTableQubitCountHasToBeBiggerThanZero
    }

    /**
     Initializes a `ConfigurableGate` instance with a given `truthTable` & `gate`.

     - Parameter truthTable: List of qubit combinations for which the given `gate` is activated.
     - Parameter truthTableQubitCount: Total number of qubits for all qubits combinations in `truthTable`.
     - Parameter gate: Another `ConfigurableGate` instance.

     - Throws: `OracleXGate.InitError`.

     - Returns: A `ConfigurableGate` instance.
     */
    public init(truthTable: [String], truthTableQubitCount: Int, gate: ConfigurableGate) throws {
        guard truthTableQubitCount > 0 else {
            throw InitError.truthTableQubitCountHasToBeBiggerThanZero
        }

        self.truthTable = truthTable
        self.truthTableQubitCount = truthTableQubitCount
        self.gate = gate
    }
}

// MARK: - ConfigurableGate methods

extension OracleXGate: ConfigurableGate {

    /// Check `ConfigurableGate.makeFixed(inputs:)`
    public func makeFixed(inputs: [Int]) -> Result<Gate, EvolveCircuitError> {
        switch gate.makeFixed(inputs: inputs) {
        case .success(let fixedGate):
            let reservedInputs = fixedGate.extractInputs()
            let remainingInputs = inputs.filter { !reservedInputs.contains($0) }
            guard remainingInputs.count >= truthTableQubitCount else {
                return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self))
            }

            return .success(.oracleX(truthTable: truthTable,
                                     controls: Array(remainingInputs[0..<truthTableQubitCount]),
                                     gate: fixedGate))
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self))
        case .failure(.useCaseListIsEmpty),
             .failure(.useCaseMeasurementThrowedError),
             .failure(.useCasesDoNotSpecifySameCircuitQubitCount):
            fatalError("Unexpected error.")
        }
    }
}
