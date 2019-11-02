//
//  Circuit+StatevectorWithInitialBits.swift
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

public enum StatevectorWithInitialBitsError: Error {
    case initialBitsAreNotAStringComposedOnlyOfZerosAndOnes
    case gateThrowedError(gate: FixedGate, error: GateError)
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func statevector(withInitialBits initialBits: String) throws -> Vector {
        guard let value = Int(initialBits, radix: 2) else {
            throw StatevectorWithInitialBitsError.initialBitsAreNotAStringComposedOnlyOfZerosAndOnes
        }

        let initialStatevector = Self.makeState(value: value, qubitCount: initialBits.count)

        do {
            return try statevector(withInitialStatevector: initialStatevector)
        } catch {
            if let error = error as? StatevectorError {
                switch error {
                case .gateThrowedError(let gate, let gateError):
                    throw StatevectorWithInitialBitsError.gateThrowedError(gate: gate,
                                                                           error: gateError)
                default:
                    fatalError("Unexpected error: \(error).")
                }
            } else {
                fatalError("Unexpected error: \(error).")
            }
        }
    }
}

// MARK: - Private body

private extension Circuit {

    // MARK: - Private class methods

    static func makeState(value: Int, qubitCount: Int) -> Vector {
        let count = Int.pow(2, qubitCount)

        var elements = Array(repeating: Complex(0), count: count)
        elements[value] = Complex(1)

        return try! Vector(elements)
    }
}
