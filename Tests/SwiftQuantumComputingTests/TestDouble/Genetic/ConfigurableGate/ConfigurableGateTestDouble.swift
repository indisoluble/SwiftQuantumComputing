//
//  ConfigurableGateTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/02/2019.
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

final class ConfigurableGateTestDouble {

    // MARK: - Internal properties

    private (set) var makeFixedCount = 0
    private (set) var lastMakeFixedInputs: [Int]?
    var makeFixedResult: Gate?
}

// MARK: - ConfigurableGate methods

extension ConfigurableGateTestDouble: ConfigurableGate {
    func makeFixed(inputs: [Int]) -> Result<Gate, EvolveCircuitError> {
        makeFixedCount += 1

        lastMakeFixedInputs = inputs

        if let makeFixedResult = makeFixedResult {
            return .success(makeFixedResult)
        }

        return .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: self)) 
    }
}
