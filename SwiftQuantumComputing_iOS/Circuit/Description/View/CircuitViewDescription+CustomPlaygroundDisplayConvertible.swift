//
//  CircuitViewDescription+CustomPlaygroundDisplayConvertible.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/10/2018.
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

import UIKit

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitViewDescription: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        let container = makeContainerView()
        let layerStack = makeLayerStack(container: container)

        for layer in layers {
            let positions = layer.reversed()
            let views = positions.map { $0.makePositionView(size: Constants.positionSize) }
            let viewStack = makePositionStack(positions: views)

            layerStack.addArrangedSubview(viewStack)
        }

        container.addSubview(layerStack)

        return container
    }
}

// MARK: - Private body

private extension CircuitViewDescription {

    // MARK: - Constants

    enum Constants {
        static let positionSize = CGSize(width: 80, height: 80)
    }

    // MARK: - Private methods

    func makeContainerView() -> UIView {
        let width = (CGFloat(layers.count) * Constants.positionSize.width)
        let height = (CGFloat(qubitCount) * Constants.positionSize.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        return UIView(frame: frame)
    }

    func makeLayerStack(container: UIView) -> UIStackView {
        let stack = UIStackView(frame: container.bounds)
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        return stack
    }

    func makePositionStack(positions: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: positions)
        stack.axis = .vertical
        stack.distribution = .fillEqually

        return stack
    }
}
