//
//  RotationCircuitViewPosition.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/11/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

struct RotationCircuitViewPosition {

    // MARK: - Private properties

    private let axis: Gate.Axis
    private let radians: Double
    private let connected: CircuitViewPositionConnectivity.Target

    // MARK: - Internal init methods

    init(axis: Gate.Axis,
         radians: Double,
         connected: CircuitViewPositionConnectivity.Target = .none) {
        self.axis = axis
        self.radians = radians
        self.connected = connected
    }
}

// MARK: - Hashable methods

extension RotationCircuitViewPosition: Hashable {}

// MARK: - CircuitViewPosition methods

extension RotationCircuitViewPosition: CircuitViewPosition {
    func makePositionView(frame: CGRect) -> PositionView {
        var suffix = ""
        switch axis {
        case .x:
            suffix = "X"
        case .y:
            suffix = "Y"
        case .z:
            suffix = "Z"
        }

        var view = MatrixPositionView(frame: frame)
        view.text = String(format: "R%@(%@)", suffix, String(circuitViewPositionRadians: radians))
        view.configureConnectivity(PositionViewConnectivity(connected))

        return view
    }
}
