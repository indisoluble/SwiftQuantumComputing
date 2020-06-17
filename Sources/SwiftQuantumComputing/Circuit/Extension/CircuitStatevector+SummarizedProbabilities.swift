//
//  CircuitStatevector+SummarizedProbabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/06/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

extension CircuitStatevector {

    // MARK: - Internal methods

    func summarizedProbabilities() -> [String: Double] {
        let probs = probabilities()
        let bitCount = Int.log2(probs.count)

        var result: [String: Double] = [:]
        for (index, value) in probs.enumerated() {
            if value > 0 {
                result[String(index, bitCount: bitCount)] = value
            }
        }

        return result
    }

    func summarizedProbabilities(byQubits qubits: [Int]) -> Result<[String: Double], SummarizedProbabilitiesError> {
        switch groupedProbabilities(byQubits: qubits) {
        case .success(let result):
            return .success(result.mapValues { $0.probability })
        case .failure(.groupQubitsCanNotBeAnEmptyList):
            return .failure(.qubitsCanNotBeAnEmptyList)
        case .failure(.qubitsAreNotInsideBounds):
            return .failure(.qubitsAreNotInsideBounds)
        case .failure(.qubitsAreNotUnique):
            return .failure(.qubitsAreNotUnique)
        case .failure(.probabilitiesThrowedError(let error)):
            return .failure(.probabilitiesThrowedError(error: error))
        }
    }

    func summarizedProbabilities(byQubits qubits: Range<Int>) -> Result<[String: Double], SummarizedProbabilitiesError> {
        return summarizedProbabilities(byQubits: Array(qubits))
    }

    func summarizedProbabilities(byQubits qubits: ClosedRange<Int>) -> Result<[String: Double], SummarizedProbabilitiesError> {
        return summarizedProbabilities(byQubits: Array(qubits))
    }
}
