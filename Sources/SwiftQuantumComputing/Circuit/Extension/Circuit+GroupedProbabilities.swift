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
public enum GroupedProbabilitiesError: Error, Equatable {
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        guard groupQubits.count > 0 else {
            return .failure(.groupQubitsCanNotBeAnEmptyList)
        }

        let allQubits = groupQubits + summaryQubits

        guard Self.areQubitsUnique(allQubits) else {
            return .failure(.qubitsAreNotUnique)
        }

        var probs: [Double]!
        switch probabilities(withInitialBits: initialBits) {
        case .success(let result):
            probs = result
        case .failure(let error):
            return .failure(.probabilitiesThrowedError(error: error))
        }

        guard Self.areQubitsInsideBounds(allQubits, of: probs) else {
            return .failure(.qubitsAreNotInsideBounds)
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

        let groupedProbs: [String: GroupedProb] = result.mapValues { groupProb in
            let normalize = 1.0 / groupProb.probability
            let summary = groupProb.summary.compactMapValues { (prob) -> Double? in
                var normProb = prob * normalize
                if let places = places {
                    normProb = normProb.rounded(toDecimalPlaces: places)
                }

                return (normProb > 0.0 ? normProb : nil)
            }

            return (groupProb.probability, summary)
        }

        return .success(groupedProbs)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: groupQubits,
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: [Int],
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: groupQubits,
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: summaryQubits,
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: Range<Int>,
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: [Int] = [],
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: summaryQubits,
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: Range<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
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
     - Parameter places: If provided, probabilities in each summary are rounded to the given number of decimal `places`.
     Notice that if a probability ends up rounded to 0.0, it is removed from the summary.

     - Returns: A dictionary where each key is a combination of qubits in `groupQubits` and its value the probability of
     such combination plus another dictionary where each key is a combination of qubits in `summaryQubits` and its value
     the probability of such combination if qubits in `groupQubits` collapse to the first key. Combinations with
     probability 0 are not included. Or `GroupedProbabilitiesError` error.
     */
    public func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                                     summarizedByQubits summaryQubits: ClosedRange<Int>,
                                     withInitialBits initialBits: String? = nil,
                                     roundSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    withInitialBits: initialBits,
                                    roundSummaryToDecimalPlaces: places)
    }
}

// MARK: - Private body

private extension Circuit {

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
