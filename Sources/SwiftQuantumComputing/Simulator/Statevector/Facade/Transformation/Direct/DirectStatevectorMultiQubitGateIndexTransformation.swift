//
//  DirectStatevectorMultiQubitGateIndexTransformation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/01/2021.
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

struct DirectStatevectorMultiQubitGateIndexTransformation {

    // MARK: - Internal types

    typealias AdditionIndexes = (gateMatrixRow: Int,
                                 multiplications: DirectStatevectorMultiQubitGateMultiplicationIndexes)

    // MARK: - Private properties

    private let rearranger: [BitwiseShift]
    private let activationMasks: [Int]
    private let unselectedBitMask: Int

    // MARK: - Init methods

    init(gateInputs: [Int]) {
        var rearranger: [BitwiseShift] = []
        var selectedBitMask = 0
        var activationMasks: [Int] = []
        for (destination, origin) in gateInputs.reversed().enumerated() {
            let action = BitwiseShift(origin: origin, destination: destination)

            rearranger.append(action)

            selectedBitMask |= action.selectMask

            activationMasks.append(action.selectMask)
            let partialCount = activationMasks.count - 1
            for index in 0..<partialCount {
                activationMasks.append(activationMasks[index] | action.selectMask)
            }
        }

        self.rearranger = rearranger
        self.activationMasks = activationMasks
        unselectedBitMask = ~selectedBitMask
    }

    // MARK: - Internal methods

    func indexesToCalculateStatevectorValueAtPosition(_ position: Int) -> AdditionIndexes {
        let matrixRow = rearranger.rearrangeBits(in: position)

        let derivedIndex = position & unselectedBitMask
        let multiplications = DirectStatevectorMultiQubitGateMultiplicationIndexes(derivedIndex: derivedIndex,
                                                                                   activationMasks: activationMasks)
        return (matrixRow, multiplications)
    }
}
