//
//  CSMElementByElementUnitaryTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/06/2021.
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

import ComplexModule
import Foundation

// MARK: - Main body

struct CSMElementByElementUnitaryTransformation {

    // MARK: - Private properties

    private let calculationConcurrency: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case calculationConcurrencyHasToBiggerThanZero
    }

    init(calculationConcurrency: Int) throws {
        guard calculationConcurrency > 0 else {
            throw InitError.calculationConcurrencyHasToBiggerThanZero
        }

        self.calculationConcurrency = calculationConcurrency
    }
}

// MARK: - UnitaryTransformation methods

extension CSMElementByElementUnitaryTransformation: UnitaryTransformation {}

// MARK: - CircuitSimulatorMatrixUnitaryTransformation methods

extension CSMElementByElementUnitaryTransformation: CircuitSimulatorMatrixUnitaryTransformation {
    func apply(circuitMatrix: CircuitSimulatorMatrix, toUnitary matrix: Matrix) -> Matrix {
        let count = circuitMatrix.count
        let ucc = calculationConcurrency

        return try! Matrix.makeMatrix(rowCount: count, columnCount: count, maxConcurrency: ucc, value: { row, col in
            var result = Complex<Double>.zero
            for idx in 0..<count {
                result += circuitMatrix[row, idx] * matrix[idx, col]
            }
            return result
        }).get()
    }
}
