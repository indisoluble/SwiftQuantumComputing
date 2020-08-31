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
        case .hadamard:
            var view = MatrixPositionView(frame: frame)
            view.text = "H"
            view.configureConnectivity(.none)

            return view
        case .not:
            var view = MatrixPositionView(frame: frame)
            view.text = "X"
            view.configureConnectivity(.none)

            return view
        case .phaseShift(let radians):
            var view = MatrixPositionView(frame: frame)
            view.text =  String(format: "R(%.2f)", radians)
            view.configureConnectivity(.none)

            return view
        case .controlledNot:
            let view = ControlledNotPositionView(frame: frame)
            view.configureConnectivity(.both)

            return view
        case .controlledNotDown:
            let view = ControlledNotPositionView(frame: frame)
            view.configureConnectivity(.down)

            return view
        case .controlledNotUp:
            let view = ControlledNotPositionView(frame: frame)
            view.configureConnectivity(.up)

            return view
        case .control:
            let view = ControlPositionView(frame: frame)
            view.configureConnectivity(.both)

            return view
        case .controlDown:
            let view = ControlPositionView(frame: frame)
            view.configureConnectivity(.down)

            return view
        case .controlUp:
            let view = ControlPositionView(frame: frame)
            view.configureConnectivity(.up)

            return view
        case .matrix:
            var view = MatrixPositionView(frame: frame)
            view.text = "U"
            view.configureConnectivity(.none)

            return view
        case .matrixUp:
            var view = MatrixPositionView(frame: frame)
            view.text = "U"
            view.configureConnectivity(.up)

            return view
        case .matrixDown:
            var view = MatrixPositionView(frame: frame)
            view.text = "U"
            view.configureConnectivity(.down)

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
        case .matrixGap:
            return MatrixGapPositionView(frame: frame)
        case .matrixGapUp:
            return MatrixGapUpPositionView(frame: frame)
        case .matrixGapDown:
            return MatrixGapDownPositionView(frame: frame)
        case .oracle:
            let view = OraclePositionView(frame: frame)
            view.configureConnectivity(.both)

            return view
        case .oracleUp:
            let view = OraclePositionView(frame: frame)
            view.configureConnectivity(.up)

            return view
        case .oracleDown:
            let view = OraclePositionView(frame: frame)
            view.configureConnectivity(.down)

            return view
        }
    }
}
