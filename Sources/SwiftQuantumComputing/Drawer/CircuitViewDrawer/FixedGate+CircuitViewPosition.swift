//
//  FixedGate+CircuitViewPosition.swift
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

extension FixedGate {

    // MARK: - Internal methods

    func makeLayer(qubitCount: Int) -> [CircuitViewPosition] {
        switch self {
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

private extension FixedGate {

    // MARK: - Private methods

    func makeHadamardLayer(qubitCount: Int, target: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            Logger().debug("makeHadamardLayer failed: target out of range")

            return layer
        }

        layer[target] = .hadamard

        return layer
    }

    func makeNotLayer(qubitCount: Int, target: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            Logger().debug("makeNotLayer failed: target out of range")

            return layer
        }

        layer[target] = .not

        return layer
    }

    func makePhaseShiftLayer(qubitCount: Int,
                             radians: Double,
                             target: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            Logger().debug("makePhaseShiftLayer failed: target out of range")

            return layer
        }

        layer[target] = .phaseShift(radians: radians)

        return layer
    }

    func makeControlledNotLayer(qubitCount: Int,
                                target: Int,
                                control: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target), layer.indices.contains(control) else {
            Logger().debug("makeControlledNotLayer failed: target and/or control out of range")

            return layer
        }

        let isTargetOnTop = (target > control)
        layer[target] = (isTargetOnTop ? .controlledNotDown : .controlledNotUp)
        layer[control] = (isTargetOnTop ? .controlUp : .controlDown)

        let step = (isTargetOnTop ? -1 : 1)
        for index in stride(from: (target + step), to: control, by: step) {
            layer[index] = .crossedLines
        }

        return layer
    }

    func makeMatrixLayer(qubitCount: Int, inputs: [Int]) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard inputs.count > 0 else {
            Logger().debug("makeMatrixLayer failed: no inputs provided")

            return layer
        }

        guard inputs.allSatisfy({ layer.indices.contains($0) }) else {
            Logger().debug("makeMatrixLayer failed: one or more inputs are out of range")

            return layer
        }

        if (inputs.count == 1) {
            layer[inputs[0]] = .matrix

            return layer
        }

        let sortedInputs = inputs.sorted()
        let first = sortedInputs.first!
        let last = sortedInputs.last!

        layer[first] = .matrixBottom
        for index in (first + 1)..<last {
            let isInputConnected = sortedInputs.contains(index)

            layer[index] = (isInputConnected ? .matrixMiddleConnected : .matrixMiddleUnconnected)
        }
        layer[last] = .matrixTop(inputs: inputs)

        return layer
    }

    func makeOracleLayer(qubitCount: Int, target: Int, controls: [Int]) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard controls.count > 0 else {
            Logger().debug("makeOracleLayer failed: no controls provided")

            return layer
        }

        guard !controls.contains(target) else {
            Logger().debug("makeOracleLayer failed: target is also a control")

            return layer
        }

        guard (controls + [target]).allSatisfy({ layer.indices.contains($0) }) else {
            Logger().debug("makeOracleLayer failed: one or more inputs are out of range")

            return layer
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

        return layer
    }

    func makeEmptyLayer(qubitCount: Int) -> [CircuitViewPosition] {
        return Array(repeating: CircuitViewPosition.lineHorizontal, count: qubitCount)
    }
}
