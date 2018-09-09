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

    // MARK: - Types

    typealias ExtendedCircuitRegister = (CircuitRegister & CustomStringConvertible)
    typealias ExtendedCircuitDescription = (CircuitDescription & CustomPlaygroundDisplayConvertible)

    // MARK: - Public properties

    let register: ExtendedCircuitRegister
    let factory: CircuitRegisterGateFactory
    let circuitDescription: ExtendedCircuitDescription

    // MARK: - Init methods

    init(register: ExtendedCircuitRegister,
         factory: CircuitRegisterGateFactory,
         circuitDescription: ExtendedCircuitDescription) {
        self.register = register
        self.factory = factory
        self.circuitDescription = circuitDescription
    }
}

// MARK: - CustomStringConvertible methods

extension CircuitFacade: CustomStringConvertible {
    var description: String {
        return register.description
    }
}

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitFacade: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        return circuitDescription.playgroundDescription
    }
}

// MARK: - Circuit methods

extension CircuitFacade: Circuit {
    var qubitCount: Int {
        return register.qubitCount
    }

    func applyingGate(_ gate: CircuitGate, inputs: [Int]) -> CircuitFacade? {
        guard let registerGate = factory.makeGate(matrix: gate.matrix, inputs: inputs) else {
            return nil
        }

        guard let nextRegister = register.applying(registerGate) else {
            return nil
        }

        let nextDescription = circuitDescription.applyingDescriber(gate.describer, inputs: inputs)

        return CircuitFacade(register: nextRegister,
                             factory: factory,
                             circuitDescription: nextDescription)
    }

    func measure(qubits: Int...) -> [Double]? {
        return register.measure(qubits: qubits)
    }
}
