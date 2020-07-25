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
        /// Throwed when `base` is 0 (or less). First, this implementation only works with a positive `base`. It  also has to be
        /// different from 0 because if `base` is 0, the modulo is always 0 which would end up producing a non-unitary matrix
        case baseHasToBeBiggerThanZero
        /// Throwed if `inputs` is an empty list
        case inputsCanNotBeAnEmptyList
        /// Throwed when `modulus` is 1 (or less). First, this implementation only works with a positive `modulus`. It also
        /// has to be different from 0 because we can not divide by 0. And it can not be 1 because, regardless of `base`, the
        /// modulo of 1 is always 0 which would end up producing a non-unitary matrix
        case modulusHasToBeBiggerThanOne
        /// Throwed if it was not possible to build a unitary matrix with the provided `modulus`, most likely because
        /// `modulus` is a power of `base`
        case modulusProducesANonUnitaryMatrix
    }

    /**
     Implements with `Gate` instances a modular exponentiation performed over `modulus` with `base` raised to `exponent`.
     While `base` & `modulus` are constant integers, `exponent` is a list of qubits and, therefore, its actual value can vary.
     The extra `inputs` are used to pass the result from one gate to the next and they HAVE TO be set to |1>.

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

     - Returns: List of `Gate` instances that code a modular exponentiation. Or `MakeModularExponentiationError` error.
     */
    public static func makeModularExponentiation(base: Int,
                                                 modulus: Int,
                                                 exponent: [Int],
                                                 inputs: [Int]) -> Result<[Gate], MakeModularExponentiationError> {
        guard base > 0 else {
            return .failure(.baseHasToBeBiggerThanZero)
        }

        guard modulus > 1 else {
            return .failure(.modulusHasToBeBiggerThanOne)
        }

        guard !inputs.isEmpty else {
            return .failure(.inputsCanNotBeAnEmptyList)
        }

        // As all components are positive, all `DivisionType` returns same value
        var gateBase = base % modulus

        var gates: [Gate] = []
        for control in exponent.reversed() {
            switch makeModularMultiplicationUnitaryMatrix(base: gateBase,
                                                          modulus: modulus,
                                                          inputQubitCount: inputs.count) {
            case .success(let matrix):
                gates.append(.controlledMatrix(matrix: matrix, inputs: inputs, control: control))
            case .failure(let error):
                return .failure(error)
            }

            gateBase = (gateBase * gateBase) % modulus
        }

        return .success(gates)
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private class methods

    static func makeModularMultiplicationUnitaryMatrix(base: Int,
                                                       modulus: Int,
                                                       inputQubitCount: Int) -> Result<Matrix, MakeModularExponentiationError> {
        let combCount = Int.pow(2, inputQubitCount)
        let activatedIndexes = (0..<combCount).lazy.map { comb in
            // A `comb` bigger or equal to `modulus` produces a `remainder` already generated
            // in a previous iteration. If we used this `remainder`, the resulting matrix
            // would not be unitary; instead, we use the `comb` given that it is always unique
            return (comb >= modulus ? comb : (comb * base) % modulus)
        }

        if Set(activatedIndexes).count != combCount {
            return .failure(.modulusProducesANonUnitaryMatrix)
        }

        let matrix = try! Matrix.makeMatrix(rowCount: combCount, columnCount: combCount, value: { row, col in
            return (activatedIndexes[col] == row ? .one : .zero)
        }).get()

        return .success(matrix)
    }
}
