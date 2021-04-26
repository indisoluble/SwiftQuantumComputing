//
//  TruthTableEntry.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/04/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

struct TruthTableEntry {

    // MARK: - Internal properties

    let truth: String

    // MARK: - Internal init methods

    enum InitError: Error {
        case truthHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        case truthCanNotBeRepresentedWithGivenTruthCount
    }

    init(truth: String, truthCount: Int? = nil) throws {
        let truthCount = truthCount ?? truth.count

        guard !truth.isEmpty else {
            throw InitError.truthHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        }

        guard truthCount > 0 else {
            throw InitError.truthCanNotBeRepresentedWithGivenTruthCount
        }

        var actualTruth = truth
        let offset = truthCount - truth.count
        if offset > 0 {
            actualTruth = String(repeating: "0", count: offset) + truth
        } else if offset < 0 {
            let offsetIndex = truth.index(truth.startIndex, offsetBy: abs(offset))

            if let nonZero = truth[..<offsetIndex].first(where: { $0 != "0" }) {
                if nonZero == "1" {
                    throw InitError.truthCanNotBeRepresentedWithGivenTruthCount
                }

                throw InitError.truthHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
            }

            actualTruth.removeSubrange(..<offsetIndex)
        }

        if !actualTruth.allSatisfy({ $0 == "0" || $0 == "1" }) {
            throw InitError.truthHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
        }

        self.init(truth: actualTruth)
    }

    // MARK: - Private init methods

    private init(truth: String) {
        self.truth = truth
    }
}

// MARK: - Hashable methods

extension TruthTableEntry: Hashable {
    static func == (lhs: TruthTableEntry, rhs: TruthTableEntry) -> Bool {
        return lhs.truth == rhs.truth
    }

    func hash(into hasher: inout Hasher) {
        truth.hash(into: &hasher)
    }
}

// MARK: - Overloaded operators

extension TruthTableEntry {

    // MARK: - Internal operators

    static func +(lhs: TruthTableEntry, rhs: TruthTableEntry) -> TruthTableEntry {
        return TruthTableEntry(truth: lhs.truth + rhs.truth)
    }
}
