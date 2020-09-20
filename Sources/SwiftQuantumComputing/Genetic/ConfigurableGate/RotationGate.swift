//
//  RotationGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/09/2020.
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

/// A quantum gate used on genetic programming: Rotation
public struct RotationGate {

    // MARK: - Private properties

    private let axis: Gate.Axis
    private let radians: Double

    // MARK: - Public init methods

    /**
     Initializes a `ConfigurableGate` instance with a rotation of `radians` around `axis`.

     - Parameter axis: Rotation will happen around this axis.
     - Parameter radians: Rotation in radians.

     - Returns: A `ConfigurableGate` instance.
     */
    public init(axis: Gate.Axis, radians: Double) {
        self.axis = axis
        self.radians = radians
    }
}

// MARK: - ConfigurableGate methods

extension RotationGate: ConfigurableGate {

    /// Check `ConfigurableGate.makeFixed(inputs:)`
    public func makeFixed(inputs: [Int]) -> Result<Gate, EvolveCircuitError> {
        guard let target = inputs.first else {
            return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self))
        }

        return .success(.rotation(axis: axis, radians: radians, target: target))
    }
}
