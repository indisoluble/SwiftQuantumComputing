//
//  StatevectorRegisterTestDouble.swift
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

final class StatevectorRegisterTestDouble {

    // MARK: - Internal properties

    private (set) var statevectorCount = 0
    var statevectorResult: Vector?
    var statevectorError = StatevectorMeasurementError.statevectorAdditionOfSquareModulusIsNotEqualToOne

    private (set) var simulatorApplyingCount = 0
    private (set) var lastSimulatorApplyingGate: SimulatorGate?
    var simulatorApplyingResult: StatevectorRegisterTestDouble?
    var simulatorApplyingError = GateError.resultingMatrixIsNotUnitaryAfterApplyingGateToUnitary
}

// MARK: - StatevectorMeasurement methods

extension StatevectorRegisterTestDouble: StatevectorMeasurement {
    func statevector() throws -> Vector {
        statevectorCount += 1

        if let statevectorResult = statevectorResult {
            return statevectorResult
        }

        throw statevectorError
    }
}

// MARK: - SimulatorTransformation methods

extension StatevectorRegisterTestDouble: SimulatorTransformation {
    func applying(_ gate: SimulatorGate) throws -> StatevectorRegisterTestDouble {
        simulatorApplyingCount += 1

        lastSimulatorApplyingGate = gate

        if let applyingResult = simulatorApplyingResult {
            return applyingResult
        }

        throw simulatorApplyingError
    }
}
