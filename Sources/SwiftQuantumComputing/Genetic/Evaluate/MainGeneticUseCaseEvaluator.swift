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

    private let useCase: GeneticUseCase
    private let factory: CircuitFactory
    private let oracleFactory: OracleCircuitFactory

    // MARK: - Internal init methods

    init(useCase: GeneticUseCase,
         factory: CircuitFactory,
         oracleFactory: OracleCircuitFactory) throws {
        guard useCase.circuit.qubitCount > 0 else {
            throw EvolveCircuitError.useCaseCircuitQubitCountHasToBeBiggerThanZero
        }

        self.useCase = useCase
        self.factory = factory
        self.oracleFactory = oracleFactory
    }
}

// MARK: - GeneticUseCaseEvaluator methods

extension MainGeneticUseCaseEvaluator: GeneticUseCaseEvaluator {
    func evaluateCircuit(_ geneticCircuit: [GeneticGate]) throws -> Double {
        let oracleCircuit = try oracleFactory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                                useCase: useCase)

        let gates = oracleCircuit.circuit
        let circuit = factory.makeCircuit(gates: gates)

        let input = useCase.circuit.input
        var probabilities: [Double]!
        do {
            probabilities = try circuit.probabilities(withInitialBits: input)
        } catch {
            if let error = error as? ProbabilitiesError {
                throw EvolveCircuitError.useCaseMeasurementThrowedError(useCase: useCase,
                                                                        error: error)
            } else {
                fatalError("Unexpected error: \(error).")
            }
        }

        guard let index = Int(useCase.circuit.output, radix: 2) else {
            throw EvolveCircuitError.useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes(useCase: useCase)
        }

        return abs(1 - probabilities[index])
    }
}
