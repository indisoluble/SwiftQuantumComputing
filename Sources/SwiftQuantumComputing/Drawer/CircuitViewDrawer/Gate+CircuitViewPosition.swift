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
        switch self {
        case .controlled:
            // TODO: Pending
            return .success(makeEmptyLayer(qubitCount: qubitCount))
        case .controlledMatrix(_, let inputs, let control):
            return makeControlledNotMatrixLayer(qubitCount: qubitCount,
                                                inputs: inputs,
                                                control: control)
        case .controlledNot(let target, let control):
            return makeControlledNotLayer(qubitCount: qubitCount, target: target, control: control)
        case .hadamard(let target):
            return makeHadamardLayer(qubitCount: qubitCount, target: target)
        case .matrix(_, let inputs):
            return makeMatrixLayer(qubitCount: qubitCount, inputs: inputs)
        case .not(let target):
            return makeNotLayer(qubitCount: qubitCount, target: target)
        case .oracle(_, let target, let controls):
            return makeOracleLayer(qubitCount: qubitCount, target: target, controls: controls)
        case .phaseShift(let radians, let target):
            return makePhaseShiftLayer(qubitCount: qubitCount, radians: radians, target: target)
        }
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private methods

    func makeHadamardLayer(qubitCount: Int,
                           target: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        layer[target] = .hadamard

        return .success(layer)
    }

    func makeNotLayer(qubitCount: Int,
                      target: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        layer[target] = .not

        return .success(layer)
    }

    func makePhaseShiftLayer(qubitCount: Int,
                             radians: Double,
                             target: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        layer[target] = .phaseShift(radians: radians)

        return .success(layer)
    }

    func makeControlledNotLayer(qubitCount: Int,
                                target: Int,
                                control: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target), layer.indices.contains(control) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        let isTargetOnTop = (target > control)
        layer[target] = (isTargetOnTop ? .controlledNotDown : .controlledNotUp)
        layer[control] = (isTargetOnTop ? .controlUp : .controlDown)

        let step = (isTargetOnTop ? -1 : 1)
        for index in stride(from: (target + step), to: control, by: step) {
            layer[index] = .crossedLines
        }

        return .success(layer)
    }

    func makeMatrixLayer(qubitCount: Int,
                         inputs: [Int]) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard inputs.count > 0 else {
            return .failure(.gateWithEmptyInputList(gate: self))
        }

        guard inputs.allSatisfy({ layer.indices.contains($0) }) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        if (inputs.count == 1) {
            layer[inputs[0]] = .matrix

            return .success(layer)
        }

        let sortedInputs = inputs.sorted()
        let first = sortedInputs.first!
        let last = sortedInputs.last!

        layer[first] = .matrixBottom(connected: false)
        for index in (first + 1)..<last {
            let isInputConnected = sortedInputs.contains(index)

            layer[index] = (isInputConnected ? .matrixMiddleConnected : .matrixMiddleUnconnected)
        }
        layer[last] = .matrixTop(inputs: inputs, connected: false)

        return .success(layer)
    }

    func makeControlledNotMatrixLayer(qubitCount: Int,
                                      inputs: [Int],
                                      control: Int) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard inputs.count > 0 else {
            return .failure(.gateWithEmptyInputList(gate: self))
        }

        guard !inputs.contains(control) else {
            return .failure(.gateControlIsAlsoAnInput(gate: self))
        }

        guard ([control] + inputs).allSatisfy({ layer.indices.contains($0) }) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        let sortedInputs = inputs.sorted()
        let firstInput = sortedInputs.first!
        let lastInput = sortedInputs.last!

        let isControlAbove = (control > lastInput)
        let isControlBelow = (control < firstInput)

        if (inputs.count == 1) {
            layer[firstInput] = (isControlAbove ? .matrixUp : .matrixDown)
        } else {
            layer[firstInput] = .matrixBottom(connected: isControlBelow)
            for index in (firstInput + 1)..<lastInput {
                let isInputConnected = sortedInputs.contains(index)

                layer[index] = (isInputConnected ?
                    .matrixMiddleConnected :
                    .matrixMiddleUnconnected)
            }
            layer[lastInput] = .matrixTop(inputs: inputs, connected: isControlAbove)
        }

        if (isControlAbove || isControlBelow) {
            layer[control] = (isControlAbove ? .controlDown : .controlUp)

            let step = (isControlAbove ? -1 : 1)
            let input = (isControlAbove ? lastInput : firstInput)
            for index in stride(from: (control + step), to: input, by: step) {
                layer[index] = .crossedLines
            }
        } else {
            layer[control] = .control
        }

        return .success(layer)
    }

    func makeOracleLayer(qubitCount: Int,
                         target: Int,
                         controls: [Int]) -> Result<[CircuitViewPosition], DrawCircuitError> {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard controls.count > 0 else {
            return .failure(.gateWithEmptyInputList(gate: self))
        }

        guard !controls.contains(target) else {
            return .failure(.gateTargetIsAlsoAControl(gate: self))
        }

        guard (controls + [target]).allSatisfy({ layer.indices.contains($0) }) else {
            return .failure(.gateWithOneOrMoreInputsOutOfRange(gate: self))
        }

        let sortedControls = controls.sorted()
        let firstControl = sortedControls.first!
        let lastControl = sortedControls.last!

        let isTargetAbove = (target > lastControl)
        let isTargetBelow = (target < firstControl)

        if (controls.count == 1) {
            layer[firstControl] = (isTargetAbove ? .oracleUp : .oracleDown)
        } else {
            layer[firstControl] = .oracleBottom(connected: isTargetBelow)
            for index in (firstControl + 1)..<lastControl {
                let isInputConnected = sortedControls.contains(index)

                layer[index] = (isInputConnected ?
                    .matrixMiddleConnected :
                    .matrixMiddleUnconnected)
            }
            layer[lastControl] = .oracleTop(controls: controls, connected: isTargetAbove)
        }

        if (isTargetAbove || isTargetBelow) {
            layer[target] = (isTargetAbove ? .controlledNotDown : .controlledNotUp)

            let step = (isTargetAbove ? -1 : 1)
            let control = (isTargetAbove ? lastControl : firstControl)
            for index in stride(from: (target + step), to: control, by: step) {
                layer[index] = .crossedLines
            }
        } else {
            layer[target] = .controlledNot
        }

        return .success(layer)
    }

    func makeEmptyLayer(qubitCount: Int) -> [CircuitViewPosition] {
        return Array(repeating: CircuitViewPosition.lineHorizontal, count: qubitCount)
    }
}
