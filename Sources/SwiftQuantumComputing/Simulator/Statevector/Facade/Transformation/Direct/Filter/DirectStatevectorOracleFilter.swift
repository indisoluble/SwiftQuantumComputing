//
//  DirectStatevectorOracleFilter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/04/2021.
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

struct DirectStatevectorOracleFilter {

    // MARK: - Private properties

    private let filters: [Filter]

    // MARK: - Init methods

    init(gateControls: [Int], truthTable: SimulatorOracleMatrix.TruthTable) {
        filters = DirectStatevectorOracleFilter.makeFilters(gateControls: gateControls,
                                                            truthTable: truthTable)
    }
}

// MARK: - DirectStatevectorFiltering methods

extension DirectStatevectorOracleFilter: DirectStatevectorFiltering {
    func shouldCalculateStatevectorValueAtPosition(_ position: Int) -> Bool {
        return filters.contains { (activatedBits, deactivatedBits) -> Bool in
            return ((position & activatedBits) == activatedBits) &&
                ((~position & deactivatedBits) == deactivatedBits)
        }
    }
}

// MARK: - Private body

private extension DirectStatevectorOracleFilter {

    // MARK: - Private types

    typealias Filter = (activatedBits: Int, deactivatedBits: Int)

    // MARK: - Private class methods

    static func makeFilters(gateControls: [Int], truthTable: [[Bool]]) -> [Filter] {
        return truthTable.map { truth -> Filter in
            return zip(truth, gateControls).lazy.reduce((0, 0)) { (acc, control) -> Filter in
                let mask = Int.mask(activatingBitAt: control.1)

                return control.0 ? (acc.0 | mask, acc.1) : (acc.0, acc.1 | mask)
            }
        }
    }
}
