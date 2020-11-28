//
//  MultiInputsPositionViewFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/11/2020.
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

struct MultiInputsPositionViewFactory {}

// MARK: - InputPositionViewFactory methods

extension MultiInputsPositionViewFactory: InputPositionViewFactory {
    func makePositionViewFactory(index: Int,
                                 inputs: [Int],
                                 controls: [Int]) -> AnyPositionViewFactory {
        let allUsedQubits = controls + inputs

        let minUsedQubit = allUsedQubits.min()!
        let maxUsedQubit = allUsedQubits.max()!
        let minInput = inputs.min()!
        let maxInput = inputs.max()!

        if index == minUsedQubit {
            let isConnectedAbove = controls.contains(index + 1)

            return isConnectedAbove ?
                MatrixPositionViewFactory(connected: .up, showText: false).any() :
                MatrixBottomPositionViewFactory(connectedDown: false).any()
        }

        if index == maxUsedQubit {
            let isConnectedBelow = controls.contains(index - 1)

            return isConnectedBelow ?
                MatrixPositionViewFactory(connected: .down).any() :
                MatrixTopPositionViewFactory(connectedUp: false).any()
        }

        let isConnectedAbove = (index == maxInput) || controls.contains(index + 1)
        let isConnectedBelow = (index == minInput) || controls.contains(index - 1)
        if isConnectedAbove && isConnectedBelow {
            return inputs.contains(index) ?
                MatrixPositionViewFactory(connected: .both, showText: index == maxInput).any() :
                MatrixGapPositionViewFactory(connected: .both).any()
        } else if isConnectedAbove && !isConnectedBelow {
            return inputs.contains(index) ?
                MatrixTopPositionViewFactory(connectedUp: true, showText: index == maxInput).any() :
                MatrixGapPositionViewFactory(connected: .up).any()
        } else if !isConnectedAbove && isConnectedBelow {
            return inputs.contains(index) ?
                MatrixBottomPositionViewFactory(connectedDown: true).any() :
                MatrixGapPositionViewFactory(connected: .down).any()
        }

        return inputs.contains(index) ?
            MatrixMiddlePositionViewFactory().any() :
            MatrixGapPositionViewFactory(connected: .none).any()
    }
}
