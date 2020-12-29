//
//  BitRearranger.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/12/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

struct BitRearranger {

    // MARK: - Private types

    private typealias Destination = (selectMask: Int, right: Int)

    // MARK: - Internal properties

    let selectedBitsMask: Int
    let unselectedBitsMask: Int

    // MARK: - Private properties

    private let destinations: [Destination]

    // MARK: - Internal init methods

    init(origins: [Int]) {
        var partialSelectedBitsMask = 0
        var partialDestinations: [Destination] = []

        for (dest, org) in origins.reversed().enumerated() {
            let selectMask = 1 << org

            partialDestinations.append((selectMask, org - dest))
            partialSelectedBitsMask |= selectMask
        }

        selectedBitsMask = partialSelectedBitsMask
        unselectedBitsMask = ~partialSelectedBitsMask
        destinations = partialDestinations
    }

    // MARK: - Internal methods

    func rearrangeBits(in value: Int) -> Int {
        return destinations.reduce(0) { $0 | ((value & $1.selectMask) >> $1.right)}
    }
}
