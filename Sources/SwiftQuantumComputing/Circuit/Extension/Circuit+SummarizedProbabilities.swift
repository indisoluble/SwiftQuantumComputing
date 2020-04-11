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

/// Errors throwed by `Circuit.summarizedProbabilities(withInitialBits:)`.
public enum SummarizedProbabilitiesError: Error {
    /// Throwed if `Circuit.probabilities(withInitialBits:)` throws `ProbabilitiesError`
    case probabilitiesThrowedError(error: ProbabilitiesError)
    /// Throwed when `qubits` references a qubit that does not exist in the circuit
    case qubitsAreNotInsideBounds
    /// Throwed when `qubits` contains repeated values
    case qubitsAreNotUnique
    /// Throwed when `qubits` does not specify any qubit, i.e. it is empty
    case qubitsCanNotBeAnEmptyList
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits.

     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `SummarizedProbabilitiesError.probabilitiesThrowedError(error:)`.

     - Returns: A dictionary where each key is a qubit combination and its value the probability of such combination. Combination
     with probability 0 are not included.
     */
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

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `qubits`.

     - Parameter qubits: List of qubits for which we want to know the probability of each combination.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `SummarizedProbabilitiesError`.

     - Returns: A dictionary where each key is a qubit combination and its value the probability of such combination. Combination
     with probability 0 are not included.
     */
    public func summarizedProbabilities(byQubits qubits: [Int],
                                        withInitialBits initialBits: String? = nil) throws -> [String: Double] {
        var result: [String: GroupedProb] = [:]
        do {
            result = try groupedProbabilities(byQubits: qubits, withInitialBits: initialBits)
        } catch GroupedProbabilitiesError.groupQubitsCanNotBeAnEmptyList {
            throw SummarizedProbabilitiesError.qubitsCanNotBeAnEmptyList
        } catch GroupedProbabilitiesError.qubitsAreNotUnique {
            throw SummarizedProbabilitiesError.qubitsAreNotUnique
        } catch GroupedProbabilitiesError.qubitsAreNotInsideBounds {
            throw SummarizedProbabilitiesError.qubitsAreNotInsideBounds
        } catch GroupedProbabilitiesError.probabilitiesThrowedError(let error) {
            throw SummarizedProbabilitiesError.probabilitiesThrowedError(error: error)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return result.mapValues { $0.probability }
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `qubits`.

     - Parameter qubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `SummarizedProbabilitiesError`.

     - Returns: A dictionary where each key is a qubit combination and its value the probability of such combination. Combination
     with probability 0 are not included.
     */
    public func summarizedProbabilities(byQubits qubits: Range<Int>,
                                        withInitialBits initialBits: String? = nil) throws -> [String: Double] {
        return try summarizedProbabilities(byQubits: Array(qubits), withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `qubits`.

     - Parameter qubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `SummarizedProbabilitiesError`.

     - Returns: A dictionary where each key is a qubit combination and its value the probability of such combination. Combination
     with probability 0 are not included.
     */
    public func summarizedProbabilities(byQubits qubits: ClosedRange<Int>,
                                        withInitialBits initialBits: String? = nil) throws -> [String: Double] {
        return try summarizedProbabilities(byQubits: Array(qubits), withInitialBits: initialBits)
    }
}

// MARK: - Private body

private extension Circuit {

    // MARK: - Private methods

    func errorCapturedProbabilities(withInitialBits initialBits: String?) throws -> [Double] {
        do {
            return try probabilities(withInitialBits: initialBits)
        } catch let error as ProbabilitiesError {
            throw SummarizedProbabilitiesError.probabilitiesThrowedError(error: error)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
