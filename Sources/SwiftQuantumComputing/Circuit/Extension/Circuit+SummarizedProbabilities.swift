//
//  Circuit+SummarizedProbabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/11/2019.
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

// MARK: - Errors

public enum SummarizedProbabilitiesError: Error {
    case qubitsAreNotInsideBounds
    case qubitsAreNotSorted
    case qubitsAreNotUnique
    case qubitsCanNotBeAnEmptyList
    case probabilitiesThrowedError(error: ProbabilitiesError)
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func summarizedProbabilities(withInitialBits initialBits: String? = nil) throws -> [String: Double] {
        let probs = try errorCapturedProbabilities(withInitialBits: initialBits)
        let bitCount = Int.log2(probs.count)

        var result: [String: Double] = [:]
        for (index, value) in probs.enumerated() {
            if value > 0 {
                result[String(index, bitCount: bitCount)] = value
            }
        }

        return result
    }

    public func summarizedProbabilities(qubits: [Int],
                                        initialBits: String? = nil) throws -> [String: Double] {
        guard qubits.count > 0 else {
            throw SummarizedProbabilitiesError.qubitsCanNotBeAnEmptyList
        }

        guard Self.areQubitsUnique(qubits) else {
            throw SummarizedProbabilitiesError.qubitsAreNotUnique
        }

        guard Self.areQubitsSorted(qubits) else {
            throw SummarizedProbabilitiesError.qubitsAreNotSorted
        }

        let probs = try errorCapturedProbabilities(withInitialBits: initialBits)

        guard Self.areQubitsInsideBounds(qubits, of: probs) else {
            throw SummarizedProbabilitiesError.qubitsAreNotInsideBounds
        }

        var result: [String: Double] = [:]

        for (index, value) in probs.enumerated() {
            if value > 0 {
                let derivedIndex = String(index, bits: qubits)

                result[derivedIndex] = (result[derivedIndex] ?? 0) + value
            }
        }

        return result
    }
}

// MARK: - Private body

private extension Circuit {

    // MARK: - Private methods

    func errorCapturedProbabilities(withInitialBits initialBits: String?) throws -> [Double] {
        do {
            return try probabilities(withInitialBits: initialBits)
        } catch {
            if let error = error as? ProbabilitiesError {
                throw SummarizedProbabilitiesError.probabilitiesThrowedError(error: error)
            } else {
                fatalError("Unexpected error: \(error).")
            }
        }
    }

    // MARK: - Private class methods

    static func areQubitsUnique(_ qubits: [Int]) -> Bool {
        return (qubits.count == Set(qubits).count)
    }

    static func areQubitsSorted(_ qubits: [Int]) -> Bool {
        return (qubits == qubits.sorted(by: >))
    }

    static func areQubitsInsideBounds(_ qubits: [Int], of probabilities: [Double]) -> Bool {
        let qubitCount = Int.log2(probabilities.count)
        let validQubits = (0..<qubitCount)

        return qubits.allSatisfy { validQubits.contains($0) }
    }
}
