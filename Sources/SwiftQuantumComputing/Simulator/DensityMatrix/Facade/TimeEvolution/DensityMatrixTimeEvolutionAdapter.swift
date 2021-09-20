//
//  DensityMatrixTimeEvolutionAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

struct DensityMatrixTimeEvolutionAdapter {

    // MARK: - DensityMatrixTimeEvolution properties

    let state: Matrix

    // MARK: - Private properties

    private let transformation: DensityMatrixTransformation

    // MARK: - Internal init methods

    enum InitError: Error {
        case stateIsNotSquare
    }

    init(state: Matrix, transformation: DensityMatrixTransformation) throws {
        guard state.isSquare else {
            throw InitError.stateIsNotSquare
        }

        self.state = state
        self.transformation = transformation
    }
}

// MARK: - DensityMatrixTimeEvolution methods

extension DensityMatrixTimeEvolutionAdapter: DensityMatrixTimeEvolution {
    func applying(_ quantumOperator: QuantumOperator) -> Result<DensityMatrixTimeEvolution, QuantumOperatorError> {
        switch transformation.apply(quantumOperator: quantumOperator, toDensityMatrix: state) {
        case .success(let nextState):
            let adapter = try! DensityMatrixTimeEvolutionAdapter(state: nextState,
                                                                 transformation: transformation)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
}
