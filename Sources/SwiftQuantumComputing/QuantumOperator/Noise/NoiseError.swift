//
//  NoiseError.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/09/2021.
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

// MARK: - Errors

/// Errors throwed  while acting on a `Noise` operator in a `NoiseCircuit`
public enum NoiseError: Error, Hashable {
    /// Throwed if any matrix in the noise operator is not square
    case noiseMatricesAreNotSquare
    /// Throwed when noise operator has not `matrices`
    case noiseMatricesCanNotBeAnEmptyList
    /// Throwed if any matrix in the noise operator does not have the same number of rows that the others
    case noiseMatricesDoNotHaveSameRowCount
    /// Throwed when addition of adjointed noise matrices by themselves is not equal to identity matrix
    case noiseMatricesDoNotSatisfyIdentity
    /// Throwed when the number of rows in any matrix used to build a noise operator is not a power of 2
    case noiseMatricesRowCountHasToBeAPowerOfTwo
}
