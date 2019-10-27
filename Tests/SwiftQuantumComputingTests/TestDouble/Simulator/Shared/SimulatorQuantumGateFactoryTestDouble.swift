//
//  SimulatorQuantumGateFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/12/2018.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class SimulatorQuantumGateFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeGateCount = 0
    private (set) var lastMakeGateQubitCount: Int?
    private (set) var lastMakeGateMatrix: Matrix?
    private (set) var lastMakeGateInputs: [Int]?
    var makeGateResult: QuantumGate?
    var makeGateError = GateError.gateMatrixIsNotUnitary
}

// MARK: - SimulatorQuantumGateFactory methods

extension SimulatorQuantumGateFactoryTestDouble: SimulatorQuantumGateFactory {
    func makeGate(qubitCount: Int, matrix: Matrix, inputs: [Int]) throws -> QuantumGate {
        makeGateCount += 1

        lastMakeGateQubitCount = qubitCount
        lastMakeGateMatrix = matrix
        lastMakeGateInputs = inputs

        if let makeGateResult = makeGateResult {
            return makeGateResult
        }

        throw makeGateError
    }
}
