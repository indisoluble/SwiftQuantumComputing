//
//  StatevectorRegisterAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

struct StatevectorRegisterAdapter {

    // MARK: - StatevectorRegister properties

    var statevector: Vector {
        return register.statevector
    }

    // MARK: - Private properties

    private let register: QuantumRegister
    private let gateFactory: SimulatorQuantumGateFactory

    // MARK: - Internal init methods

    init(register: QuantumRegister, gateFactory: SimulatorQuantumGateFactory) {
        self.register = register
        self.gateFactory = gateFactory
    }
}

// MARK: - StatevectorRegister methods

extension StatevectorRegisterAdapter: StatevectorRegister {
    func applying(_ gate: SimulatorGate) throws -> StatevectorRegisterAdapter {
        let components = try gate.extract()

        let registerGate = try gateFactory.makeGate(qubitCount: register.qubitCount,
                                                    matrix: components.matrix,
                                                    inputs: components.inputs)
        let nextRegister = try register.applying(registerGate)

        return StatevectorRegisterAdapter(register: nextRegister, gateFactory: gateFactory)
    }
}
