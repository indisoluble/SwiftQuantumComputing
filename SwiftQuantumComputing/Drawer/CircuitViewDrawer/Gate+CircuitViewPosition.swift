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
import os.log

// MARK: - Main body

extension Gate {

    // MARK: - Internal methods

    func makeLayer(qubitCount: Int) -> [CircuitViewPosition] {
        switch self {
        case .controlledNot(let target, let control):
            return makeControlledNotLayer(qubitCount: qubitCount, target: target, control: control)
        case .hadamard(let target):
            return makeHadamardLayer(qubitCount: qubitCount, target: target)
        case .matrix(_, let inputs):
            return makeOracleLayer(qubitCount: qubitCount, inputs: inputs)
        case .not(let target):
            return makeNotLayer(qubitCount: qubitCount, target: target)
        case .phaseShift(let radians, let target):
            return makePhaseShiftLayer(qubitCount: qubitCount, radians: radians, target: target)
        }
    }
}

// MARK: - Private body

private extension Gate {

    // MARK: - Private methods

    func makeHadamardLayer(qubitCount: Int, target: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            os_log("makeHadamardLayer failed: target out of range",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

            return layer
        }

        layer[target] = .hadamard

        return layer
    }

    func makeNotLayer(qubitCount: Int, target: Int) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard layer.indices.contains(target) else {
            os_log("makeNotLayer failed: target out of range",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

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
            os_log("makePhaseShiftLayer failed: target out of range",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

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
            os_log("makeControlledNotLayer failed: target and/or control out of range",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

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

    func makeOracleLayer(qubitCount: Int, inputs: [Int]) -> [CircuitViewPosition] {
        var layer = makeEmptyLayer(qubitCount: qubitCount)
        guard inputs.allSatisfy({ layer.indices.contains($0) }) else {
            os_log("makeOracleLayer failed: one or more inputs are out of range",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

            return layer
        }

        guard inputs.count > 1 else {
            layer[inputs[0]] = .oracle

            return layer
        }

        let sortedInputs = inputs.sorted()
        let first = sortedInputs.first!
        let last = sortedInputs.last!

        layer[first] = .oracleBottom
        for index in (first + 1)..<last {
            let isInputConnected = sortedInputs.contains(index)

            layer[index] = (isInputConnected ? .oracleMiddleConnected : .oracleMiddleUnconnected)
        }
        layer[last] = .oracleTop(inputs: inputs)

        return layer
    }

    func makeEmptyLayer(qubitCount: Int) -> [CircuitViewPosition] {
        return Array(repeating: CircuitViewPosition.lineHorizontal, count: qubitCount)
    }
}
