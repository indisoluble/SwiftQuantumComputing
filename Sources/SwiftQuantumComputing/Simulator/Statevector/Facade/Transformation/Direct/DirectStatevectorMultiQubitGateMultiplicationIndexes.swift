//
//  DirectStatevectorMultiQubitGateMultiplicationIndexes.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/01/2021.
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

struct DirectStatevectorMultiQubitGateMultiplicationIndexes {

    // MARK: - Internal types

    typealias MultiplicationIndexes = (gateMatrixColumn: Int, inputStatevectorPosition: Int)

    // MARK: - Private properties

    private let derivedIndex: Int

    private var gateMatrixColumn: Int
    private var activationMasks: FlattenSequence<[[Int]]>.Iterator

    // MARK: - Init methods

    init(derivedIndex: Int, activationMasks: [Int]) {
        self.derivedIndex = derivedIndex

        gateMatrixColumn = 0
        self.activationMasks = [[0], activationMasks].joined().makeIterator()
    }
}

// MARK: - Sequence methods

extension DirectStatevectorMultiQubitGateMultiplicationIndexes: Sequence {}

// MARK: - IteratorProtocol methods

extension DirectStatevectorMultiQubitGateMultiplicationIndexes: IteratorProtocol {
    mutating func next() -> MultiplicationIndexes? {
        guard let mask = activationMasks.next() else {
            return nil
        }

        let indexes: MultiplicationIndexes = (gateMatrixColumn, derivedIndex | mask)
        gateMatrixColumn += 1

        return indexes
    }
}
