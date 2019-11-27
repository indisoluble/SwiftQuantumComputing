//
//  OracleGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/01/2019.
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

/// A quantum gate used on genetic programming: Oracle
public struct OracleGate {

    // MARK: - Private properties

    private let truthTable: [String]
    private let truthTableQubitCount: Int

    // MARK: - Public init methods

    /// Errors throwed by `OracleGate.init(truthTable:truthTableQubitCount:)`
    public enum InitError: Error {
        /// Throwed when `truthTableQubitCount` is 0 or less
        case truthTableQubitCountHasToBeBiggerThanZero
    }

    /**
     Initializes a `Gate` instance with a given `truthTable`.

     - Parameter truthTable: List of qubit combinations for which the `control` in a
     `FixedGate.controlledNot(target:,control:)` is activated.
     - Parameter truthTableQubitCount: Total number of qubits for all qubits combinations in `truthTable`.

     - Throws: `OracleGate.InitError`.

     - Returns: A `Gate` instance.
     */
    public init(truthTable: [String], truthTableQubitCount: Int) throws {
        guard truthTableQubitCount > 0 else {
            throw InitError.truthTableQubitCountHasToBeBiggerThanZero
        }

        self.truthTable = truthTable
        self.truthTableQubitCount = truthTableQubitCount
    }
}

// MARK: - Gate methods

extension OracleGate: Gate {
    public func makeFixed(inputs: [Int]) throws -> FixedGate {
        guard inputs.count >= (truthTableQubitCount + 1) else {
            throw EvolveCircuitError.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self)
        }

        return .oracle(truthTable: truthTable,
                       target: inputs[truthTableQubitCount],
                       controls: Array(inputs[0..<truthTableQubitCount]))
    }
}
