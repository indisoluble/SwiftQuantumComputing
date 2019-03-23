//
//  MainGeneticUseCaseEvaluator.swift
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

struct MainGeneticUseCaseEvaluator {

    // MARK: - Private properties

    private let qubits: [Int]
    private let useCase: GeneticUseCase
    private let factory: CircuitFactory
    private let oracleFactory: OracleCircuitFactory

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(qubitCount: Int,
         useCase: GeneticUseCase,
         factory: CircuitFactory,
         oracleFactory: OracleCircuitFactory) {
        self.qubits = Array((0..<qubitCount).reversed())
        self.useCase = useCase
        self.factory = factory
        self.oracleFactory = oracleFactory
    }
}

// MARK: - GeneticUseCaseEvaluator methods

extension MainGeneticUseCaseEvaluator: GeneticUseCaseEvaluator {
    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) -> Double? {
        let oracleCircuit = oracleFactory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                            useCase: useCase)
        guard let (gates, _) = oracleCircuit else {
            os_log("evaluateCircuit: unable to make fixed gates with provided list",
                   log: MainGeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard let circuit = factory.makeCircuit(qubitCount: qubits.count, gates: gates) else {
            os_log("evaluateCircuit: unable to make a circuit with provided gates",
                   log: MainGeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        let input = useCase.circuit.input
        guard let measures = circuit.measure(qubits: qubits, afterInputting: input) else {
            os_log("evaluateCircuit: unable to get measures with provided params",
                   log: MainGeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard let index = Int(useCase.circuit.output, radix: 2) else {
            os_log("evaluateCircuit: provided output is not valid",
                   log: MainGeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard (index >= 0) && (index < measures.count) else {
            os_log("evaluateCircuit: output is out of range",
                   log: MainGeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        return abs(1 - measures[index])
    }
}
