//
//  Circuit+Probabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/10/2019.
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

public enum ProbabilitiesError: Error {
    case qubitsAreNotInsideBounds
    case qubitsAreNotSorted
    case qubitsAreNotUnique
    case qubitsCanNotBeAnEmptyList
    case statevectorThrowedError(error: StatevectorError)
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func probabilities(afterInputting bits: String) throws -> [Double] {
        var state: Vector!
        do {
            state = try statevector(afterInputting: bits)
        } catch {
            if let error = error as? StatevectorError {
                throw ProbabilitiesError.statevectorThrowedError(error: error)
            } else {
                fatalError("Unexpected error: \(error).")
            }
        }

        return state.map { $0.squaredModulus }
    }

    public func summarizedProbabilities(afterInputting bits: String) throws -> [String: Double] {
        let probs = try probabilities(afterInputting: bits)
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
                                        afterInputting bits: String) throws -> [String: Double] {
        guard qubits.count > 0 else {
            throw ProbabilitiesError.qubitsCanNotBeAnEmptyList
        }

        guard CircuitFacade.areQubitsUnique(qubits) else {
            throw ProbabilitiesError.qubitsAreNotUnique
        }

        guard CircuitFacade.areQubitsSorted(qubits) else {
            throw ProbabilitiesError.qubitsAreNotSorted
        }

        let probs = try probabilities(afterInputting: bits)

        guard CircuitFacade.areQubitsInsideBounds(qubits, of: probs) else {
            throw ProbabilitiesError.qubitsAreNotInsideBounds
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

private extension CircuitFacade {

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
