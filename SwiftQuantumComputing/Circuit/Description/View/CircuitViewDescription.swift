//
//  CircuitViewDescription.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/09/2018.
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

struct CircuitViewDescription {

    // MARK: - Private properties

    private let layers: [[Position]]

    // MARK: - Init methods

    init?(qubitCount: Int) {
        guard qubitCount > 0 else {
            return nil
        }

        let layer = (0..<qubitCount).map { Position.qubit(index: $0) }

        self.init(layers: [layer])
    }

    private init(layers: [[Position]]) {
        self.layers = layers
    }
}

// MARK: - CircuitDescription methods

extension CircuitViewDescription: CircuitDescription {
    func applyingDescriber(_ describer: CircuitGateDescribable,
                           inputs: [Int]) -> CircuitViewDescription {
        var layer: [Position] = []
        switch describer.gateDescription(with: inputs) {
        case .hadamard(let target):
            layer = makeHadamardLayer(target: target)
        case .not(let target):
            layer = makeNotLayer(target: target)
        case .phaseShift(let radians, let target):
            layer = makePhaseShiftLayer(radians: radians, target: target)
        case .controlledNot(let target, let control):
            layer = makeControlledNotLayer(target: target, control: control)
        case .oracle(let inputs):
            layer = makeOracleLayer(inputs: inputs)
        }

        return CircuitViewDescription(layers: layers + [layer])
    }
}

// MARK: - Private body

private extension CircuitViewDescription {

    // MARK: - Types

    enum Position {
        case qubit(index: Int)
        case lineHorizontal
        case crossedLines
        case hadamard
        case not
        case phaseShift(radians: Double)
        case controlledNotDown
        case controlledNotUp
        case controlUp
        case controlDown
        case oracle
        case oracleTop(inputs: [Int])
        case oracleBottom
        case oracleMiddleConnected
        case oracleMiddleUnconnected
    }

    // MARK: - Private methods

    func makeHadamardLayer(target: Int) -> [Position] {
        var layer = makeEmptyLayer()
        layer[target] = .hadamard

        return layer
    }

    func makeNotLayer(target: Int) -> [Position] {
        var layer = makeEmptyLayer()
        layer[target] = .not

        return layer
    }

    func makePhaseShiftLayer(radians: Double, target: Int) -> [Position] {
        var layer = makeEmptyLayer()
        layer[target] = .phaseShift(radians: radians)

        return layer
    }

    func makeControlledNotLayer(target: Int, control: Int) -> [Position] {
        var layer = makeEmptyLayer()

        let isTargetOnTop = (target < control)
        layer[target] = (isTargetOnTop ? .controlledNotDown : .controlledNotUp)
        layer[control] = (isTargetOnTop ? .controlUp : .controlDown)

        let step = (isTargetOnTop ? 1 : -1)
        for index in stride(from: (target + step), to: control, by: step) {
            layer[index] = .crossedLines
        }

        return layer
    }

    func makeOracleLayer(inputs: [Int]) -> [Position] {
        var layer = makeEmptyLayer()
        guard inputs.count > 1 else {
            layer[inputs[0]] = .oracle

            return layer
        }

        let sortedInputs = inputs.sorted()
        let first = sortedInputs.first!
        let last = sortedInputs.last!

        layer[first] = .oracleTop(inputs: inputs)
        for index in (first + 1)..<last {
            let isInputConnected = sortedInputs.contains(index)

            layer[index] = (isInputConnected ? .oracleMiddleConnected : .oracleMiddleUnconnected)
        }
        layer[last] = .oracleBottom

        return layer
    }

    func makeEmptyLayer() -> [Position] {
        return Array(repeating: Position.lineHorizontal, count: layers.first!.count)
    }
}
