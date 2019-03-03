//
//  Circuit+Probabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/11/2018.
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

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func probabilities(afterInputting bits: String) -> [String: Double]? {
        let qubits = Array((0..<bits.count).reversed())

        return probabilities(qubits: qubits, afterInputting: bits)
    }

    public func probabilities(qubits: [Int], afterInputting bits: String) -> [String: Double]? {
        guard let measurements = measure(qubits: qubits, afterInputting: bits) else {
            return nil
        }

        let bitCount = Int.log2(measurements.count)

        var result: [String: Double] = [:]
        for (output, measure) in measurements.enumerated() {
            guard measure > 0 else {
                continue
            }

            result[String(output, bitCount: bitCount)] = measure
        }

        return result
    }
}
