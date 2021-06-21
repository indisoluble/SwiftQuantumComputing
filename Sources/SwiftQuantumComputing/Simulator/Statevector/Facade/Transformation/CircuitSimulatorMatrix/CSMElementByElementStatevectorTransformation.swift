//
//  CSMElementByElementStatevectorTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/05/2020.
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

struct CSMElementByElementStatevectorTransformation {

    // MARK: - Private properties

    private let statevectorCalculationConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case statevectorCalculationConcurrencyHasToBiggerThanZero
    }

    init(statevectorCalculationConcurrency: Int) throws {
        guard statevectorCalculationConcurrency > 0 else {
            throw InitError.statevectorCalculationConcurrencyHasToBiggerThanZero
        }

        self.statevectorCalculationConcurrency = statevectorCalculationConcurrency
    }
}

// MARK: - StatevectorTransformation methods

extension CSMElementByElementStatevectorTransformation: StatevectorTransformation {}

// MARK: - CircuitSimulatorMatrixStatevectorTransformation methods

extension CSMElementByElementStatevectorTransformation: CircuitSimulatorMatrixStatevectorTransformation {
    func apply(matrix: CircuitSimulatorMatrix, toStatevector vector: Vector) -> Vector {
        let stcc = statevectorCalculationConcurrency

        return try! Vector.makeVector(count: vector.count, maxConcurrency: stcc, value: { idx in
            return vector.enumerated().reduce(.zero) { acc, val in
                return acc + val.element * matrix[idx, val.offset]
            }
        }).get()
    }
}
