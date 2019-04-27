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

// MARK: - Main body

struct MainGeneticUseCaseEvaluator {

    // MARK: - Private properties

    private let qubits: [Int]
    private let useCase: GeneticUseCase
    private let factory: CircuitFactory
    private let oracleFactory: OracleCircuitFactory

    // MARK: - Internal init methods

    enum InitError: Error {
        case qubitCountHasToBeBiggerThanZero
    }

    init(qubitCount: Int,
         useCase: GeneticUseCase,
         factory: CircuitFactory,
         oracleFactory: OracleCircuitFactory) throws {
        guard qubitCount > 0 else {
            throw InitError.qubitCountHasToBeBiggerThanZero
        }

        self.qubits = Array((0..<qubitCount).reversed())
        self.useCase = useCase
        self.factory = factory
        self.oracleFactory = oracleFactory
    }
}

// MARK: - GeneticUseCaseEvaluator methods

extension MainGeneticUseCaseEvaluator: GeneticUseCaseEvaluator {
    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) throws -> Double {
        var oracleCircuit: OracleCircuitFactory.OracleCircuit!
        do {
            oracleCircuit = try oracleFactory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                                useCase: useCase)
        } catch OracleCircuitFactoryMakeOracleCircuitError.truthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(_) {
            throw GeneticUseCaseEvaluationError.useCaseTruthTableQubitCountHasToBeBiggerThanZeroToMakeOracle
        } catch OracleCircuitFactoryMakeOracleCircuitError.truthTableRequiresMoreInputQubitsThatAreAvailableToMakeOracle(_) {
            throw GeneticUseCaseEvaluationError.useCaseTruthTableRequiresMoreInputQubitsThatAreAvailableToMakeOracle
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        let gates = oracleCircuit.circuit
        let circuit = try! factory.makeCircuit(qubitCount: qubits.count, gates: gates)

        let input = useCase.circuit.input
        var measures: [Double]!
        do {
            measures = try circuit.measure(qubits: qubits, afterInputting: input)
        } catch CircuitMeasureError.unableToExtractMatrixFromGate(let index) {
            throw GeneticUseCaseEvaluationError.unableToExtractMatrix(gate: circuit.gates[index])
        } catch CircuitMeasureError.gateDoesNotHaveValidDimension(let index) {
            throw GeneticUseCaseEvaluationError.gateDoesNotHaveValidDimension(gate: circuit.gates[index])
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        guard let index = Int(useCase.circuit.output, radix: 2) else {
            throw GeneticUseCaseEvaluationError.useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        }

        guard (index >= 0) && (index < measures.count) else {
            throw GeneticUseCaseEvaluationError.useCaseCircuitOutputHasMoreQubitsThatCircuitHas
        }

        return abs(1 - measures[index])
    }
}
