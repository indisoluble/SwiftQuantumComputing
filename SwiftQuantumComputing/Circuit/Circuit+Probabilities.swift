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

    public func probabilities() -> [String: Double]? {
        let qubits = Array((0..<qubitCount).reversed())

        return probabilities(qubits: qubits)
    }

    public func probabilities(qubits: [Int]) -> [String: Double]? {
        guard let measurements = measure(qubits: qubits) else {
            return nil
        }

        let bits = Array((0..<qubits.count).reversed())
        let mapped = (0..<measurements.count).map { (String($0, bits: bits), measurements[$0]) }
        let filtered = mapped.filter { $0.1 > 0 }

        return Dictionary(uniqueKeysWithValues: filtered)
    }
}
