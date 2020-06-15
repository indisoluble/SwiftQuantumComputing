//
//  CircuitStatevector+GroupedProbabilities.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/06/2020.
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

    // MARK: - Internal types

    typealias GroupedProb = (probability: Double, summary: [String: Double])

    // MARK: - Internal methods

    func groupedProbabilities(byQubits groupQubits: [Int],
                              summarizedByQubits summaryQubits: [Int] = [],
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        guard groupQubits.count > 0 else {
            return .failure(.groupQubitsCanNotBeAnEmptyList)
        }

        let allQubits = groupQubits + summaryQubits
        guard Self.areQubitsUnique(allQubits) else {
            return .failure(.qubitsAreNotUnique)
        }

        let probs = probabilities()
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

    func groupedProbabilities(byQubits groupQubits: [Int],
                              summarizedByQubits summaryQubits: Range<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: groupQubits,
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: [Int],
                              summarizedByQubits summaryQubits: ClosedRange<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: groupQubits,
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: Range<Int>,
                              summarizedByQubits summaryQubits: [Int] = [],
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: summaryQubits,
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: Range<Int>,
                              summarizedByQubits summaryQubits: Range<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: Range<Int>,
                              summarizedByQubits summaryQubits: ClosedRange<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                              summarizedByQubits summaryQubits: [Int] = [],
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: summaryQubits,
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                              summarizedByQubits summaryQubits: Range<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }

    func groupedProbabilities(byQubits groupQubits: ClosedRange<Int>,
                              summarizedByQubits summaryQubits: ClosedRange<Int>,
                              roundingSummaryToDecimalPlaces places: Int? = nil) -> Result<[String: GroupedProb], GroupedProbabilitiesError> {
        return groupedProbabilities(byQubits: Array(groupQubits),
                                    summarizedByQubits: Array(summaryQubits),
                                    roundingSummaryToDecimalPlaces: places)
    }
}

// MARK: - Private body

private extension CircuitStatevector {

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
