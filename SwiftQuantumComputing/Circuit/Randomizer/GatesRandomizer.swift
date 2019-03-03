//
//  GatesRandomizer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

struct GatesRandomizer {

    // MARK: - Internal types

    typealias RandomGate = () -> Gate?
    typealias ShuffledQubits = () -> [Int]

    // MARK: - Private properties

    private let depth: Int
    private let randomGate: RandomGate
    private let shuffledQubits: ShuffledQubits

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init?(qubitCount: Int, depth: Int, gates: [Gate]) {
        guard qubitCount > 0 else {
            os_log("init failed: circuit has to have at least 1 qubit",
                   log: GatesRandomizer.logger,
                   type: .debug)

            return nil
        }

        let qubits = Array(0..<qubitCount)

        self.init(depth: depth,
                  randomGate: { gates.randomElement() },
                  shuffledQubits: { qubits.shuffled() })
    }

    init?(depth: Int,
          randomGate: @escaping RandomGate,
          shuffledQubits: @escaping ShuffledQubits) {
        guard depth >= 0 else {
            os_log("init failed: depth has to be a positive number",
                   log: GatesRandomizer.logger,
                   type: .debug)

            return nil
        }

        self.depth = depth
        self.randomGate = randomGate
        self.shuffledQubits = shuffledQubits
    }

    // MARK: - Internal methods

    func execute() -> [FixedGate] {
        var result: [FixedGate] = []

        for _ in 0..<depth {
            guard let gate = randomGate() else {
                continue
            }

            guard let fixed = gate.makeFixed(inputs: shuffledQubits()) else {
                continue
            }

            result.append(fixed)
        }

        return result
    }
}
