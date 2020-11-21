//
//  GateCircuitView.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/11/2020.
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

// MARK: - Protocol definition

protocol GateCircuitView {
    func makePositionView(index: Int, inputs: [Int], controls: [Int]) -> AnyCircuitViewPosition
}

// MARK: - GateCircuitView default implementations

extension GateCircuitView where Self: SingleQubitGateCircuitView {
    func makePositionView(index: Int, inputs: [Int], controls: [Int]) -> AnyCircuitViewPosition {
        if controls.isEmpty {
            return makePositionView(connected: .none)
        }

        if target < controls.min()! {
            return makePositionView(connected: .up)
        }

        if target > controls.max()! {
            return makePositionView(connected: .down)
        }

        return makePositionView(connected: .both)
    }
}
