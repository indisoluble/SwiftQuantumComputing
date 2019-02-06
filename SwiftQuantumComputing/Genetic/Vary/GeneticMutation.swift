//
//  GeneticMutation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 28/01/2019.
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
import os.log

// MARK: - Main body

struct GeneticMutation {

    // MARK: - Private properties

    private let maxDepth: Int
    private let randomizer: GeneticGatesRandomizer

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init(maxDepth: Int, randomizer: GeneticGatesRandomizer) {
        self.maxDepth = maxDepth
        self.randomizer = randomizer
    }

    // MARK: - Internal methods

    func execute(_ circuit: [GeneticGate]) -> [GeneticGate]? {
        let (c1, cp) = circuit.randomSplit()
        let (_, c3) = cp.randomSplit()

        let remainingDepth = (maxDepth - c1.count - c3.count)
        guard remainingDepth >= 0 else {
            os_log("execute: unable to produce a mutation with remaining depth",
                   log: GeneticMutation.logger,
                   type: .debug)

            return nil
        }

        let depth = Array(0...remainingDepth).randomElement()!
        guard let m = randomizer.make(depth: depth) else {
            return nil
        }

        return (c1 + m + c3)
    }
}
