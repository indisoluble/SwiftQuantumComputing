//
//  DirectStatevectorRegister.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/04/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

struct DirectStatevectorRegister {

    // MARK: - Private properties

    let vector: Vector
    let factory: StatevectorRegisterFactory

    // MARK: - Internal init methods

    enum InitError: Error {
        case vectorCountHasToBeAPowerOfTwo
    }

    init(vector: Vector, factory: StatevectorRegisterFactory) throws {
        guard vector.count.isPowerOfTwo else {
            throw InitError.vectorCountHasToBeAPowerOfTwo
        }

        self.vector = vector
        self.factory = factory
    }
}

// MARK: - StatevectorRegister methods

extension DirectStatevectorRegister: StatevectorRegister {
    func statevector() throws -> Vector {
        guard vector.isAdditionOfSquareModulusEqualToOne() else {
            throw StatevectorRegisterError.statevectorAdditionOfSquareModulusIsNotEqualToOne
        }

        return vector
    }

    func applying(_ gate: SimulatorGate) throws -> DirectStatevectorRegister {
        return self
    }
}
