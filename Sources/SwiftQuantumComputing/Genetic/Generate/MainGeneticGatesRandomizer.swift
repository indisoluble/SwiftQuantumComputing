//
//  MainGeneticGatesRandomizer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/01/2019.
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

// MARK: - Main body

struct MainGeneticGatesRandomizer {

    // MARK: - Internal types

    typealias RandomFactory = () -> GeneticGateFactory?
    typealias ShuffledQubits = () -> [Int]

    // MARK: - Private properties

    private let randomFactory: RandomFactory
    private let shuffledQubits: ShuffledQubits

    // MARK: - Private class properties

    private static let logger = Logger()

    // MARK: - Internal init methods

    init(qubitCount: Int, factories: [GeneticGateFactory]) throws {
        guard qubitCount > 0 else {
            throw EvolveCircuitError.useCaseCircuitQubitCountHasToBeBiggerThanZero
        }

        let qubits = Array(0..<qubitCount)

        self.init(randomFactory: { factories.randomElement() },
                  shuffledQubits: { qubits.shuffled() })
    }

    init(randomFactory: @escaping RandomFactory, shuffledQubits: @escaping ShuffledQubits) {
        self.randomFactory = randomFactory
        self.shuffledQubits = shuffledQubits
    }
}

// MARK: - GeneticGatesRandomizer methods

extension MainGeneticGatesRandomizer: GeneticGatesRandomizer {
    func make(depth: Int) -> Result<[GeneticGate], EvolveCircuitError> {
        assert(depth >= 0, "depth has to be a positive number")

        var result: [GeneticGate] = []

        for _ in 0..<depth {
            guard let factory = randomFactory() else {
                continue
            }

            switch factory.makeGate(inputs: shuffledQubits()) {
            case .success(let gate):
                result.append(gate)
            case .failure(let error):
                return .failure(error)
            }
        }

        return .success(result)
    }
}
