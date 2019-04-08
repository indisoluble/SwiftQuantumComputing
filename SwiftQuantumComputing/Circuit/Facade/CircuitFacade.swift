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
        } catch BackendRegisterFactoryMakeRegisterError.provideNonEmptyStringComposedOnlyOfZerosAndOnes {
            throw CircuitMeasureError.informBitsAsANonEmptyStringComposedOnlyOfZerosAndOnes
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try backend.measure(qubits: qubits, in: (register: register, gates: gates))
        } catch BackendMeasureError.unableToExtractMatrixFromGate(let index) {
            throw CircuitMeasureError.unableToExtractMatrixFromGate(at: index)
        } catch BackendMeasureError.gateMatrixIsNotSquare(let index) {
            throw CircuitMeasureError.gateMatrixIsNotSquare(at: index)
        } catch BackendMeasureError.gateMatrixRowCountHasToBeAPowerOfTwo(let index) {
            throw CircuitMeasureError.gateMatrixRowCountHasToBeAPowerOfTwo(at: index)
        } catch BackendMeasureError.gateMatrixHandlesMoreQubitsThanAreAvailable(let index) {
            throw CircuitMeasureError.gateMatrixHandlesMoreQubitsThanAreAvailable(at: index)
        } catch BackendMeasureError.gateInputCountDoesNotMatchMatrixQubitCount(let index) {
            throw CircuitMeasureError.gateInputCountDoesNotMatchMatrixQubitCount(at: index)
        } catch BackendMeasureError.gateInputsAreNotUnique(let index) {
            throw CircuitMeasureError.gateInputsAreNotUnique(at: index)
        } catch BackendMeasureError.gateInputsAreNotInBound(let index) {
            throw CircuitMeasureError.gateInputsAreNotInBound(at: index)
        } catch BackendMeasureError.gateIsNotUnitary(let index) {
            throw CircuitMeasureError.gateIsNotUnitary(at: index)
        } catch BackendMeasureError.gateDoesNotHaveValidDimension(let index) {
            throw CircuitMeasureError.gateDoesNotHaveValidDimension(at: index)
        } catch BackendMeasureError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(let index) {
            throw CircuitMeasureError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(at: index)
        } catch BackendMeasureError.emptyQubitList {
            throw CircuitMeasureError.emptyQubitList
        } catch BackendMeasureError.qubitsAreNotUnique {
            throw CircuitMeasureError.qubitsAreNotUnique
        } catch BackendMeasureError.qubitsAreNotInBound {
            throw CircuitMeasureError.qubitsAreNotInBound
        } catch BackendMeasureError.qubitsAreNotSorted {
            throw CircuitMeasureError.qubitsAreNotSorted
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
