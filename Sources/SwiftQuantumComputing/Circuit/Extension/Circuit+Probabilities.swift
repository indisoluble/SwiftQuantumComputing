//
//  Circuit+Probabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

/// Errors throwed by `Circuit.probabilities(withInitialBits:)`
public enum ProbabilitiesError: Error {
    /// Throwed if `Circuit.statevector(withInitialBits:)` throws `StatevectorError`
    case statevectorThrowedError(error: StatevectorError)
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probabilities of each possible combinations of qubits.

     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `ProbabilitiesError`.

     - Returns: A list in which each position represents a qubit combination and the value in a position the probability of
     such combination.
     */
    public func probabilities(withInitialBits initialBits: String? = nil) throws -> [Double] {
        var state: Vector!
        do {
            state = try statevector(withInitialBits: initialBits)
        } catch {
            if let error = error as? StatevectorError {
                throw ProbabilitiesError.statevectorThrowedError(error: error)
            } else {
                fatalError("Unexpected error: \(error).")
            }
        }

        return state.map { $0.squaredModulus }
    }
}
