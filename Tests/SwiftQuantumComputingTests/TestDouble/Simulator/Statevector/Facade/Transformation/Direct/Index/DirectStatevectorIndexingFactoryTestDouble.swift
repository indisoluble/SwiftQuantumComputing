//
//  DirectStatevectorIndexingFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/01/2021.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class DirectStatevectorIndexingFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeSingleQubitGateIndexerCount = 0
    private (set) var lastMakeSingleQubitGateIndexerGateInput: Int?

    private (set) var makeMultiQubitGateIndexerCount = 0
    private (set) var lastMakeMultiQubitGateIndexerGateInputs: [Int]?
    var makeMultiQubitGateIndexerResult = try! Vector([.one, .zero])
}

// MARK: - DirectStatevectorIndexingFactory methods

extension DirectStatevectorIndexingFactoryTestDouble: DirectStatevectorIndexingFactory {
    func makeSingleQubitGateIndexer(gateInput: Int) -> DirectStatevectorIndexing {
        makeSingleQubitGateIndexerCount += 1

        lastMakeSingleQubitGateIndexerGateInput = gateInput

        return DirectStatevectorSingleQubitGateIndexer(gateInput: gateInput)
    }

    func makeMultiQubitGateIndexer(gateInputs: [Int]) -> DirectStatevectorIndexing {
        makeMultiQubitGateIndexerCount += 1

        lastMakeMultiQubitGateIndexerGateInputs = gateInputs

        return DirectStatevectorMultiQubitGateIndexer(gateInputs: gateInputs)
    }
}
