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

    /// Define behaviour of `Circuit.unitary(withQubitCount:)`
    public enum UnitaryConfiguration {
        /// To produce the unitary `Matrix` that represents the entire circuit, each `Gate` is expanded into a `Matrix`
        /// and multiplied by the unitary `Matrix` calculated so far. Expansion can be done in parallel with up to
        /// `matrixExpansionConcurrency` threads. If `matrixExpansionConcurrency` is set to 1 or less,
        /// the whole process will be serial.
        /// This configuration has the biggest memory footprint
        case fullMatrix(matrixExpansionConcurrency: Int = 1)
        /// To apply a `Gate` to the unitary `Matrix` calculated so far to get the next one, the rows in `Gate` are
        /// expanded only once. Each row can be expanded in parallel using up to `rowExpansionConcurrency`
        /// threads. Then, each row is used to calculare the corresponding row in the next unitary `Matrix`.
        /// Notice that up to `unitaryCalculationConcurrency` new rows can be calculated in parallel which
        /// means that in a given moment there might be `unitaryCalculationConcurrency` *
        /// `rowExpansionConcurrency` threats running simultaneously. If both `unitaryCalculationConcurrency`
        /// and `rowExpansionConcurrency` are set to 1 or less, the whole process will be serial.
        case rowByRow(unitaryCalculationConcurrency: Int = 1, rowExpansionConcurrency: Int = 1)
        /// Each time a `Gate` is applied to the unitary `Matrix` calculated so far to get the next one, the positions in
        /// each`Gate` are requested as needed to calculate each position on the new unitary. This process can be done
        /// in parallel with up to `unitaryCalculationConcurrency` threads.  If `unitaryCalculationConcurrency`
        /// is set to 1 or less, the whole process will be serial.
        case elementByElement(unitaryCalculationConcurrency: Int = 1)
    }

    /// Define behaviour of `Circuit.statevector(withInitialState:)`
    public enum StatevectorConfiguration {
        /// Each `Gate` is expanded into a `Matrix` and applied to the current statevector
        /// to get the next statevector. Expansion can be done in parallel with up to `matrixExpansionConcurrency`
        /// threads. If `matrixExpansionConcurrency` is set to 1 or less, the whole process will be serial.
        /// This configuration has the biggest memory footprint.
        case fullMatrix(matrixExpansionConcurrency: Int = 1)
        /// For each position of the next statevector, the corresponding row of the `Gate` is expanded
        /// and applied as needed. Positions in the next statevector can be calculated in parallel with up to
        /// `statevectorCalculationConcurrency` threads. Also, row  expansion can be done in
        /// parallel too with up to `rowExpansionConcurrency` threads. Therefore, this configuration
        /// uses as much as `statevectorCalculationConcurrency` * `rowExpansionConcurrency`
        /// threads. If both `statevectorCalculationConcurrency` and `rowExpansionConcurrency` are
        /// set to 1 or less, the whole process will be serial.
        case rowByRow(statevectorCalculationConcurrency: Int = 1, rowExpansionConcurrency: Int = 1)
        /// For each position of the next statevector, element by element of the corresponding row
        /// in the `Gate` is calculated (on the fly) and applied as needed. This process can be done in
        /// parallel with up to `statevectorCalculationConcurrency` number of threads.
        /// If `statevectorCalculationConcurrency` is set to 1 or less, the whole process will be serial.
        case elementByElement(statevectorCalculationConcurrency: Int = 1)
        /// Similar to `StatevectorConfiguration.elementByElement` but instead of calculating
        /// (on the fly) all positions in a row, only those that are needed (not zero) are generated. If each gate
        /// only uses a few qubits in the circuit, this is the fastest option and it does not consume more memory
        /// than `StatevectorConfiguration.elementByElement`. This process can be done in
        /// parallel with up to `statevectorCalculationConcurrency` number of threads.
        /// If `statevectorCalculationConcurrency` is set to 1 or less, the whole process will be serial.
        case direct(statevectorCalculationConcurrency: Int = 1)
    }

    /// Define behaviour of `Circuit.densityMatrix(withInitialState:)`
    public enum DensityMatrixConfiguration {
        /// Each `Gate` is expanded into a `Matrix` and applied to the current density matrix
        /// to get the next density matrix. Expansion can be done in parallel with up to `matrixExpansionConcurrency`
        /// threads. If `matrixExpansionConcurrency` is set to 1 or less, the whole process will be serial.
        /// This configuration has the biggest memory footprint.
        case fullMatrix(matrixExpansionConcurrency: Int = 1)
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
    public init(unitaryConfiguration: UnitaryConfiguration = .fullMatrix(),
                statevectorConfiguration: StatevectorConfiguration = .direct(),
                densityMatrixConfiguration: DensityMatrixConfiguration = .fullMatrix()) {
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
        case .fullMatrix(let matrixExpansionConcurrency):
            mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixUnitaryTransformation(matrixExpansionConcurrency: mc)
        case .rowByRow(let unitaryCalculationConcurrency, let rowExpansionConcurrency):
            let ucc = unitaryCalculationConcurrency > 0 ? unitaryCalculationConcurrency : 1
            let rec = rowExpansionConcurrency > 0 ? rowExpansionConcurrency : 1
            mc = rec * ucc

            transformation = try! CSMRowByRowUnitaryTransformation(unitaryCalculationConcurrency: ucc,
                                                                   rowExpansionConcurrency: rec)
        case .elementByElement(let unitaryCalculationConcurrency):
            mc = unitaryCalculationConcurrency > 0 ? unitaryCalculationConcurrency : 1

            transformation = try! CSMElementByElementUnitaryTransformation(unitaryCalculationConcurrency: mc)
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
        case .fullMatrix(let matrixExpansionConcurrency):
            let mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixStatevectorTransformation(expansionConcurrency: mc)
        case .rowByRow(let statevectorCalculationConcurrency, let rowExpansionConcurrency):
            let stcc = statevectorCalculationConcurrency > 0 ? statevectorCalculationConcurrency : 1
            let rec = rowExpansionConcurrency > 0 ? rowExpansionConcurrency : 1

            transformation = try! CSMRowByRowStatevectorTransformation(calculationConcurrency: stcc,
                                                                       expansionConcurrency: rec)
        case .elementByElement(let statevectorCalculationConcurrency):
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
        case .fullMatrix(let matrixExpansionConcurrency):
            let mc = matrixExpansionConcurrency > 0 ? matrixExpansionConcurrency : 1

            transformation = try! CSMFullMatrixDensityMatrixTransformation(expansionConcurrency: mc)
        }

        return transformation
    }
}
