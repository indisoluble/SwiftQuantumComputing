//
//  Gate+CircuitViewPosition.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/09/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

extension Gate {

    // MARK: - Internal methods

    func makeLayer(qubitCount: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        return makeLayer(qubitCount: qubitCount, components: extractComponents())
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private types

    enum SingleQubitGate {
        case not(target: Int)
        case hadamard(target: Int)
        case phaseShift(radians: Double, target: Int)
        case matrix(target: Int)

        var target: Int {
            switch self {
            case .not(let target):
                return target
            case .hadamard(let target):
                return target
            case .phaseShift(_, let target):
                return target
            case .matrix(let target):
                return target
            }
        }

        func makePositionView(connected: CircuitViewPosition.TargetConnectivity) -> CircuitViewPosition {
            switch self {
            case .not:
                return .not(connected: connected)
            case .hadamard:
                return .hadamard(connected: connected)
            case .phaseShift(let radians, _):
                return .phaseShift(radians: radians, connected: connected)
            case .matrix:
                return .matrix(connected: connected)
            }
        }
    }

    enum SimpleGate {
        case singleQubit(gate: SingleQubitGate)
        case multiQubit(inputs: [Int])

        var inputs: [Int] {
            switch self {
            case .singleQubit(let gate):
                return [gate.target]
            case .multiQubit(let inputs):
                return inputs
            }
        }
    }

    typealias GateComponents = (controls: [Int], oracleControls: [Int], gate: SimpleGate)

    // MARK: - Private methods

    func extractComponents(controls: [Int] = [], oracleControls: [Int] = []) -> GateComponents {
        switch self {
        case .not(let target):
            return (controls, oracleControls, .singleQubit(gate: .not(target: target)))
        case .hadamard(let target):
            return (controls, oracleControls, .singleQubit(gate: .hadamard(target: target)))
        case .phaseShift(let radians, let target):
            return (controls,
                    oracleControls,
                    .singleQubit(gate: .phaseShift(radians: radians, target: target)))
        case .matrix(_, let inputs):
            if inputs.count == 1 {
                return (controls, oracleControls, .singleQubit(gate: .matrix(target: inputs[0])))
            }

            return (controls, oracleControls, .multiQubit(inputs: inputs))
        case .oracle(_, let someControls, let gate):
            return gate.extractComponents(controls: controls,
                                          oracleControls: someControls + oracleControls)
        case .controlled(let gate, let someControls):
            return gate.extractComponents(controls: someControls + controls,
                                          oracleControls: oracleControls)
        }
    }

    func makeLayer(qubitCount: Int,
                   components: GateComponents) -> Result<[CircuitViewPosition], DrawCircuitError> {
        let (controls, oracleControls, gate) = components

        let inputs = gate.inputs
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

        var layer = Array(repeating: CircuitViewPosition.lineHorizontal, count: qubitCount)

        let minUsedQubit = allUsedQubits.min()!
        let maxUsedQubit = allUsedQubits.max()!
        for index in minUsedQubit...maxUsedQubit {
            let connected: CircuitViewPosition.ControlConnectivity = (
                index == minUsedQubit ? .up : (index == maxUsedQubit ? .down : .both)
            )

            layer[index] = (controls.contains(index) ?
                .control(connected: connected) :
                (oracleControls.contains(index) ? .oracle(connected: connected) : .crossedLines))
        }

        switch gate {
        case .singleQubit(let gate):
            let target = inputs[0]
            let connected: CircuitViewPosition.TargetConnectivity = (
                target == minUsedQubit ? .up : (target == maxUsedQubit ? .down : .both)
            )

            layer[target] = gate.makePositionView(connected: connected)
        case .multiQubit:
            let minInput = inputs.min()!
            let maxInput = inputs.max()!
            for index in minInput...maxInput {
                if index == minUsedQubit {
                    let isConnectedAbove = allControls.contains(index + 1)

                    layer[index] = (isConnectedAbove ?
                        .matrix(connected: .up, showText: false) :
                        .matrixBottom(connectedDown: false))
                } else if index == maxUsedQubit {
                    let isConnectedBelow = allControls.contains(index - 1)

                    layer[index] = (isConnectedBelow ?
                        .matrix(connected: .down) :
                        .matrixTop(connectedUp: false))
                } else {
                    let isConnectedAbove = (index == maxInput) || allControls.contains(index + 1)
                    let isConnectedBelow = (index == minInput) || allControls.contains(index - 1)

                    if inputs.contains(index) {
                        if isConnectedAbove && isConnectedBelow {
                            layer[index] = .matrix(connected: .both, showText: index == maxInput)
                        } else if isConnectedAbove && !isConnectedBelow {
                            layer[index] = .matrixTop(connectedUp: true,
                                                      showText: index == maxInput)
                        } else if !isConnectedAbove && isConnectedBelow {
                            layer[index] = .matrixBottom(connectedDown: true)
                        } else {
                            layer[index] = .matrixMiddle
                        }
                    } else if !allControls.contains(index) {
                        if isConnectedAbove && isConnectedBelow {
                            layer[index] = .matrixGap(connected: .both)
                        } else if isConnectedAbove && !isConnectedBelow {
                            layer[index] = .matrixGap(connected: .up)
                        } else if !isConnectedAbove && isConnectedBelow {
                            layer[index] = .matrixGap(connected: .down)
                        } else {
                            layer[index] = .matrixGap(connected: .none)
                        }
                    }
                }
            }
        }

        return .success(layer)
    }
}
