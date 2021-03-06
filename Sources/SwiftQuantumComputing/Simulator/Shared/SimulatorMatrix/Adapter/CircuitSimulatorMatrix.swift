//
//  CircuitSimulatorMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/05/2020.
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

import ComplexModule
import Foundation

// MARK: - Main body

struct CircuitSimulatorMatrix {

    // MARK: - MatrixCountable properties

    let count: Int

    // MARK: - Private properties

    private let baseMatrix: SimulatorMatrix
    private let stateEquivalences: [(baseIndex: Int, remainingState: Int)]

    // MARK: - Internal init methods

    init(qubitCount: Int, baseMatrix: SimulatorMatrix, inputs: [Int]) {
        var rearranger: [BitwiseShift] = []
        var selectedBitMask = 0
        for (destination, origin) in inputs.reversed().enumerated() {
            let action = BitwiseShift(origin: origin, destination: destination)

            rearranger.append(action)

            selectedBitMask |= action.selectMask
        }

        let count = Int.pow(2, qubitCount)
        let unselectedBitMask = ~selectedBitMask
        let stateEquivalences = (0..<count).lazy.map { state in
            return (rearranger.rearrangeBits(in: state), state & unselectedBitMask)
        }

        self.stateEquivalences = Array(stateEquivalences)
        self.baseMatrix = baseMatrix
        self.count = count
    }
}

// MARK: - MatrixCountable methods

extension CircuitSimulatorMatrix: MatrixCountable {}

// MARK: - SimulatorMatrix methods

extension CircuitSimulatorMatrix: SimulatorMatrix {
    subscript(row: Int, column: Int) -> Complex<Double> {
        let (baseRow, remainingRow) = stateEquivalences[row]
        let (baseColumn, remainingColumn) = stateEquivalences[column]

        return (remainingRow == remainingColumn ? baseMatrix[baseRow, baseColumn] : Complex.zero)
    }
}
