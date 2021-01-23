//
//  DirectStatevectorSingleQubitGateIndexer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/01/2021.
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

struct DirectStatevectorSingleQubitGateIndexer {

    // MARK: - Private properties

    private let mask: Int
    private let invMask: Int

    // MARK: - Init methods

    init(gateInput: Int) {
        mask = Int.mask(activatingBitAt: gateInput)
        invMask = ~mask
    }
}

// MARK: - DirectStatevectorIndexing methods

extension DirectStatevectorSingleQubitGateIndexer: DirectStatevectorIndexing {
    func indexesToCalculateStatevectorValueAtPosition(_ position: Int) -> DirectStatevectorAdditionIndexes {
        if position & mask == 0 {
            return (0, AnySequence([(0, position), (1,  position | mask)]))
        }

        return (1, AnySequence([(0, position & invMask), (1, position)]))
    }
}
