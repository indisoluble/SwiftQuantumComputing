//
//  GeneticUseCaseEvaluator.swift
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

struct GeneticUseCaseEvaluator {

    // MARK: - Private properties

    private let qubits: [Int]
    private let input: String
    private let factory: CircuitFactory
    private let useCase: GeneticUseCase

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(qubitCount: Int, factory: CircuitFactory, useCase: GeneticUseCase) {
        self.qubits = Array((0..<qubitCount).reversed())
        self.input = String(repeating: "0", count: qubitCount)
        self.factory = factory
        self.useCase = useCase
    }

    // MARK: - Internal class methods

    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) -> Double? {
        var gates: [FixedGate] = []

        var didAppendOracle = false
        for genGate in geneticCircuit {
            let tt = useCase.truthTable
            let ttCount = useCase.truthTableQubitCount
            guard let fixed = genGate.makeFixed(truthTable: tt, truthTableQubitCount: ttCount) else {
                os_log("evaluateCircuit: unable to make fixed gates with provided list",
                       log: GeneticUseCaseEvaluator.logger,
                       type: .debug)

                return nil
            }

            var doAppendGate = true
            if fixed.didUseTruthTable {
                doAppendGate = !didAppendOracle
                didAppendOracle = true
            }

            if doAppendGate {
                gates.append(fixed.gate)
            }
        }

        guard let circuit = factory.makeCircuit(qubitCount: qubits.count, gates: gates) else {
            os_log("evaluateCircuit: unable to make a circuit with provided gates",
                   log: GeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard let measures = circuit.measure(qubits: qubits, afterInputting: input) else {
            os_log("evaluateCircuit: unable to get measures with provided params",
                   log: GeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard let index = Int(useCase.circuitOutput, radix: 2) else {
            os_log("evaluateCircuit: provided output is not valid",
                   log: GeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        guard (index >= 0) && (index < measures.count) else {
            os_log("evaluateCircuit: output is out of range",
                   log: GeneticUseCaseEvaluator.logger,
                   type: .debug)

            return nil
        }

        return abs(1 - measures[index])
    }
}
