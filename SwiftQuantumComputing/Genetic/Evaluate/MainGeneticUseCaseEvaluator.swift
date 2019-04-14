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
        } catch OracleCircuitFactoryMakeOracleCircuitError.truthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.truthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(at: index)
        } catch OracleCircuitFactoryMakeOracleCircuitError.truthTableRequiresMoreInputQubitsThatAreAvailableToMakeOracle(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.truthTableRequiresMoreInputQubitsThatAreAvailableToMakeOracle(at: index)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        let gates = oracleCircuit.circuit
        let circuit = try! factory.makeCircuit(qubitCount: qubits.count, gates: gates)

        let input = useCase.circuit.input
        var measures: [Double]!
        do {
            measures = try circuit.measure(qubits: qubits, afterInputting: input)
        } catch CircuitMeasureError.informBitsAsANonEmptyStringComposedOnlyOfZerosAndOnes {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.useCaseCircuitInputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        } catch CircuitMeasureError.unableToExtractMatrixFromGate(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.unableToExtractMatrixFromGate(around: index)
        } catch CircuitMeasureError.gateMatrixIsNotSquare(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateMatrixIsNotSquare(around: index)
        } catch CircuitMeasureError.gateMatrixRowCountHasToBeAPowerOfTwo(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateMatrixRowCountHasToBeAPowerOfTwo(around: index)
        } catch CircuitMeasureError.gateMatrixHandlesMoreQubitsThanAreAvailable(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateMatrixHandlesMoreQubitsThanAreAvailable(around: index)
        } catch CircuitMeasureError.gateInputCountDoesNotMatchMatrixQubitCount(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateInputCountDoesNotMatchMatrixQubitCount(around: index)
        } catch CircuitMeasureError.gateInputsAreNotUnique(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateInputsAreNotUnique(around: index)
        } catch CircuitMeasureError.gateInputsAreNotInBound(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateInputsAreNotInBound(around: index)
        } catch CircuitMeasureError.gateIsNotUnitary(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateIsNotUnitary(around: index)
        } catch CircuitMeasureError.gateDoesNotHaveValidDimension(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.gateDoesNotHaveValidDimension(around: index)
        } catch CircuitMeasureError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(let index) {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(around: index)
        } catch CircuitMeasureError.qubitsAreNotInBound {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.evaluatorForCircuitWithMoreQubits
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        guard let index = Int(useCase.circuit.output, radix: 2) else {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        }

        guard (index >= 0) && (index < measures.count) else {
            throw GeneticUseCaseEvaluatorEvaluateCircuitError.useCaseCircuitOutputHasMoreQubitsThatCircuitHas
        }

        return abs(1 - measures[index])
    }
}
