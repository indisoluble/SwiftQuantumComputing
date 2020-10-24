//
//  SimulatorGateTestDouble.swift
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

final class SimulatorGateTestDouble {

    // MARK: - Internal properties

    private (set) var gateCount = 0
    var gateResult = Gate.not(target: 0)

    private (set) var extractComponentsCount = 0
    private (set) var lastExtractComponentsQubitCount: Int?
    var extractComponentsMatrixResult: Matrix?
    var extractComponentsMatrixTypeResult: SimulatorGateMatrixType?
    var extractComponentsInputsResult: [Int]?
    var extractComponentsError = GateError.gateControlsCanNotBeAnEmptyList
}

// MARK: - SimulatorRawGate methods

extension SimulatorGateTestDouble: SimulatorRawGate {
    var gate: Gate {
        gateCount += 1

        return gateResult
    }
}

// MARK: - SimulatorGate methods

extension SimulatorGateTestDouble: SimulatorGate {
    func extractComponents(restrictedToCircuitQubitCount qubitCount: Int) -> Result<Components, GateError> {
        extractComponentsCount += 1

        lastExtractComponentsQubitCount = qubitCount

        if let matrix = extractComponentsMatrixResult,
           let matrixType = extractComponentsMatrixTypeResult,
           let inputs = extractComponentsInputsResult {
            return .success((matrix: matrix, matrixType: matrixType, inputs: inputs))
        }

        return .failure(extractComponentsError)
    }
}
