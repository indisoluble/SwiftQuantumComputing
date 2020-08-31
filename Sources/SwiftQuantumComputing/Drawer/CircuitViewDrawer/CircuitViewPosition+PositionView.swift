//
//  CircuitViewPosition+PositionView.swift
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

extension CircuitViewPosition {

    // MARK: - Internal methods

    func makePositionView(size: CGSize) -> PositionView {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        switch self {
        case .qubit(let index):
            var view = QubitPositionView(frame: frame)
            view.text = "q\(index):"

            return view
        case .lineHorizontal:
            return LineHorizontalPositionView(frame: frame)
        case .crossedLines:
            return CrossedLinesPositionView(frame: frame)
        case .control(let connected):
            let view = ControlPositionView(frame: frame)
            view.configureConnectivity(PositionViewConnectivity(connected))

            return view
        case .oracle(let connected):
            let view = OraclePositionView(frame: frame)
            view.configureConnectivity(PositionViewConnectivity(connected))

            return view
        case .hadamard(let connected):
            var view = MatrixPositionView(frame: frame)
            view.text = "H"
            view.configureConnectivity(PositionViewConnectivity(connected))

            return view
        case .not(let connected):
            switch connected {
            case .none:
                var view = MatrixPositionView(frame: frame)
                view.text = "X"
                view.configureConnectivity(.none)

                return view
            default:
                let view = ControlledNotPositionView(frame: frame)
                view.configureConnectivity(PositionViewConnectivity(connected))

                return view
            }
        case .phaseShift(let radians, let connected):
            var view = MatrixPositionView(frame: frame)
            view.text = String(format: "R(%.2f)", radians)
            view.configureConnectivity(PositionViewConnectivity(connected))

            return view
        case .matrix(let connected):
            var view = MatrixPositionView(frame: frame)
            view.text = "U"
            view.configureConnectivity(PositionViewConnectivity(connected))

            return view
        case .matrixTop(let connected, let showText):
            var view = MatrixTopPositionView(frame: frame)
            view.text = (showText ? "U" : "")
            view.isConnected = connected

            return view
        case .matrixBottom(let connected):
            var view = MatrixBottomPositionView(frame: frame)
            view.isConnected = connected

            return view
        case .matrixMiddle:
            return MatrixMiddlePositionView(frame: frame)
        case .matrixGap(let connected):
            switch connected {
            case .none:
                return MatrixGapPositionView(frame: frame)
            case .up:
                return MatrixGapUpPositionView(frame: frame)
            case .down:
                return MatrixGapDownPositionView(frame: frame)
            }
        }
    }
}
