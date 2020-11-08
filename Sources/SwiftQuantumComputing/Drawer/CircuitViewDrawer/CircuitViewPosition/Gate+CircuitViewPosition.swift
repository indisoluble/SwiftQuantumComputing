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

    func makeLayer(qubitCount: Int) -> Result<[AnyCircuitViewPosition], DrawCircuitError> {
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
        case rotation(axis: Axis, radians: Double, target: Int)
        case matrix(target: Int)

        var target: Int {
            switch self {
            case .not(let target):
                return target
            case .hadamard(let target):
                return target
            case .phaseShift(_, let target):
                return target
            case .rotation(_, _, let target):
                return target
            case .matrix(let target):
                return target
            }
        }

        func makePositionView(connected: CircuitViewPositionConnectivity.Target) -> AnyCircuitViewPosition {
            switch self {
            case .not:
                return NotCircuitViewPosition(connected: connected).any()
            case .hadamard:
                return HadamardCircuitViewPosition(connected: connected).any()
            case .phaseShift(let radians, _):
                return PhaseShiftCircuitViewPosition(radians: radians, connected: connected).any()
            case .rotation(let axis, let radians, _):
                return RotationCircuitViewPosition(axis: axis,
                                                   radians: radians,
                                                   connected: connected).any()
            case .matrix:
                return MatrixCircuitViewPosition(connected: connected).any()
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

    func extractComponents() -> GateComponents {
        switch self {
        case .not(let target):
            return ([], [], .singleQubit(gate: .not(target: target)))
        case .hadamard(let target):
            return ([], [], .singleQubit(gate: .hadamard(target: target)))
        case .phaseShift(let radians, let target):
            return ([], [], .singleQubit(gate: .phaseShift(radians: radians, target: target)))
        case .rotation(let axis, let radians, let target):
            return ([],
                    [],
                    .singleQubit(gate: .rotation(axis: axis, radians: radians, target: target)))
        case .matrix(_, let inputs):
            if inputs.count == 1 {
                return ([], [], .singleQubit(gate: .matrix(target: inputs[0])))
            }

            return ([], [], .multiQubit(inputs: inputs))
        case .oracle(_, let someControls, let gate):
            let (controls, oracleControls, simpleGate) = gate.extractComponents()

            return (controls, someControls + oracleControls, simpleGate)
        case .controlled(let gate, let someControls):
            let (controls, oracleControls, simpleGate) = gate.extractComponents()

            return (someControls + controls, oracleControls, simpleGate)
        }
    }

    func makeLayer(qubitCount: Int,
                   components: GateComponents) -> Result<[AnyCircuitViewPosition], DrawCircuitError> {
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

        var layer: [AnyCircuitViewPosition] = Array(repeating: LineHorizontalCircuitViewPosition().any(),
                                                    count: qubitCount)

        let minUsedQubit = allUsedQubits.min()!
        let maxUsedQubit = allUsedQubits.max()!
        for index in minUsedQubit...maxUsedQubit {
            let connected: CircuitViewPositionConnectivity.Control = (
                index == minUsedQubit ? .up : (index == maxUsedQubit ? .down : .both)
            )

            if controls.contains(index) {
                layer[index] = ControlCircuitViewPosition(connected: connected).any()
            } else if oracleControls.contains(index) {
                layer[index] = OracleCircuitViewPosition(connected: connected).any()
            } else {
                layer[index] = CrossedLinesCircuitViewPosition().any()
            }
        }

        switch gate {
        case .singleQubit(let gate):
            let target = inputs[0]
            let connected: CircuitViewPositionConnectivity.Target = (
                minUsedQubit == maxUsedQubit ?
                    .none :
                    (target == minUsedQubit ? .up : (target == maxUsedQubit ? .down : .both))
            )

            layer[target] = gate.makePositionView(connected: connected)
        case .multiQubit:
            let minInput = inputs.min()!
            let maxInput = inputs.max()!
            for index in minInput...maxInput {
                if index == minUsedQubit {
                    let isConnectedAbove = allControls.contains(index + 1)

                    layer[index] = (isConnectedAbove ?
                        MatrixCircuitViewPosition(connected: .up, showText: false).any() :
                        MatrixBottomCircuitViewPosition(connectedDown: false).any())
                } else if index == maxUsedQubit {
                    let isConnectedBelow = allControls.contains(index - 1)

                    layer[index] = (isConnectedBelow ?
                        MatrixCircuitViewPosition(connected: .down).any() :
                        MatrixTopCircuitViewPosition(connectedUp: false).any())
                } else {
                    let isConnectedAbove = (index == maxInput) || allControls.contains(index + 1)
                    let isConnectedBelow = (index == minInput) || allControls.contains(index - 1)

                    if inputs.contains(index) {
                        if isConnectedAbove && isConnectedBelow {
                            layer[index] = MatrixCircuitViewPosition(connected: .both,
                                                                     showText: index == maxInput).any()
                        } else if isConnectedAbove && !isConnectedBelow {
                            layer[index] = MatrixTopCircuitViewPosition(connectedUp: true,
                                                                        showText: index == maxInput).any()
                        } else if !isConnectedAbove && isConnectedBelow {
                            layer[index] = MatrixBottomCircuitViewPosition(connectedDown: true).any()
                        } else {
                            layer[index] = MatrixMiddleCircuitViewPosition().any()
                        }
                    } else if !allControls.contains(index) {
                        if isConnectedAbove && isConnectedBelow {
                            layer[index] = MatrixGapCircuitViewPosition(connected: .both).any()
                        } else if isConnectedAbove && !isConnectedBelow {
                            layer[index] = MatrixGapCircuitViewPosition(connected: .up).any()
                        } else if !isConnectedAbove && isConnectedBelow {
                            layer[index] = MatrixGapCircuitViewPosition(connected: .down).any()
                        } else {
                            layer[index] = MatrixGapCircuitViewPosition(connected: .none).any()
                        }
                    }
                }
            }
        }

        return .success(layer)
    }
}
