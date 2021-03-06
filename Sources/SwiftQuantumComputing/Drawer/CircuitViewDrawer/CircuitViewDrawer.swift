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

struct CircuitViewDrawer {}

// MARK: - Drawable methods

extension CircuitViewDrawer: Drawable {
    func drawCircuit(_ circuit: [Gate], qubitCount: Int) -> Result<SQCView, DrawCircuitError> {
        guard qubitCount > 0 else {
            return .failure(.qubitCountHasToBeBiggerThanZero)
        }

        let container = makeContainerView(layerCount: (1 + circuit.count), qubitCount: qubitCount)

        var column = 0

        let layer = (0..<qubitCount).map { QubitPositionViewFactory(index: $0) }
        addLayer(layer, to: container, at: column)

        for gate in circuit {
            column += 1

            switch gate.makeLayer(qubitCount: qubitCount) {
            case .success(let layer):
                addLayer(layer, to: container, at: column)
            case .failure(let error):
                return .failure(error)
            }
        }

        return .success(container)
    }
}

// MARK: - Private body

private extension CircuitViewDrawer {

    // MARK: - Constants

    enum Constants {
        static let positionSize = CGSize(width: 80, height: 80)
    }

    // MARK: - Private methods

    func makeContainerView(layerCount: Int, qubitCount: Int) -> SQCView {
        let width = (CGFloat(layerCount) * Constants.positionSize.width)
        let height = (CGFloat(qubitCount) * Constants.positionSize.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        return SQCView(frame: frame)
    }

    func addLayer(_ layer: [PositionViewFactory], to container: SQCView, at column: Int) {
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
