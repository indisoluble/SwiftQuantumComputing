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
    func apply(circuit: [SimulatorGate], to initialStatevector: Vector) throws -> Vector {
        var register: StatevectorRegister!
        do {
            register = try registerFactory.makeRegister(state: initialStatevector)
        } catch MakeRegisterError.stateCountHasToBeAPowerOfTwo {
            throw StatevectorWithInitialStatevectorError.initialStatevectorCountHasToBeAPowerOfTwo
        } catch MakeRegisterError.stateAdditionOfSquareModulusIsNotEqualToOne {
            throw StatevectorWithInitialStatevectorError.initialStatevectorAdditionOfSquareModulusIsNotEqualToOne
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        for gate in circuit {
            do {
                register = try register.applying(gate)
            } catch let error as GateError {
                throw StatevectorWithInitialStatevectorError.gateThrowedError(gate: gate.gate,
                                                                              error: error)
            } catch {
                fatalError("Unexpected error: \(error).")
            }
        }

        var vector: Vector!
        do {
            vector = try register.statevector()
        } catch StatevectorRegisterError.statevectorAdditionOfSquareModulusIsNotEqualToOne {
            throw StatevectorWithInitialStatevectorError.resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return vector
    }
}
