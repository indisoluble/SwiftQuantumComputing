//
//  Circuit+GroupedProbabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 28/03/2020.
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

// MARK: - Errors

/// Errors throwed by `Circuit.groupedProbabilities(byQubits:summarizedByQubits:withInitialBits:)`.
public enum GroupedProbabilitiesError: Error {
    /// Throwed when `groupQubits` does not specify any qubit, i.e. it is empty
    case groupQubitsCanNotBeAnEmptyList
    /// Throwed if `Circuit.probabilities(withInitialBits:)` throws `ProbabilitiesError`
    case probabilitiesThrowedError(error: ProbabilitiesError)
    /// Throwed when `groupQubits` and/or `summaryQubits` references a qubit that does not exist in the circuit
    case qubitsAreNotInsideBounds
    /// Throwed when `groupQubits` and/or `summaryQubits` contains repeated values
    case qubitsAreNotUnique
}

// MARK: - Main body

extension Circuit {

    // MARK: - Public types

    /// Check value returned by
    /// `Circuit.groupedProbabilities(byQubits:summarizedByQubits:withInitialBits:)`.
    public typealias GroupedProb = (probability: Double, summary: [String: Double])

    // MARK: - Public methods

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: List of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: List of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value. if an empty list is provided, an empty summary will be returned.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        guard groupQubits.count > 0 else {
            throw GroupedProbabilitiesError.groupQubitsCanNotBeAnEmptyList
        }

        let allQubits = groupQubits + summaryQubits

        guard Self.areQubitsUnique(allQubits) else {
            throw GroupedProbabilitiesError.qubitsAreNotUnique
        }

        let probs = try errorCapturedProbabilities(withInitialBits: initialBits)

        guard Self.areQubitsInsideBounds(allQubits, of: probs) else {
            throw GroupedProbabilitiesError.qubitsAreNotInsideBounds
        }

        var result: [String: GroupedProb] = [:]

        for (index, value) in probs.enumerated() {
            if value > 0 {
                let groupIdx = String(index, bits: groupQubits)

                var groupProb = result[groupIdx] ?? (0, [:])
                groupProb.probability += value
                if !summaryQubits.isEmpty {
                    let summaryIdx  = String(index, bits: summaryQubits)

                    groupProb.summary[summaryIdx] = (groupProb.summary[summaryIdx] ?? 0) + value
                }
                result[groupIdx] = groupProb
            }
        }

        return result.mapValues { groupProb in
            let normalize = 1.0 / groupProb.probability

            return (groupProb.probability, groupProb.summary.mapValues { $0 * normalize })
        }
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: List of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: groupQubits,
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: List of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: groupQubits,
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: List of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value. if an empty list is provided, an empty summary will be returned.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: summaryQubits,
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: List of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value. if an empty list is provided, an empty summary will be returned.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: summaryQubits,
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }

    /**
     Initializes circuit with `initialBits` and applies `gates` to get the probability of each possible combination of qubits
     in `groupQubits`. For each of these combinations, it also lists the probability of each possible combination of qubits
     in `summaryQubits` conditioned to measure the aformentioned combination in the qubits in `groupQubits`.
     This is equivalent to get the probability of each possible combination of qubits in `summaryQubits` after collapsing
     the qubits in `groupQubits` with a measurement.

     - Parameter groupQubits: Range of qubits for which we want to know the probability of each combination.
     - Parameter summaryQubits: Range of qubits for which we want to know the probability of each combination once the
     qubits in `groupQubits` collapse to a value.
     - Parameter initialBits: String composed only of 0's & 1's. If not provided, a sequence of 0's will be used instead.

     - Throws: `GroupedProbabilitiesError`.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included..
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil) throws -> [String: GroupedProb] {
        return try groupedProbabilities(byQubits: Array(groupQubits),
                                        summarizedByQubits: Array(summaryQubits),
                                        withInitialBits: initialBits)
    }
}

// MARK: - Private body

private extension Circuit {

    // MARK: - Private methods

    func errorCapturedProbabilities(withInitialBits initialBits: String?) throws -> [Double] {
        do {
            return try probabilities(withInitialBits: initialBits)
        } catch let error as ProbabilitiesError {
            throw GroupedProbabilitiesError.probabilitiesThrowedError(error: error)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }

    // MARK: - Private class methods

    static func areQubitsUnique(_ qubits: [Int]) -> Bool {
        return (qubits.count == Set(qubits).count)
    }

    static func areQubitsInsideBounds(_ qubits: [Int], of probabilities: [Double]) -> Bool {
        let qubitCount = Int.log2(probabilities.count)
        let validQubits = (0..<qubitCount)

        return qubits.allSatisfy { validQubits.contains($0) }
    }
}
