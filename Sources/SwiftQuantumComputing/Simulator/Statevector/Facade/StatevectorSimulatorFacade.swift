//
//  StatevectorSimulatorFacade.swift
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

struct StatevectorSimulatorFacade {

    // MARK: - Private properties

    private let registerFactory: StatevectorRegisterFactory

    // MARK: - Internal init methods

    init(registerFactory: StatevectorRegisterFactory) {
        self.registerFactory = registerFactory
    }
}

// MARK: - StatevectorSimulator methods

extension StatevectorSimulatorFacade: StatevectorSimulator {
    func statevector(afterInputting bits: String, in circuit: [SimulatorGate]) throws -> Vector {
        var register: StatevectorRegister!
        do {
            register = try registerFactory.makeRegister(bits: bits)
        } catch MakeRegisterError.bitsAreNotAStringComposedOnlyOfZerosAndOnes {
            throw StatevectorError.inputBitsAreNotAStringComposedOnlyOfZerosAndOnes
        }

        for gate in circuit {
            do {
                register = try register.applying(gate)
            } catch {
                if let error = error as? GateError {
                    throw StatevectorError.gateThrowedError(gate: gate.fixedGate, error: error)
                } else {
                    fatalError("Unexpected error: \(error).")
                }
            }
        }

        return register.statevector
    }
}
