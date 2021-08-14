//
//  StatevectorTimeEvolutionAdapter.swift
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

struct StatevectorTimeEvolutionAdapter {

    // MARK: - StatevectorTimeEvolution properties

    let state: Vector

    // MARK: - Private properties

    private let transformation: StatevectorTransformation

    // MARK: - Internal init methods

    enum InitError: Error {
        case stateCountHasToBeAPowerOfTwo
    }

    init(state: Vector, transformation: StatevectorTransformation) throws {
        guard state.count.isPowerOfTwo else {
            throw InitError.stateCountHasToBeAPowerOfTwo
        }

        self.state = state
        self.transformation = transformation
    }
}

// MARK: - StatevectorTimeEvolution methods

extension StatevectorTimeEvolutionAdapter: StatevectorTimeEvolution {
    func applying(_ gate: Gate) -> Result<StatevectorTimeEvolution, GateError> {
        switch transformation.apply(gate: gate, toStatevector: state) {
        case .success(let nextState):
            let adapter = try! StatevectorTimeEvolutionAdapter(state: nextState,
                                                               transformation: transformation)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
}
