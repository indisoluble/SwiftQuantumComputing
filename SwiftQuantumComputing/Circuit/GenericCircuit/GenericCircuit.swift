//
//  GenericCircuit.swift
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

// MARK: - Types

typealias ExtendedCircuitGateFactory = CircuitRegisterGateFactory & Equatable
typealias ExtendedCircuitRegister = CircuitRegister & CustomStringConvertible & Equatable

// MARK: - Main body

struct GenericCircuit <R, F> where R: ExtendedCircuitRegister, F: ExtendedCircuitGateFactory {

    // MARK: - Private properties

    private let register: R
    private let factory: F

    // MARK: - Init methods

    init(register: R, factory: F) {
        self.register = register
        self.factory = factory
    }
}

// MARK: - CustomStringConvertible methods

extension GenericCircuit: CustomStringConvertible {
    var description: String {
        return register.description
    }
}

// MARK: - Equatable methods

extension GenericCircuit: Equatable {
    static func ==(lhs: GenericCircuit, rhs: GenericCircuit) -> Bool {
        return ((lhs.register == rhs.register) && (lhs.factory == rhs.factory))
    }
}

// MARK: - Circuit methods

extension GenericCircuit: Circuit {
    var qubitCount: Int {
        return register.qubitCount
    }

    func applyingGate(_ gate: CircuitGate, inputs: [Int]) -> GenericCircuit? {
        guard let registerGate = factory.makeGate(matrix: gate.matrix, inputs: inputs) else {
            return nil
        }

        guard let nextRegister = register.applying(registerGate) else {
            return nil
        }

        return GenericCircuit(register: nextRegister, factory: factory)
    }

    func measure(qubits: Int...) -> [Double]? {
        return register.measure(qubits: qubits)
    }
}
