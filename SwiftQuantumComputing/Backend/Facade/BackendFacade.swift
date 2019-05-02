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

    private let registerFactory: BackendRegisterFactory
    private let gateFactory: BackendRegisterGateFactory

    // MARK: - Internal init methods

    init(registerFactory: BackendRegisterFactory, gateFactory: BackendRegisterGateFactory) {
        self.registerFactory = registerFactory
        self.gateFactory = gateFactory
    }
}

// MARK: - Backend methods

extension BackendFacade: Backend {
    func measure(qubits: [Int], in circuit: Backend.Circuit) throws -> [Double] {
        var register: BackendRegister!
        do {
            register = try registerFactory.makeRegister(bits: circuit.inputBits)
        } catch MakeRegisterError.bitsAreNotAStringComposedOnlyOfZerosAndOnes {
            throw MeasureError.inputBitsAreNotAStringComposedOnlyOfZerosAndOnes
        }

        for gate in circuit.gates {
            do {
                let components = try gate.extract()
                let registerGate = try gateFactory.makeGate(matrix: components.matrix,
                                                            inputs: components.inputs)
                register = try register.applying(registerGate)
            } catch {
                if let error = error as? GateError {
                    throw MeasureError.gateThrowedError(gate: gate.fixedGate, error: error)
                } else {
                    fatalError("Unexpected error: \(error).")
                }
            }
        }

        return try register.measure(qubits: qubits)
    }
}
