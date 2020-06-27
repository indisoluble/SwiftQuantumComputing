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
        /// Each `Gate` is not expanded into a `Matrix` and applied, as a all, to the current statevector.
        /// Instead, for each position of the next statevector, the corresponding row of the `Gate` is expanded
        /// and applied as needed
        case rowByRow
        /// Each `Gate` is not expanded into a `Matrix` and applied, as a all, to the current statevector.
        /// Instead, for each position of the next statevector, element by element of the corresponding row
        /// in the `Gate` is calculated (on the fly) and applied as needed
        case elementByElement
    }

    // MARK: - Private properties

    private let statevectorConfiguration: StatevectorConfiguration

    // MARK: - Public init methods
 
    /**
     Initialize a `MainCircuitFactory` instance.

     - Parameter statevectorConfiguration: Defines how a statevector is calculated. By default is set to
     `StatevectorConfiguration.elementByElement`, however the performance of each configuration
     depends on each use case. It is recommended to try different configurations so see how long an execution takes and
     how much memory is required.

     - Returns: A`MainCircuitFactory` instance.
     */
    public init(statevectorConfiguration: StatevectorConfiguration = .elementByElement) {
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
        let baseTransformation = makeBaseStatevectorTransformation()
        let directTransformation = DirectStatevectorTransformation(transformation: baseTransformation)
        let registerFactory = StatevectorRegisterFactoryAdapter(transformation: directTransformation)

        let statevectorFactory = MainCircuitStatevectorFactory()

        return StatevectorSimulatorFacade(registerFactory: registerFactory,
                                          statevectorFactory: statevectorFactory)
    }

    func makeBaseStatevectorTransformation() -> StatevectorTransformation {
        let matrixFactory = SimulatorCircuitMatrixFactoryAdapter()

        var transformation: StatevectorTransformation!
        switch statevectorConfiguration {
        case .fullMatrix:
            transformation = CircuitMatrixStatevectorTransformation(matrixFactory: matrixFactory)
        case .rowByRow:
            transformation = CircuitMatrixRowStatevectorTransformation(matrixFactory: matrixFactory)
        case .elementByElement:
            transformation = CircuitMatrixElementStatevectorTransformation(matrixFactory: matrixFactory)
        }

        return transformation
    }
}
