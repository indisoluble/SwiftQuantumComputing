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
import os.log

// MARK: - Main body

struct BackendFacade {

    // MARK: - Private properties

    private let initialRegister: BackendRegister
    private let factory: BackendRegisterGateFactory

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(initialRegister: BackendRegister, factory: BackendRegisterGateFactory) {
        self.initialRegister = initialRegister
        self.factory = factory
    }
}

// MARK: - Backend methods

extension BackendFacade: Backend {
    func measureQubits(_ qubits: [Int], in circuit: [BackendGate]) -> [Double]? {
        var iter = circuit.makeIterator()

        var register: BackendRegister? = initialRegister
        var gate = iter.next()

        while let nextRegister = register, let nextGate = gate {
            register = applyGate(nextGate, to: nextRegister)
            gate = iter.next()
        }

        return register?.measure(qubits: qubits)
    }
}

// MARK: - Private body

private extension BackendFacade {

    // MARK: - Private methods

    func applyGate(_ gate: BackendGate, to register: BackendRegister) -> BackendRegister? {
        let (matrix, inputs) = gate.extract()

        guard let registerGate = factory.makeGate(matrix: matrix, inputs: inputs) else {
            os_log("applyGate failed: Unable to build next gate",
                   log: BackendFacade.logger,
                   type: .debug)

            return nil
        }

        guard let nextRegister = register.applying(registerGate) else {
            os_log("applyGate failed: unable to produce next register with new gate",
                   log: BackendFacade.logger,
                   type: .debug)

            return nil
        }

        return nextRegister
    }
}
