//
//  Gate+CircuitViewLayer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/11/2020.
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

// MARK: - CircuitViewLayer methods

extension Gate: CircuitViewLayer {
    func makeLayer(qubitCount: Int) -> Result<[AnyCircuitViewPosition], DrawCircuitError> {
        let (controls, oracleControls, extractedGate) = extractComponents()

        let inputs = extractedGate.inputs
        guard inputs.count > 0 else {
            return .failure(.gateWithEmptyInputList(gate: self))
        }

        guard inputs.count == Set(inputs).count else {
            return .failure(.gateWithRepeatedInputs(gate: self))
        }

        let allControls = controls + oracleControls
        guard allControls.count == Set(allControls).count else {
            return .failure(.gateWithRepeatedControls(gate: self))
        }

        let allUsedQubits = allControls + inputs
        guard allUsedQubits.count == Set(allUsedQubits).count else {
            return .failure(.gateWithOneOrMoreInputsAlsoControls(gate: self))
        }

        let qubitRange = 0..<qubitCount
        guard allUsedQubits.allSatisfy({ qubitRange.contains($0) }) else {
            return .failure(.gateWithOneOrMoreInputsOrControlsOutOfRange(gate: self))
        }

        let minUsedQubit = allUsedQubits.min()!
        let maxUsedQubit = allUsedQubits.max()!
        let minInput = inputs.min()!
        let maxInput = inputs.max()!

        let layer = qubitRange.map { index -> AnyCircuitViewPosition in
            if index < minUsedQubit || index > maxUsedQubit {
                return LineHorizontalCircuitViewPosition().any()
            }

            if allControls.contains(index) {
                let connected: CircuitViewPositionConnectivity.Control = (
                    index == minUsedQubit ? .up : (index == maxUsedQubit ? .down : .both)
                )

                return controls.contains(index) ?
                    ControlCircuitViewPosition(connected: connected).any() :
                    OracleCircuitViewPosition(connected: connected).any()
            }

            if index < minInput || index > maxInput {
                return CrossedLinesCircuitViewPosition().any()
            }

            switch extractedGate {
            case .singleQubit(let gate):
                let connected: CircuitViewPositionConnectivity.Target = (
                    minUsedQubit == maxUsedQubit ?
                        .none :
                        (minInput == minUsedQubit ? .up : (minInput == maxUsedQubit ? .down : .both))
                )

                return gate.makePositionView(connected: connected)
            case .multiQubit:
                if index == minUsedQubit {
                    let isConnectedAbove = allControls.contains(index + 1)

                    return isConnectedAbove ?
                        MatrixCircuitViewPosition(connected: .up, showText: false).any() :
                        MatrixBottomCircuitViewPosition(connectedDown: false).any()
                }

                if index == maxUsedQubit {
                    let isConnectedBelow = allControls.contains(index - 1)

                    return isConnectedBelow ?
                        MatrixCircuitViewPosition(connected: .down).any() :
                        MatrixTopCircuitViewPosition(connectedUp: false).any()
                }

                let isConnectedAbove = (index == maxInput) || allControls.contains(index + 1)
                let isConnectedBelow = (index == minInput) || allControls.contains(index - 1)

                if inputs.contains(index) {
                    if isConnectedAbove && isConnectedBelow {
                        return MatrixCircuitViewPosition(connected: .both,
                                                         showText: index == maxInput).any()
                    }

                    if isConnectedAbove && !isConnectedBelow {
                        return MatrixTopCircuitViewPosition(connectedUp: true,
                                                            showText: index == maxInput).any()
                    }

                    if !isConnectedAbove && isConnectedBelow {
                        return MatrixBottomCircuitViewPosition(connectedDown: true).any()
                    }

                    return MatrixMiddleCircuitViewPosition().any()
                }

                if isConnectedAbove && isConnectedBelow {
                    return MatrixGapCircuitViewPosition(connected: .both).any()
                } else if isConnectedAbove && !isConnectedBelow {
                    return MatrixGapCircuitViewPosition(connected: .up).any()
                } else if !isConnectedAbove && isConnectedBelow {
                    return MatrixGapCircuitViewPosition(connected: .down).any()
                }

                return MatrixGapCircuitViewPosition(connected: .none).any()
            }
        }

        return .success(layer)
    }
}

// MARK: - GateComponentsCircuitView methods

extension Gate: GateComponentsCircuitView {
    func extractComponents() -> GateComponents {
        return (gate as! GateComponentsCircuitView).extractComponents()
    }
}
