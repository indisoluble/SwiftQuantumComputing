//
//  Gate+ModularExponentiationWithRangeExponentsAndInputs.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/03/2020.
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

extension Gate {

    // MARK: - Public class methods

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: Range<Int>,
                                                 inputs: [Int]) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: inputs)
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: ClosedRange<Int>,
                                                 inputs: [Int]) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: inputs)
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: [Int],
                                                 inputs: Range<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: exponent,
                                         inputs: Array(inputs))
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: [Int],
                                                 inputs: ClosedRange<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: exponent,
                                         inputs: Array(inputs))
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: Range<Int>,
                                                 inputs: Range<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: Array(inputs))
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: Range<Int>,
                                                 inputs: ClosedRange<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: Array(inputs))
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: ClosedRange<Int>,
                                                 inputs: Range<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: Array(inputs))
    }

    /// Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: ClosedRange<Int>,
                                                 inputs: ClosedRange<Int>) -> Result<[Gate], MakeModularExponentiationError> {
        return makeModularExponentiation(base: base,
                                         modulus: modulus,
                                         exponent: Array(exponent),
                                         inputs: Array(inputs))
    }
}
