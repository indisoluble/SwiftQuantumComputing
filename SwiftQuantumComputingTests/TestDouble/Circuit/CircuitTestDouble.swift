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

    private (set) var qubitCountCount = 0
    var qubitCountResult = 0

    private (set) var applyingGateCount = 0
    private (set) var lastApplyingGateGate: CircuitGate?
    private (set) var lastApplyingGateInputs: [Int]?
    var applyingGateResult: CircuitTestDouble?

    private (set) var measureCount = 0
    private (set) var lastMeasureQubits: [Int]?
    var measureResult: [Double]?
}

// MARK: - Circuit methods

extension CircuitTestDouble: Circuit {
    var qubitCount: Int {
        qubitCountCount += 1

        return qubitCountResult
    }

    func applyingGate(_ gate: CircuitGate, inputs: [Int]) -> CircuitTestDouble? {
        applyingGateCount += 1

        lastApplyingGateGate = gate
        lastApplyingGateInputs = inputs

        return applyingGateResult
    }

    func measure(qubits: Int...) -> [Double]? {
        measureCount += 1

        lastMeasureQubits = qubits

        return measureResult
    }
}
