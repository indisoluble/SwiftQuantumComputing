//
//  GeneticFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/01/2019.
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

// MARK: - Errors

/// Errors throwed by `GeneticFactory.evolveCircuit(configuration:useCases:gates:)`
public enum EvolveCircuitError: Error {
    /// Throwed when `GeneticConfiguration.tournamentSize` is 0 which is not valid because a reproduction operation
    /// requires at least 1 circuit in the tournament
    case configurationTournamentSizeHasToBeBiggerThanZero
    /// Throwed if `gate` requires more qubits than `GeneticUseCase.Circuit.qubitCount` specifies
    case gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: ConfigurableGate)
    /// Throwed if `useCase.Circuit.output` is not composed exclusively of 0's and 1's
    case useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes(useCase: GeneticUseCase)
    /// Throwed if any `GeneticUseCase.Circuit.qubitCount` is 0 or a negative number
    case useCaseCircuitQubitCountHasToBeBiggerThanZero
    /// Throwed if `useCases` is an empty list
    case useCaseListIsEmpty
    /// Throwed when a circuit evolved to solve `useCase `throwed `error` while measuring the probabilities of all possible outputs
    case useCaseMeasurementThrowedError(useCase: GeneticUseCase, error: ProbabilitiesError)
    /// Throwed when `GeneticUseCase.Circuit.qubitCount` is not the same in all `useCases`
    case useCasesDoNotSpecifySameCircuitQubitCount
    /// Throwed if `useCase.TruthTable.qubitCount` is 0
    case useCaseTruthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(useCase: GeneticUseCase)
}

// MARK: - Protocol definition

/// A genetic algorithm to find a quantum circuit that includes a `Gate.oracle(truthTable:target:controls:)`
/// and solves a list of `GeneticUseCase` instances.
public protocol GeneticFactory {
    /**
     Result type returned by `GeneticFactory.evolveCircuit(configuration:useCases:gates:)`.

     Values returned:
     - `eval`: Score of the evolded circuit. The nearer to 0, the better solution the circuit is.
     - `gates`: Evolved circuit.
     - `oracleAt`: Position of `Gate.oracle(truthTable:target:controls:)` in `gates`.
     */
    typealias EvolvedCircuit = (eval: Double, gates: [Gate], oracleAt: Int?)

    /**
     Look for a quantum circuit that solves a list of `useCases` using only `gates` and the parameter informed in the
     `configuration`.

     - Parameter configuration: A `GeneticConfiguration` instance wih the parameters for a genetic algorithm.
     - Parameter useCases: List of `GeneticUseCase` instances for which the algorithm looks for a circuit that solves all
     of them simultaneously.
     - Parameter gates: List of allowed gates, i.e. the evolved circuit will only include gates specified in this list and, if
     necessary, an oracle gate.

     - Returns: An `EvolvedCircuit` instance. Or `EvolveCircuitError` error.
     */
    func evolveCircuit(configuration config: GeneticConfiguration,
                       useCases: [GeneticUseCase],
                       gates: [ConfigurableGate]) -> Result<EvolvedCircuit, EvolveCircuitError>
}
