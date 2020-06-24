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

/// Errors throwed by `CircuitStatevectorFactory.makeStatevector(bits:)`.
public enum MakeStatevectorBitsError: Error {
    /// Throwed if `bits` is not composed exclusively of 0's and 1's
    case bitsAreNotAStringComposedOnlyOfZerosAndOnes
}

// MARK: - Main body

extension CircuitStatevectorFactory {

    // MARK: - Public methods

    /**
     Builds `CircuitStatevector` instances.

     - Parameter bits: String composed only of 0's & 1's.

     - Returns: A `CircuitStatevector` instance. Or `MakeStatevectorBitsError` error.
     */
    public func makeStatevector(bits: String) -> Result<CircuitStatevector, MakeStatevectorBitsError> {
        guard let value = Int(bits, radix: 2) else {
            return .failure(.bitsAreNotAStringComposedOnlyOfZerosAndOnes)
        }

        let state = try! Vector.makeState(value: value, qubitCount: bits.count).get()

        return .success(try! makeStatevector(vector: state).get())
    }
}
