//
//  CircuitStatevectorFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/06/2020.
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

// MARK: - Errors

/// Errors throwed by `CircuitStatevectorFactory.makeStatevector(vector:)`
public enum MakeStatevectorError: Error {
    /// Throwed when `vector` is not valid
    case vectorAdditionOfSquareModulusIsNotEqualToOne
    /// Throwed when the length of `vector` is not a power of 2. An `vector` represents all possible qubit combinations,
    /// this is (qubitCount)^2
    case vectorCountHasToBeAPowerOfTwo
}

// MARK: - Protocol definition

/// Factory to build `CircuitStatevector` instances
public protocol CircuitStatevectorFactory {

    /**
     Builds `CircuitStatevector` instances.

     - Parameter vector: State of a quantum circuit expressed as a `Vector`.

     - Returns: A `CircuitStatevector` instance. Or `MakeStatevectorError` error.
     */
    func makeStatevector(vector: Vector) -> Result<CircuitStatevector, MakeStatevectorError>
}
