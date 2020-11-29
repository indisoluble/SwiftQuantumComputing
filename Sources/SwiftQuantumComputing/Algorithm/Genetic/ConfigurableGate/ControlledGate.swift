//
//  ControlledGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/08/2020.
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

/// A quantum gate used on genetic programming: Controlled
public struct ControlledGate {

    // MARK: - Private properties

    private let gate: ConfigurableGate
    private let controlCount: Int

    // MARK: - Public init methods

    /// Errors throwed by `ControlledGate.init(gate:controlCount:)`
    public enum InitError: Error {
        /// Throwed when `controlCount` is 0 or less
        case controlCountHasToBeBiggerThanZero
    }

    /**
     Initializes a `ConfigurableGate` instance with a given `gate`.

     - Parameter gate: Another `ConfigurableGate` instance.
     - Parameter controlCount: Total number of control qubits.

     - Throws: `ControlledGate.InitError`.

     - Returns: A `ConfigurableGate` instance.
     */
    public init(gate: ConfigurableGate, controlCount: Int) throws {
        guard controlCount > 0 else {
            throw InitError.controlCountHasToBeBiggerThanZero
        }

        self.gate = gate
        self.controlCount = controlCount
    }
}

// MARK: - ConfigurableGate methods

extension ControlledGate: ConfigurableGate {

    /// Check `ConfigurableGate.makeFixed(inputs:)`
    public func makeFixed(inputs: [Int]) -> Result<Gate, EvolveCircuitError> {
        switch gate.makeFixed(inputs: inputs) {
        case .success(let fixedGate):
            let reservedInputs = fixedGate.extractRawInputs()
            let remainingInputs = inputs.filter { !reservedInputs.contains($0) }
            guard remainingInputs.count >= controlCount else {
                return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self))
            }

            return .success(.controlled(gate: fixedGate,
                                        controls: Array(remainingInputs[0..<controlCount])))
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self))
        case .failure(.useCaseListIsEmpty),
             .failure(.useCaseMeasurementThrowedError),
             .failure(.useCasesDoNotSpecifySameCircuitQubitCount):
            fatalError("Unexpected error.")
        }
    }
}
