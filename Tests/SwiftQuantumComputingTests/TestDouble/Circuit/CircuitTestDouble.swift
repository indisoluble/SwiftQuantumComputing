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

    private (set) var measureCount = 0
    private (set) var lastMeasureQubits: [Int]?
    private (set) var lastMeasureBits: String?
    var measureResult: [Double]?
    var measureError = MeasureError.qubitsAreNotInsideBounds
}

// MARK: - Circuit methods

extension CircuitTestDouble: Circuit {
    var gates: [FixedGate] {
        gatesCount += 1

        return gatesResult
    }

    func measure(qubits: [Int], afterInputting bits: String) throws -> [Double] {
        measureCount += 1

        lastMeasureQubits = qubits
        lastMeasureBits = bits

        if let measureResult = measureResult {
            return measureResult
        }

        throw measureError
    }
}
