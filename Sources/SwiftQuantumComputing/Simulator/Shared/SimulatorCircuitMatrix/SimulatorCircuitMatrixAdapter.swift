//
//  SimulatorCircuitMatrixAdapter.swift
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

import Foundation

// MARK: - Main body

struct SimulatorCircuitMatrixAdapter {

    // MARK: - Private properties

    private let count: Int
    private let derives: [Int: (base: Int, remaining: Int)]
    private let baseMatrix: Matrix

    // MARK: - Internal init methods

    init(qubitCount: Int, baseMatrix: Matrix, inputs: [Int]) {
        let count = Int.pow(2, qubitCount)
        let remainingInputs = (0..<qubitCount).reversed().filter { !inputs.contains($0) }

        var derives: [Int: (base: Int, remaining: Int)] = [:]
        for value in 0..<count {
            derives[value] = (value.derived(takingBitsAt: inputs),
                              value.derived(takingBitsAt: remainingInputs))
        }

        self.count = count
        self.derives = derives
        self.baseMatrix = baseMatrix
    }
}

// MARK: - SimulatorCircuitMatrix methods

extension SimulatorCircuitMatrixAdapter: SimulatorCircuitMatrix {
    var rawMatrix: Matrix {
        return try! Matrix.makeMatrix(rowCount: count, columnCount: count) { self[$0, $1] }
    }
}

// MARK: - SimulatorCircuitMatrixRow methods

extension SimulatorCircuitMatrixAdapter: SimulatorCircuitMatrixRow {
    subscript(row: Int) -> Vector {
        return try! Vector.makeVector(count: count) { self[row, $0] }
    }
}

// MARK: - SimulatorCircuitMatrixElement methods

extension SimulatorCircuitMatrixAdapter: SimulatorCircuitMatrixElement {
    subscript(row: Int, column: Int) -> Complex {
        let baseRow = derives[row]!.base
        let baseColumn = derives[column]!.base

        let remainingRow = derives[row]!.remaining
        let remainingColumn = derives[column]!.remaining

        return (remainingRow == remainingColumn ? baseMatrix[baseRow, baseColumn] : Complex.zero)
    }
}
