//
//  CircuitFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

struct CircuitFacade {

    // MARK: - Private properties

    private let gates: [FixedGate]
    private let drawer: Drawable
    private let backend: Backend
    private let factory: BackendRegisterFactory

    // MARK: - Internal init methods

    init(gates: [FixedGate], drawer: Drawable, backend: Backend, factory: BackendRegisterFactory) {
        self.gates = gates
        self.drawer = drawer
        self.backend = backend
        self.factory = factory
    }
}

// MARK: - CustomStringConvertible methods

extension CircuitFacade: CustomStringConvertible {
    var description: String {
        return gates.description
    }
}

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitFacade: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        return drawer.drawCircuit(gates)
    }
}

// MARK: - Circuit methods

extension CircuitFacade: Circuit {
    func measure(qubits: [Int], afterInputting bits: String) throws -> [Double] {
        var register: BackendRegister!
        do {
            register = try factory.makeRegister(bits: bits)
        } catch BackendRegisterFactoryError.provideNonEmptyStringComposedOnlyOfZerosAndOnes {
            throw CircuitError.informBitsAsANonEmptyStringComposedOnlyOfZerosAndOnes
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try backend.measure(qubits: qubits, in: (register: register, gates: gates))
        } catch BackendError.unableToExtractMatrixFromGate(let index) {
            throw CircuitError.unableToExtractMatrixFromGate(at: index)
        } catch BackendError.gateMatrixIsNotSquare(let index) {
            throw CircuitError.gateMatrixIsNotSquare(at: index)
        } catch BackendError.gateMatrixRowCountHasToBeAPowerOfTwo(let index) {
            throw CircuitError.gateMatrixRowCountHasToBeAPowerOfTwo(at: index)
        } catch BackendError.gateMatrixHandlesMoreQubitsThanAreAvailable(let index) {
            throw CircuitError.gateMatrixHandlesMoreQubitsThanAreAvailable(at: index)
        } catch BackendError.gateInputCountDoesNotMatchMatrixQubitCount(let index) {
            throw CircuitError.gateInputCountDoesNotMatchMatrixQubitCount(at: index)
        } catch BackendError.gateInputsAreNotUnique(let index) {
            throw CircuitError.gateInputsAreNotUnique(at: index)
        } catch BackendError.gateInputsAreNotInBound(let index) {
            throw CircuitError.gateInputsAreNotInBound(at: index)
        } catch BackendError.gateIsNotUnitary(let index) {
            throw CircuitError.gateIsNotUnitary(at: index)
        } catch BackendError.gateDoesNotHaveValidDimension(let index) {
            throw CircuitError.gateDoesNotHaveValidDimension(at: index)
        } catch BackendError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(let index) {
            throw CircuitError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(at: index)
        } catch BackendError.emptyQubitList {
            throw CircuitError.emptyQubitList
        } catch BackendError.qubitsAreNotUnique {
            throw CircuitError.qubitsAreNotUnique
        } catch BackendError.qubitsAreNotInBound {
            throw CircuitError.qubitsAreNotInBound
        } catch BackendError.qubitsAreNotSorted {
            throw CircuitError.qubitsAreNotSorted
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
