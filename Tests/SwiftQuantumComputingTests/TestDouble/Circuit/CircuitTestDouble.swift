//
//  CircuitTestDouble.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 28/08/2018.
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

final class CircuitTestDouble {

    // MARK: - Internal properties

    private (set) var gatesCount = 0
    var gatesResult: [FixedGate] = []

    private (set) var unitaryCount = 0
    private (set) var lastUnitaryQubitCount: Int?
    var unitaryResult: Matrix?
    var unitaryError = UnitaryError.circuitCanNotBeAnEmptyList

    private (set) var statevectorCount = 0
    private (set) var lastStatevectorAfterInputting: String?
    var statevectorResult: Vector?
    var statevectorError = StatevectorError.inputBitsAreNotAStringComposedOnlyOfZerosAndOnes
}

// MARK: - Circuit methods

extension CircuitTestDouble: Circuit {
    var gates: [FixedGate] {
        gatesCount += 1

        return gatesResult
    }

    func unitary(usingQubitCount qubitCount: Int) throws -> Matrix {
        unitaryCount += 1

        lastUnitaryQubitCount = qubitCount

        if let unitaryResult = unitaryResult {
            return unitaryResult
        }

        throw unitaryError
    }

    func statevector(afterInputting bits: String) throws -> Vector {
        statevectorCount += 1

        lastStatevectorAfterInputting = bits

        if let statevectorResult = statevectorResult {
            return statevectorResult
        }

        throw statevectorError
    }
}
