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

    private let factory: BackendRegisterGateFactory

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(factory: BackendRegisterGateFactory) {
        self.factory = factory
    }
}

// MARK: - Backend methods

extension BackendFacade: Backend {
    func measure(qubits: [Int], in circuit: Backend.Circuit) -> [Double]? {
        var gatesIterator = circuit.gates.makeIterator()

        var register: BackendRegister? = circuit.register
        var gate = gatesIterator.next()

        while let nextRegister = register, let nextGate = gate {
            register = applyGate(nextGate, to: nextRegister)
            gate = gatesIterator.next()
        }

        return try? register?.measure(qubits: qubits)
    }
}

// MARK: - Private body

private extension BackendFacade {

    // MARK: - Private methods

    func applyGate(_ gate: BackendGate, to register: BackendRegister) -> BackendRegister? {
        guard let (matrix, inputs) = try? gate.extract() else {
            os_log("applyGate failed: gate did not produce a matrix",
                   log: BackendFacade.logger,
                   type: .debug)

            return nil
        }

        guard let registerGate = factory.makeGate(matrix: matrix, inputs: inputs) else {
            os_log("applyGate failed: unable to build next gate",
                   log: BackendFacade.logger,
                   type: .debug)

            return nil
        }

        guard let nextRegister = try? register.applying(registerGate) else {
            os_log("applyGate failed: unable to produce next register with new gate",
                   log: BackendFacade.logger,
                   type: .debug)

            return nil
        }

        return nextRegister
    }
}
