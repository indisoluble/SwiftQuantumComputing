//
//  UnitaryGateTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

final class UnitaryGateTestDouble {

    // MARK: - Internal properties

    private (set) var unitaryCount = 0
    var unitaryResult: Matrix?
    var unitaryError = UnitaryMatrixError.matrixIsNotUnitary

    private (set) var applyingCount = 0
    private (set) var lastApplyingGate: SimulatorGate?
    var applyingResult: UnitaryGateTestDouble?
    var applyingError = GateError.resultingMatrixIsNotUnitaryAfterApplyingGateToUnitary
}

// MARK: - UnitaryMatrix methods

extension UnitaryGateTestDouble: UnitaryMatrix {
    func unitary() -> Result<Matrix, UnitaryMatrixError> {
        unitaryCount += 1

        if let unitaryResult = unitaryResult {
            return .success(unitaryResult)
        }

        return .failure(unitaryError)
    }
}

// MARK: - SimulatorTransformation methods

extension UnitaryGateTestDouble: SimulatorTransformation {
    func applying(_ gate: SimulatorGate) throws -> UnitaryGateTestDouble {
        applyingCount += 1

        lastApplyingGate = gate

        if let applyingResult = applyingResult {
            return applyingResult
        }

        throw applyingError
    }
}
