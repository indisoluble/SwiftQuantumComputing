//
//  CircuitStatevectorFactory+Bits.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/06/2020.
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

enum MakeStatevectorBitsError: Error {
    case bitsAreNotAStringComposedOnlyOfZerosAndOnes
}

// MARK: - Main body

extension CircuitStatevectorFactory {

    // MARK: - Internal methods

    func makeStatevector(bits: String) -> Result<CircuitStatevector, MakeStatevectorBitsError> {
        guard let value = Int(bits, radix: 2) else {
            return .failure(.bitsAreNotAStringComposedOnlyOfZerosAndOnes)
        }

        let state = Self.makeState(value: value, qubitCount: bits.count)

        return .success(try! makeStatevector(vector: state).get())
    }
}

// MARK: - Private body

private extension CircuitStatevectorFactory {

    // MARK: - Private class methods

    static func makeState(value: Int, qubitCount: Int) -> Vector {
        let count = Int.pow(2, qubitCount)

        var elements = Array(repeating: Complex.zero, count: count)
        elements[value] = Complex.one

        return try! Vector(elements)
    }
}
