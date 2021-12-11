//
//  CircuitProbabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/12/2021.
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

// MARK: - Protocol definition

/// Probabilities of each possible combinations of qubits
public protocol CircuitProbabilities {

    /**
     Returns the probabilities of each possible combinations of qubits.

     - Returns: A list in which each position represents a qubit combination and the value in a position the probability of
     such combination.
     */
    func probabilities() -> [Double]
}

// MARK: - CircuitProbabilities default implementations

extension CircuitProbabilities where Self: CircuitStatevector {
    /// Check `CircuitProbabilities.probabilities()`
    func probabilities() -> [Double] {
        return statevector.map { $0.lengthSquared }
    }
}

extension CircuitProbabilities where Self: CircuitDensityMatrix {
    /// Check `CircuitProbabilities.probabilities()`
    func probabilities() -> [Double] {
        return (0..<densityMatrix.rowCount).lazy.map { densityMatrix[$0, $0].length }
    }
}
