//
//  MainNoiseCircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/09/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

/// Conforms `NoiseCircuitFactory`. Use to create new `NoiseCircuit` instances
public struct MainNoiseCircuitFactory {

    // MARK: - Public types

    /// Define behaviour of `NoiseCircuit.densityMatrix(withInitialState:)`
    public enum DensityMatrixConfiguration {
        /// Each `Gate` is expanded into a `Matrix` before applying to the `CircuitDensityMatrix` for the entire circuit.
        /// Matrix expansion is performed with up to `expansionConcurrency` threads.
        /// If `expansionConcurrency` is 0 or less, it will be defaulted to 1.
        /// This configuration has the biggest memory footprint but it is the fastest.
        case matrix(expansionConcurrency: Int = 1)
        /// To apply a `Gate` to the `CircuitDensityMatrix` for the entire circuit, up to `calculationConcurrency`
        /// rows in the density matrix are calculated simultaneously.
        /// When needed, rows in `Gate` will be expanded using up to `expansionConcurrency` threads, so at any
        /// given moment there might be `calculationConcurrency` * `expansionConcurrency` threads running.
        /// If `calculationConcurrency` or `expansionConcurrency` are set to 0 or less, they will be defaulted to 1.
        case row(calculationConcurrency: Int = 1, expansionConcurrency: Int = 1)
    }

    // MARK: - Private properties

    private let densityMatrixConfiguration: DensityMatrixConfiguration

    // MARK: - Public init methods

    /**
     Initialize a `MainNoiseCircuitFactory` instance.

     - Parameter densityMatrixConfiguration:Defines how a density matrix is calculated. By default is set to
     `DensityMatrixConfiguration.matrix`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.

     - Returns: A`MainNoiseCircuitFactory` instance.
     */
    public init(densityMatrixConfiguration: DensityMatrixConfiguration = .matrix()) {
        self.densityMatrixConfiguration = densityMatrixConfiguration
    }
}

// MARK: - NoiseCircuitFactory methods

extension MainNoiseCircuitFactory: NoiseCircuitFactory {
    /// Check `CircuitFactory.makeNoiseCircuit(gates:)`
    public func makeNoiseCircuit(quantumOperators: [QuantumOperator]) -> NoiseCircuit {
        return NoiseCircuitFacade(quantumOperators: quantumOperators,
                                  densityMatrixSimulator: makeDensityMatrixSimulator())
    }
}

// MARK: - Private body

private extension MainNoiseCircuitFactory {

    // MARK: - Private methods

    func makeDensityMatrixSimulator() -> DensityMatrixSimulator {
        let transformation = makeDensityMatrixTransformation()
        let timeEvolutionFactory = DensityMatrixTimeEvolutionFactoryAdapter(transformation: transformation)

        let densityMatrixFactory = MainCircuitDensityMatrixFactory()

        return DensityMatrixSimulatorFacade(timeEvolutionFactory: timeEvolutionFactory,
                                            densityMatrixFactory: densityMatrixFactory)
    }

    func makeDensityMatrixTransformation() -> DensityMatrixTransformation {
        let transformation: DensityMatrixTransformation
        switch densityMatrixConfiguration {
        case .matrix(let matrixExpansionConcurrency):
            let mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixDensityMatrixTransformation(expansionConcurrency: mc)
        case .row(let densityCalculationConcurrency, let rowExpansionConcurrency):
            let dcc = densityCalculationConcurrency > 0 ? densityCalculationConcurrency : 1
            let rec = rowExpansionConcurrency > 0 ? rowExpansionConcurrency : 1

            transformation = try! CSMRowByRowDensityMatrixTransformation(calculationConcurrency: dcc,
                                                                         expansionConcurrency: rec)
        }

        return transformation
    }
}
