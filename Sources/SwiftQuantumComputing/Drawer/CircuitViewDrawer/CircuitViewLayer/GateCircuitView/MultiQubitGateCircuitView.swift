//
//  MultiQubitGateCircuitView.swift
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

struct MultiQubitGateCircuitView {}

// MARK: - GateCircuitView methods

extension MultiQubitGateCircuitView: GateCircuitView {
    func makePositionView(index: Int, inputs: [Int], controls: [Int]) -> AnyCircuitViewPosition {
        let allUsedQubits = controls + inputs

        let minUsedQubit = allUsedQubits.min()!
        let maxUsedQubit = allUsedQubits.max()!
        let minInput = inputs.min()!
        let maxInput = inputs.max()!

        if index == minUsedQubit {
            let isConnectedAbove = controls.contains(index + 1)

            return isConnectedAbove ?
                MatrixCircuitViewPosition(connected: .up, showText: false).any() :
                MatrixBottomCircuitViewPosition(connectedDown: false).any()
        }

        if index == maxUsedQubit {
            let isConnectedBelow = controls.contains(index - 1)

            return isConnectedBelow ?
                MatrixCircuitViewPosition(connected: .down).any() :
                MatrixTopCircuitViewPosition(connectedUp: false).any()
        }

        let isConnectedAbove = (index == maxInput) || controls.contains(index + 1)
        let isConnectedBelow = (index == minInput) || controls.contains(index - 1)
        if isConnectedAbove && isConnectedBelow {
            return inputs.contains(index) ?
                MatrixCircuitViewPosition(connected: .both, showText: index == maxInput).any() :
                MatrixGapCircuitViewPosition(connected: .both).any()
        } else if isConnectedAbove && !isConnectedBelow {
            return inputs.contains(index) ?
                MatrixTopCircuitViewPosition(connectedUp: true, showText: index == maxInput).any() :
                MatrixGapCircuitViewPosition(connected: .up).any()
        } else if !isConnectedAbove && isConnectedBelow {
            return inputs.contains(index) ?
                MatrixBottomCircuitViewPosition(connectedDown: true).any() :
                MatrixGapCircuitViewPosition(connected: .down).any()
        }

        return inputs.contains(index) ?
            MatrixMiddleCircuitViewPosition().any() :
            MatrixGapCircuitViewPosition(connected: .none).any()
    }
}
