//
//  Circuit+Statevector.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/11/2019.
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

/// Errors throwed by `Circuit.statevector(withInitialBits:)`
public enum StatevectorError: Error {
    /// Throwed if `gate` throws `error`
    case gateThrowedError(gate: Gate, error: GateError)
    /// Throwed when `initialBits` is not composed only of 0's & 1's
    case initialBitsAreNotAStringComposedOnlyOfZerosAndOnes
    /// Throwed when the resulting state vector lost too much precision after applying `gates`
    case resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probabilities of each possible combinations of qubits.

     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `StatevectorError`.

     - Returns: A statevector, result of applying `gates` to `initialBits`.
     */
    public func statevector(withInitialBits initialBits: String? = nil) throws -> Vector {
        guard let value = Int(initialBits ?? "0", radix: 2) else {
            throw StatevectorError.initialBitsAreNotAStringComposedOnlyOfZerosAndOnes
        }
        let qubitCount = (initialBits?.count ?? gates.qubitCount())

        let initialStatevector = Self.makeState(value: value, qubitCount: qubitCount)

        do {
            return try statevector(withInitialStatevector: initialStatevector)
        } catch StatevectorWithInitialStatevectorError.gateThrowedError(let gate, let gateError) {
            throw StatevectorError.gateThrowedError(gate: gate, error: gateError)
        } catch StatevectorWithInitialStatevectorError.resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne {
            throw StatevectorError.resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}

// MARK: - Private body

private extension Circuit {

    // MARK: - Private class methods

    static func makeState(value: Int, qubitCount: Int) -> Vector {
        let count = Int.pow(2, qubitCount)

        var elements = Array(repeating: Complex.zero, count: count)
        elements[value] = Complex.one

        return try! Vector(elements)
    }
}
