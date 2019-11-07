//
//  CircuitViewDrawer.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/12/2018.
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

struct CircuitViewDrawer {

    // MARK: - Private properties

    private let qubitCount: Int

    // MARK: - Internal init methods

    init(qubitCount: Int) throws {
        guard qubitCount > 0 else {
            throw MakeDrawerError.qubitCountHasToBeBiggerThanZero
        }

        self.qubitCount = qubitCount
    }
}

// MARK: - Drawable methods

extension CircuitViewDrawer: Drawable {
    func drawCircuit(_ circuit: [FixedGate]) throws -> SQCView {
        let container = makeContainerView(layerCount: (1 + circuit.count))

        var column = 0

        var layer = (0..<qubitCount).map { CircuitViewPosition.qubit(index: $0) }
        addLayer(layer, to: container, at: column)

        for gate in circuit {
            column += 1

            layer = try gate.makeLayer(qubitCount: qubitCount)
            addLayer(layer, to: container, at: column)
        }

        return container
    }
}

// MARK: - Private body

private extension CircuitViewDrawer {

    // MARK: - Constants

    enum Constants {
        static let positionSize = CGSize(width: 80, height: 80)
    }

    // MARK: - Private methods

    func makeContainerView(layerCount: Int) -> SQCView {
        let width = (CGFloat(layerCount) * Constants.positionSize.width)
        let height = (CGFloat(qubitCount) * Constants.positionSize.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        return SQCView(frame: frame)
    }

    func addLayer(_ layer: [CircuitViewPosition], to container: SQCView, at column: Int) {
        let positionsCount = layer.count

        for pos in 0..<positionsCount {
            let view = layer[pos].makePositionView(size: Constants.positionSize)

            #if os(macOS)
            let yMultiplier = CGFloat(pos)
            #else
            let yMultiplier = CGFloat(positionsCount - pos - 1)
            #endif
            view.frame.origin = CGPoint(x: CGFloat(column) * Constants.positionSize.width,
                                        y: yMultiplier * Constants.positionSize.height)

            container.addSubview(view)
        }
    }
}
