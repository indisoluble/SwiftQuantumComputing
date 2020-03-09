//
//  Gate+ModularExponentiation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/03/2020.
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

    /// Errors throwed by `Gate.makeModularExponentiation(base:modulus:exponent:inputs:)`
    public enum MakeModularExponentiationError: Error {
        /// Throwed when `base` is 0 (or less)
        case baseHasToBeBiggerThanZero
        /// Throwed if `inputs` is an empty list
        case inputsCanNotBeAnEmptyList
        /// Throwed when `modulus` is 0 (or less)
        case modulusHasToBeBiggerThanZero
    }

    /**
     Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`.
     While `base` & `modulus` are constant integers, `exponent` is a list of qubits and, therefore, its actual value can vary.
     The extra `inputs` are used to pass the result from one gate to the next and they are expected to be set to |1>.

     - Parameter base: Base of the modular exponentiation, a positive integer bigger than zero.
     - Parameter modulus: Modulus of the modular exponentiation, a positive integer bigger than zero..
     - Parameter exponent: List of qubits that defines the exponent of the modular exponentiation. For example, if `exponent`
     is equal to [2, 1, 0] and qubit[2]=1, qubit[1]=1 & qubit[0]=0, the actual value of the exponent is '110'=6. Notice that
     If `exponent` was reveresed (i.e. [0, 1, 2]), the actual of the exponent would be '011'=3.
     - Parameter inputs: List of qubits used to pass the result from one gate to the next. Notice that, because this is a modulo,
     you have to provide at least enough input qubits to code `modulus` values (from 0 to `modulus` - 1). Also, in order to get the
     expected result at the end of the list of `Gate` instances, the input qubits have to be set to |1>. For example, if `inputs`
     are equal to [2, 1, 0], qubit[2] and qubit[1] have to be 0 and qubit[0] has to be 1. On the other hand, if `inputs` were
     [0, 1, 2], qubit[0] and qubit[1] should be 0 and qubit[2] should be 1.

     - Throws: `MakeModularExponentiationError`.

     - Returns: List of `Gate` instances that code a modular exponentiation.
     */
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: [Int],
                                                 inputs: [Int]) throws -> [Gate] {
        guard base > 0 else {
            throw MakeModularExponentiationError.baseHasToBeBiggerThanZero
        }

        guard modulus > 0 else {
            throw MakeModularExponentiationError.modulusHasToBeBiggerThanZero
        }

        guard !inputs.isEmpty else {
            throw MakeModularExponentiationError.inputsCanNotBeAnEmptyList
        }

        // As all components are positive, all `DivisionType` returns same value
        var gateBase = base.remainder(dividingBy: modulus, division: .roundedToNearest)

        var gates: [Gate] = []
        for control in exponent.reversed() {
            let matrix = makeModularMultiplicationUnitaryMatrix(base: gateBase,
                                                                modulus: modulus,
                                                                inputQubitCount: inputs.count)
            gates.append(.controlledMatrix(matrix: matrix, inputs: inputs, control: control))

            gateBase = (gateBase * gateBase).remainder(dividingBy: modulus,
                                                       division: .roundedToNearest)
        }

        return gates
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private class methods

    static func makeModularMultiplicationUnitaryMatrix(base: Int,
                                                       modulus: Int,
                                                       inputQubitCount: Int) -> Matrix {
        var rows: [[Complex]] = []

        let combinationCount = Int.pow(2, inputQubitCount)
        for combination in 0..<combinationCount {
            // A `combination` bigger or equal to `modulus` produces a `remainder` already
            // generated in a previous iteration. If we used this `remainder`, the resulting
            // matrix would not be unitary; instead, we use the `combination` given that
            // it is always unique
            let index = (
                combination >= modulus ?
                combination :
                (combination * base).remainder(dividingBy: modulus, division: .roundedToNearest)
            )

            var row = Array(repeating: Complex.zero, count: combinationCount)
            row[index] = Complex.one

            rows.append(row)
        }

        return try! Matrix(rows)
    }
}
