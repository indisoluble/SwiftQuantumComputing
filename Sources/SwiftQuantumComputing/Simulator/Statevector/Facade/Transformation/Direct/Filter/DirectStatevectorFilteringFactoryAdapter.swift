//
//  DirectStatevectorFilteringFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/04/2021.
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

struct DirectStatevectorFilteringFactoryAdapter {}

// MARK: - DirectStatevectorFilteringFactory methods

extension DirectStatevectorFilteringFactoryAdapter: DirectStatevectorFilteringFactory {
    func makeFilter(gateControls: [Int],
                    truthTable: [TruthTableEntry]) -> DirectStatevectorFiltering {
        if truthTable.isEmpty {
            return DirectStatevectorDummyFilter()
        }

        if truthTable.count == 1 && truthTable[0].truth.allSatisfy({ $0 == "1" }) {
            return DirectStatevectorControlledFilter(gateControls: gateControls)
        }

        return DirectStatevectorOracleFilter(gateControls: gateControls, truthTable: truthTable)
    }
}