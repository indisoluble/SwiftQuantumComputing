//
//  BackendFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/12/2018.
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

struct BackendFacade {

    // MARK: - Private properties

    private let factory: BackendRegisterGateFactory

    // MARK: - Internal init methods

    init(factory: BackendRegisterGateFactory) {
        self.factory = factory
    }
}

// MARK: - Backend methods

extension BackendFacade: Backend {
    func measure(qubits: [Int], in circuit: Backend.Circuit) throws -> [Double] {
        var register = circuit.register

        for (index, gate) in circuit.gates.enumerated() {
            var components: BackendGate.Components!
            do {
                components = try gate.extract()
            } catch BackendGateExtractError.unableToExtractMatrix {
                throw BackendMeasureError.unableToExtractMatrixFromGate(at: index)
            } catch {
                fatalError("Unexpected error: \(error).")
            }

            var registerGate: RegisterGate!
            do {
                registerGate = try factory.makeGate(matrix: components.matrix,
                                                    inputs: components.inputs)
            } catch BackendRegisterGateFactoryMakeGateError.matrixIsNotSquare {
                throw BackendMeasureError.gateMatrixIsNotSquare(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.matrixRowCountHasToBeAPowerOfTwo {
                throw BackendMeasureError.gateMatrixRowCountHasToBeAPowerOfTwo(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.matrixHandlesMoreQubitsThanAreAvailable {
                throw BackendMeasureError.gateMatrixHandlesMoreQubitsThanAreAvailable(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.inputCountDoesNotMatchMatrixQubitCount {
                throw BackendMeasureError.gateInputCountDoesNotMatchMatrixQubitCount(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.inputsAreNotUnique {
                throw BackendMeasureError.gateInputsAreNotUnique(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.inputsAreNotInBound {
                throw BackendMeasureError.gateInputsAreNotInBound(at: index)
            } catch BackendRegisterGateFactoryMakeGateError.gateIsNotUnitary {
                throw BackendMeasureError.gateIsNotUnitary(at: index)
            } catch {
                fatalError("Unexpected error: \(error).")
            }

            do {
                register = try register.applying(registerGate)
            } catch BackendRegisterApplyingError.gateDoesNotHaveValidDimension {
                throw BackendMeasureError.gateDoesNotHaveValidDimension(at: index)
            } catch BackendRegisterApplyingError.additionOfSquareModulusInNextRegisterIsNotEqualToOne {
                throw BackendMeasureError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(at: index)
            } catch {
                fatalError("Unexpected error: \(error).")
            }
        }

        do {
            return try register.measure(qubits: qubits)
        } catch BackendRegisterMeasureError.emptyQubitList {
            throw BackendMeasureError.emptyQubitList
        } catch BackendRegisterMeasureError.qubitsAreNotUnique {
            throw BackendMeasureError.qubitsAreNotUnique
        } catch BackendRegisterMeasureError.qubitsAreNotInBound {
            throw BackendMeasureError.qubitsAreNotInBound
        } catch BackendRegisterMeasureError.qubitsAreNotSorted {
            throw BackendMeasureError.qubitsAreNotSorted
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
