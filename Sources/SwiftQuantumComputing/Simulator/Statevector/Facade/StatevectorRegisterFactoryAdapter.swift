//
//  StatevectorRegisterFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/05/2020.
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

struct StatevectorRegisterFactoryAdapter {

    // MARK: - Private properties

    private let transformation: StatevectorTransformation

    // MARK: - Internal init methods

    init(transformation: StatevectorTransformation) {
        self.transformation = transformation
    }
}

// MARK: - StatevectorRegisterFactory methods

extension StatevectorRegisterFactoryAdapter: StatevectorRegisterFactory {
    func makeRegister(state: Vector) -> Result<StatevectorRegister, MakeRegisterError> {
        var register: StatevectorRegisterAdapter!
        do {
            register = try StatevectorRegisterAdapter(vector: state, transformation: transformation)
        } catch StatevectorRegisterAdapter.InitError.vectorCountHasToBeAPowerOfTwo {
            return .failure(.stateCountHasToBeAPowerOfTwo)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        switch register.statevector() {
        case .success:
            return .success(register)
        case .failure(.statevectorAdditionOfSquareModulusIsNotEqualToOne):
            return .failure(.stateAdditionOfSquareModulusIsNotEqualToOne)
        }
    }
}
