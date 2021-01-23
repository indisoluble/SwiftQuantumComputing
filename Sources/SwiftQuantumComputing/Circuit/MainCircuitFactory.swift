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

    /// Define behaviour of `Circuit.statevector(withInitialStatevector:)`
    public enum StatevectorConfiguration {
        /// Each `Gate` is expanded into a `Matrix` and applied to the current statevector
        /// to get the final statevector. This configuration has the biggest memory footprint
        case fullMatrix
        /// For each position of the next statevector, the corresponding row of the `Gate` is expanded
        /// and applied as needed. This process can be done in parallel with up to `maxConcurrency`
        /// number of threads. If `maxConcurrency` is set to 1 or less, the whole process will be serial.
        case rowByRow(maxConcurrency: Int = 1)
        /// For each position of the next statevector, element by element of the corresponding row
        /// in the `Gate` is calculated (on the fly) and applied as needed. This process can be done in
        /// parallel with up to `maxConcurrency` number of threads. If `maxConcurrency` is set to
        /// 1 or less, the whole process will be serial.
        case elementByElement(maxConcurrency: Int = 1)
        /// Similar to `StatevectorConfiguration.elementByElement` but instead of calculating
        /// (on the fly) all positions in a row, only those that are needed (not zero) are generated. If each gate
        /// only uses a few qubits in the circuit, this is the fastest option and it does not consume more memory
        /// than `StatevectorConfiguration.elementByElement`. This process can be done in
        /// parallel with up to `maxConcurrency` number of threads. If `maxConcurrency` is set to 1 or
        /// less, the whole process will be serial.
        case direct(maxConcurrency: Int = 1)
    }

    // MARK: - Private properties

    private let statevectorConfiguration: StatevectorConfiguration

    // MARK: - Public init methods
 
    /**
     Initialize a `MainCircuitFactory` instance.

     - Parameter statevectorConfiguration: Defines how a statevector is calculated. By default is set to
     `StatevectorConfiguration.direct`, however the performance of each configuration depends on each
     use case. It is recommended to try different configurations so see how long an execution takes and how much
     memory is required.

     - Returns: A`MainCircuitFactory` instance.
     */
    public init(statevectorConfiguration: StatevectorConfiguration = .direct()) {
        self.statevectorConfiguration = statevectorConfiguration
    }
}

// MARK: - CircuitFactory methods

extension MainCircuitFactory: CircuitFactory {

    /// Check `CircuitFactory.makeCircuit(gates:)`
    public func makeCircuit(gates: [Gate]) -> Circuit {
        return CircuitFacade(gates: gates,
                             unitarySimulator: makeUnitarySimulator(),
                             statevectorSimulator: makeStatevectorSimulator())
    }
}

// MARK: - Private body

private extension MainCircuitFactory {

    // MARK: - Private methods

    func makeUnitarySimulator() -> UnitarySimulator {
        let matrixFactory = SimulatorCircuitMatrixFactoryAdapter()
        let unitaryGateFactory = UnitaryGateFactoryAdapter(matrixFactory: matrixFactory)

        return UnitarySimulatorFacade(gateFactory: unitaryGateFactory)
    }

    func makeStatevectorSimulator() -> StatevectorSimulator {
        let transformation = makeStatevectorTransformation()
        let registerFactory = StatevectorRegisterFactoryAdapter(transformation: transformation)

        let statevectorFactory = MainCircuitStatevectorFactory()

        return StatevectorSimulatorFacade(registerFactory: registerFactory,
                                          statevectorFactory: statevectorFactory)
    }

    func makeStatevectorTransformation() -> StatevectorTransformation {
        let transformation: StatevectorTransformation!
        switch statevectorConfiguration {
        case .fullMatrix:
            let matrixFactory = SimulatorCircuitMatrixFactoryAdapter()

            transformation = CircuitMatrixStatevectorTransformation(matrixFactory: matrixFactory)
        case .rowByRow(let maxConcurrency):
            let rowFactory = SimulatorCircuitRowFactoryAdapter()

            transformation = try! CircuitMatrixRowStatevectorTransformation(rowFactory: rowFactory,
                                                                            maxConcurrency: maxConcurrency > 0 ? maxConcurrency : 1)
        case .elementByElement(let maxConcurrency):
            let matrixFactory = SimulatorCircuitMatrixFactoryAdapter()

            transformation = try! CircuitMatrixElementStatevectorTransformation(matrixFactory: matrixFactory,
                                                                                maxConcurrency: maxConcurrency > 0 ? maxConcurrency : 1)
        case .direct(let maxConcurrency):
            let indexTransformationFactory = DirectStatevectorIndexTransformationFactoryAdapter()

            transformation = try! DirectStatevectorTransformation(indexTransformationFactory: indexTransformationFactory,
                                                                  maxConcurrency: maxConcurrency > 0 ? maxConcurrency : 1)
        }

        return transformation
    }
}
