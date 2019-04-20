//
//  GeneticGatesRandomizerTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/02/2019.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class GeneticGatesRandomizerTestDouble {

    // MARK: - Internal properties

    private (set) var makeCount = 0
    private (set) var lastMakeDepth: Int?
    var makeResult: [GeneticGate]?
    var makeError = GeneticGatesRandomizerMakeError.depthHasToBeAPositiveNumber

    // MARK: - Private properties

    private let queue: DispatchQueue

    // MARK: - Internal init methods

    init() {
        queue = DispatchQueue(label: String(reflecting: type(of: self)))
    }
}

// MARK: - GeneticGatesRandomizer methods

extension GeneticGatesRandomizerTestDouble: GeneticGatesRandomizer {
    func make(depth: Int) throws -> [GeneticGate] {
        queue.sync {
            makeCount += 1

            lastMakeDepth = depth
        }

        if let makeResult = makeResult {
            return makeResult
        }

        throw makeError
    }
}
