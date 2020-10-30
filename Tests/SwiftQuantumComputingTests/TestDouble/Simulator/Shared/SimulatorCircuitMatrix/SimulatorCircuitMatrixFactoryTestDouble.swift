//
//  SimulatorCircuitMatrixFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/02/2020.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class SimulatorCircuitMatrixFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeCircuitMatrixCount = 0
    private (set) var lastMakeCircuitMatrixQubitCount: Int?
    private (set) var lastMakeCircuitMatrixBaseMatrix: Matrix?
    private (set) var lastMakeCircuitMatrixInputs: [Int]?
    var makeCircuitMatrixResult: SimulatorCircuitMatrix = SimulatorCircuitMatrixTestDouble()

    private (set) var makeCircuitMatrixRowCount = 0
    private (set) var lastMakeCircuitMatrixRowQubitCount: Int?
    private (set) var lastMakeCircuitMatrixRowBaseMatrix: Matrix?
    private (set) var lastMakeCircuitMatrixRowInputs: [Int]?
    var makeCircuitMatrixRowResult: SimulatorCircuitMatrixRow = SimulatorCircuitMatrixTestDouble()

    private (set) var makeCircuitMatrixElementCount = 0
    private (set) var lastMakeCircuitMatrixElementQubitCount: Int?
    private (set) var lastMakeCircuitMatrixElementBaseMatrix: Matrix?
    private (set) var lastMakeCircuitMatrixElementInputs: [Int]?
    var makeCircuitMatrixElementResult: SimulatorMatrix = SimulatorMatrixTestDouble()
}

// MARK: - SimulatorCircuitMatrixFactory methods

extension SimulatorCircuitMatrixFactoryTestDouble: SimulatorCircuitMatrixFactory {
    func makeCircuitMatrix(qubitCount: Int,
                           baseMatrix: Matrix,
                           inputs: [Int]) -> SimulatorCircuitMatrix {
        makeCircuitMatrixCount += 1

        lastMakeCircuitMatrixQubitCount = qubitCount
        lastMakeCircuitMatrixBaseMatrix = baseMatrix
        lastMakeCircuitMatrixInputs = inputs

        return makeCircuitMatrixResult
    }
}

// MARK: - SimulatorCircuitMatrixRowFactory methods

extension SimulatorCircuitMatrixFactoryTestDouble: SimulatorCircuitMatrixRowFactory {
    func makeCircuitMatrixRow(qubitCount: Int,
                              baseMatrix: Matrix,
                              inputs: [Int]) -> SimulatorCircuitMatrixRow {
        makeCircuitMatrixRowCount += 1

        lastMakeCircuitMatrixRowQubitCount = qubitCount
        lastMakeCircuitMatrixRowBaseMatrix = baseMatrix
        lastMakeCircuitMatrixRowInputs = inputs

        return makeCircuitMatrixRowResult
    }
}

extension SimulatorCircuitMatrixFactoryTestDouble: SimulatorCircuitMatrixElementFactory {
    func makeCircuitMatrixElement(qubitCount: Int,
                                  baseMatrix: Matrix,
                                  inputs: [Int]) -> SimulatorMatrix {
        makeCircuitMatrixElementCount += 1

        lastMakeCircuitMatrixElementQubitCount = qubitCount
        lastMakeCircuitMatrixElementBaseMatrix = baseMatrix
        lastMakeCircuitMatrixElementInputs = inputs

        return makeCircuitMatrixElementResult
    }
}
