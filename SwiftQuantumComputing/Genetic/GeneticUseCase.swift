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
import os.log

// MARK: - Main body

public struct GeneticUseCase {

    // MARK: - Types

    public struct TruthTable {

        // MARK: - Public properties

        public let truth: [String]
        public let qubitCount: Int
    }

    public struct Circuit {

        // MARK: - Public properties

        public let input: String
        public let output: String
        public let qubitCount: Int

        // MARK: - Private class properties

        private static let logger = LoggerFactory.makeLogger()

        // MARK: - Internal init methods

        init?(input: String, output: String) {
            guard input.count == output.count else {
                os_log("init failed: input & output of a circuit have the same size",
                       log: Circuit.logger,
                       type: .debug)

                return nil
            }

            self.input = input
            self.output = output
            qubitCount = input.count
        }
    }

    // MARK: - Public properties

    public let truthTable: TruthTable
    public let circuit: Circuit

    // MARK: - Public init methods

    public init?(truthTable: [String], circuitInput: String? = nil, circuitOutput: String) {
        let ttQubitCount = truthTable.reduce(0) { $0 > $1.count ? $0 :  $1.count }
        let tt = TruthTable(truth: truthTable, qubitCount: ttQubitCount)

        self.init(truthTable: tt, circuitInput: circuitInput, circuitOutput: circuitOutput)
    }

    public init?(emptyTruthTableQubitCount: Int,
                circuitInput: String? = nil,
                circuitOutput: String) {
        let tt = TruthTable(truth: [], qubitCount: emptyTruthTableQubitCount)

        self.init(truthTable: tt, circuitInput: circuitInput, circuitOutput: circuitOutput)
    }

    // MARK: - Private init methods

    private init?(truthTable: TruthTable, circuitInput: String? = nil, circuitOutput: String) {
        let input = circuitInput ?? String(repeating: "0", count: circuitOutput.count)
        guard let circuit = Circuit.init(input: input, output: circuitOutput) else {
            return nil
        }

        self.truthTable = truthTable
        self.circuit = circuit
    }
}
