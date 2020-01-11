//
//  GeneticUseCase.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/01/2019.
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

/// A genetic algorithm looks for a quantum circuit that includes a `Gate.oracle(truthTable:target:controls:)`
/// and solves a list of `GeneticUseCase` instances. Each `GeneticUseCase` defines the expected `output` for the circuit
/// when its qubits are set to a given `input` and the oracle gate is initialized with a particular `truthTable`
public struct GeneticUseCase {

    // MARK: - Public errors

    /// Errors throwed by `GeneticUseCase.Circuit.init(input:output:)`
    public enum InitError: Error {
        /// Throwed when `input` and `output` do not have the same size
        case circuitInputAndOutputHaveToHaveSameSize
        /// Throwed if the `input` provided is empty
        case circuitQubitCountHasToBeBiggerThanZero
    }

    // MARK: - Public types

    /// A `GeneticUseCase` provides enough data to configure a circuit as well as the oracle gate inside the circuit.
    /// `TruthTable` provides the data for the latter
    public struct TruthTable {

        // MARK: - Public properties

        /// List of qubit combinations for which the `control` in a `Gate.controlledNot(target:control:)`
        /// is activated
        public let truth: [String]
        /// Total number of qubits for all qubits combinations in `truth`
        public let qubitCount: Int
    }

    /// A `GeneticUseCase` provides enough data to configure a circuit as well as the oracle gate inside the circuit.
    /// `Circuit` provides the data for the former
    public struct Circuit {

        // MARK: - Public properties

        /// 0's and 1's that set the values of the qubits before applying any quantum gate
        public let input: String
        /// 0's and 1's that specify the expected values of the qubits once the quantum gates are applied
        public let output: String
        /// Number of qubits in the circuit
        public let qubitCount: Int

        // MARK: - Internal init methods

        init(input: String, output: String) throws {
            guard input.count == output.count else {
                throw InitError.circuitInputAndOutputHaveToHaveSameSize
            }

            guard input.count > 0 else {
                throw InitError.circuitQubitCountHasToBeBiggerThanZero
            }

            self.input = input
            self.output = output
            qubitCount = input.count
        }
    }

    // MARK: - Public properties

    /// Data to configure the oracle gate inside the circuit
    public let truthTable: TruthTable
    /// Data to configure a circuit
    public let circuit: Circuit

    // MARK: - Public init methods

    /**
     Initializes a `GeneticUseCase` instance.

     - Parameter truthTable: List of qubit combinations for which the `control` in a
     `Gate.controlledNot(target:control:)` is activated.
     - Parameter circuitInput: 0's and 1's that set the values of the qubits before applying any quantum gate. If not input is
     provided, qubits are set to 0.
     - Parameter circuitOutput: 0's and 1's that specify the expected values of the qubits once the quantum gates are applied.

     - Throws: `GeneticUseCase.InitError`.

     - Returns: A `GeneticUseCase` instance.
     */
    public init(truthTable: [String], circuitInput: String? = nil, circuitOutput: String) throws {
        let ttQubitCount = truthTable.reduce(0) { $0 > $1.count ? $0 :  $1.count }
        let tt = TruthTable(truth: truthTable, qubitCount: ttQubitCount)

        try self.init(truthTable: tt, circuitInput: circuitInput, circuitOutput: circuitOutput)
    }

    /**
     Initializes a `GeneticUseCase` instance.

     - Parameter emptyTruthTableQubitCount: An oracle gate with an empty truth table never activates the `control`
     in a `Gate.controlledNot(target:control:)`, so the `target` never changes. However, it is still necessary to
     specify how many qubits the truth table handles.
     - Parameter circuitInput: 0's and 1's that set the values of the qubits before applying any quantum gate. If not input is
     provided, qubits are set to 0.
     - Parameter circuitOutput: 0's and 1's that specify the expected values of the qubits once the quantum gates are applied.

     - Throws: `GeneticUseCase.InitError`.

     - Returns: A `GeneticUseCase` instance.
     */
    public init(emptyTruthTableQubitCount: Int,
                circuitInput: String? = nil,
                circuitOutput: String) throws {
        let tt = TruthTable(truth: [], qubitCount: emptyTruthTableQubitCount)

        try self.init(truthTable: tt, circuitInput: circuitInput, circuitOutput: circuitOutput)
    }

    // MARK: - Private init methods

    private init(truthTable: TruthTable,
                 circuitInput: String? = nil,
                 circuitOutput: String) throws {
        let input = circuitInput ?? String(repeating: "0", count: circuitOutput.count)
        let circuit = try Circuit.init(input: input, output: circuitOutput)

        self.truthTable = truthTable
        self.circuit = circuit
    }
}
