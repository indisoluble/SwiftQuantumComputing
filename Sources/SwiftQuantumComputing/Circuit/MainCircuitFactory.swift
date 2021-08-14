//
//  MainCircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/05/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

/// Conforms `CircuitFactory`. Use to create new `Circuit` instances
public struct MainCircuitFactory {

    // MARK: - Public types

    /// Define performance and memory footprint of `Circuit.unitary(withQubitCount:)`.
    public enum UnitaryConfiguration {
        /// Each `Gate` is expanded into a `Matrix` before applying to the unitary `Matrix` for the entire circuit.
        /// Matrix expansion is performed with up to `expansionConcurrency` threads.
        /// If `expansionConcurrency` is 0 or less, it will be defaulted to 1.
        /// This configuration has the biggest memory footprint but it is the fastest.
        case matrix(expansionConcurrency: Int = 1)
        /// To apply a `Gate` to the unitary `Matrix` for the entire circuit, up to `calculationConcurrency`
        /// rows in the `Gate` are expanded at the same time and applied to the unitary as needed.
        /// In turn, each row will be expanded with up to `expansionConcurrency` threads, so
        /// `calculationConcurrency` * `expansionConcurrency` threads might be running concurrently
        /// at any given moment.
        /// If `calculationConcurrency` or `expansionConcurrency` are set to 0 or less, they will be defaulted to 1.
        case row(calculationConcurrency: Int = 1, expansionConcurrency: Int = 1)
        /// To apply a `Gate` to the unitary `Matrix` for the entire circuit, up to `calculationConcurrency` values
        /// in the unitary are calculated simultaneously. Values in `Gate` are requested one by one and when needed.
        /// If `calculationConcurrency` is 0 or less, it will be defaulted to 1.
        /// This configuration is the slowest but it has the smallest memory footprint.
        case value(calculationConcurrency: Int = 1)
    }

    /// Define performance and memory footprint of `Circuit.statevector(withInitialState:)`
    public enum StatevectorConfiguration {
        /// Each `Gate` is expanded into a `Matrix` before applying to the `CircuitStatevector` for the entire circuit.
        /// Matrix expansion is performed with up to `expansionConcurrency` threads.
        /// If `expansionConcurrency` is 0 or less, it will be defaulted to 1.
        /// This configuration has the biggest memory footprint but it is faster than the others, except
        /// `StatevectorConfiguration.direct`.
        case matrix(expansionConcurrency: Int = 1)
        /// To apply a `Gate` to the `CircuitStatevector` for the entire circuit, up to `calculationConcurrency`
        /// rows in the `Gate` are expanded at the same time and applied to the statevector as needed.
        /// In turn, each row will be expanded with up to `expansionConcurrency` threads, so
        /// `calculationConcurrency` * `expansionConcurrency` threads might be running concurrently
        /// at any given moment.
        /// If `calculationConcurrency` or `expansionConcurrency` are set to 0 or less, they will be defaulted to 1.
        case row(calculationConcurrency: Int = 1, expansionConcurrency: Int = 1)
        /// To apply a `Gate` to the `CircuitStatevector` for the entire circuit, up to `calculationConcurrency`
        /// values in the statevector are calculated simultaneously. Values in `Gate` are requested one by one
        /// and when needed.
        /// If `calculationConcurrency` is 0 or less, it will be defaulted to 1.
        /// This configuration is the slowest but it has the smallest memory footprint.
        case value(calculationConcurrency: Int = 1)
        /// To apply a `Gate` to the `CircuitStatevector` for the entire circuit, up to `calculationConcurrency`
        /// values in the statevector are calculated simultaneously.
        /// If `calculationConcurrency` is 0 or less, it will be defaulted to 1.
        /// It is similar to `StatevectorConfiguration.value` but instead of calculating
        /// all positions in a `Gate`, only those that are needed (not zero) are generated.
        /// If each gate only uses a few qubits in the circuit, this is the fastest option and its memory footprint is almost
        /// identical to `StatevectorConfiguration.value`.
        case direct(calculationConcurrency: Int = 1)
    }

    /// Define behaviour of `Circuit.densityMatrix(withInitialState:)`
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

    private let unitaryConfiguration: UnitaryConfiguration
    private let statevectorConfiguration: StatevectorConfiguration
    private let densityMatrixConfiguration: DensityMatrixConfiguration

    // MARK: - Public init methods
 
    /**
     Initialize a `MainCircuitFactory` instance.

     - Parameter unitaryConfiguration:Defines how a unitary matrix is calculated. By default is set to
     `UnitaryConfiguration.fullMatrix`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.
     - Parameter statevectorConfiguration: Defines how a statevector is calculated. By default is set to
     `StatevectorConfiguration.direct`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.

     - Returns: A`MainCircuitFactory` instance.
     */
    public init(unitaryConfiguration: UnitaryConfiguration = .matrix(),
                statevectorConfiguration: StatevectorConfiguration = .direct(),
                densityMatrixConfiguration: DensityMatrixConfiguration = .matrix()) {
        self.unitaryConfiguration = unitaryConfiguration
        self.statevectorConfiguration = statevectorConfiguration
        self.densityMatrixConfiguration = densityMatrixConfiguration
    }
}

// MARK: - CircuitFactory methods

extension MainCircuitFactory: CircuitFactory {

    /// Check `CircuitFactory.makeCircuit(gates:)`
    public func makeCircuit(gates: [Gate]) -> Circuit {
        return CircuitFacade(gates: gates,
                             unitarySimulator: makeUnitarySimulator(),
                             statevectorSimulator: makeStatevectorSimulator(),
                             densityMatrixSimulator: makeDensityMatrixSimulator())
    }
}

// MARK: - Private body

private extension MainCircuitFactory {

    // MARK: - Private methods

    func makeUnitarySimulator() -> UnitarySimulator {
        return UnitarySimulatorFacade(gateFactory: makeUnitaryGateFactory())
    }

    func makeUnitaryGateFactory() -> UnitaryGateFactory {
        let mc: Int
        let transformation: UnitaryTransformation
        switch unitaryConfiguration {
        case .matrix(let matrixExpansionConcurrency):
            mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixUnitaryTransformation(expansionConcurrency: mc)
        case .row(let unitaryCalculationConcurrency, let rowExpansionConcurrency):
            let ucc = unitaryCalculationConcurrency > 0 ? unitaryCalculationConcurrency : 1
            let rec = rowExpansionConcurrency > 0 ? rowExpansionConcurrency : 1
            mc = rec * ucc

            transformation = try! CSMRowByRowUnitaryTransformation(calculationConcurrency: ucc,
                                                                   expansionConcurrency: rec)
        case .value(let unitaryCalculationConcurrency):
            mc = unitaryCalculationConcurrency > 0 ? unitaryCalculationConcurrency : 1

            transformation = try! CSMElementByElementUnitaryTransformation(calculationConcurrency: mc)
        }

        return try! UnitaryGateFactoryAdapter(maxConcurrency: mc, transformation: transformation)
    }

    func makeStatevectorSimulator() -> StatevectorSimulator {
        let transformation = makeStatevectorTransformation()
        let timeEvolutionFactory = StatevectorTimeEvolutionFactoryAdapter(transformation: transformation)

        let statevectorFactory = MainCircuitStatevectorFactory()

        return StatevectorSimulatorFacade(timeEvolutionFactory: timeEvolutionFactory,
                                          statevectorFactory: statevectorFactory)
    }

    func makeStatevectorTransformation() -> StatevectorTransformation {
        let transformation: StatevectorTransformation
        switch statevectorConfiguration {
        case .matrix(let matrixExpansionConcurrency):
            let mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixStatevectorTransformation(expansionConcurrency: mc)
        case .row(let statevectorCalculationConcurrency, let rowExpansionConcurrency):
            let stcc = statevectorCalculationConcurrency > 0 ? statevectorCalculationConcurrency : 1
            let rec = rowExpansionConcurrency > 0 ? rowExpansionConcurrency : 1

            transformation = try! CSMRowByRowStatevectorTransformation(calculationConcurrency: stcc,
                                                                       expansionConcurrency: rec)
        case .value(let statevectorCalculationConcurrency):
            let mc = statevectorCalculationConcurrency > 0 ? statevectorCalculationConcurrency : 1

            transformation = try! CSMElementByElementStatevectorTransformation(calculationConcurrency: mc)
        case .direct(let statevectorCalculationConcurrency):
            let stcc = statevectorCalculationConcurrency > 0 ? statevectorCalculationConcurrency : 1

            let filteringFactory = DirectStatevectorFilteringFactoryAdapter()
            let indexingFactory = DirectStatevectorIndexingFactoryAdapter()

            transformation = try! DirectStatevectorTransformation(filteringFactory: filteringFactory,
                                                                  indexingFactory: indexingFactory,
                                                                  calculationConcurrency: stcc)
        }

        return transformation
    }

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
