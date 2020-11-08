//
//  CircuitViewPosition.swift
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

// MARK: - Internal types

enum CircuitViewPosition {
    enum ControlConnectivity {
        case up
        case down
        case both
    }

    enum TargetConnectivity {
        case none
        case up
        case down
        case both
    }

    enum GapConnectivity {
        case none
        case up
        case down
        case both
    }

    case qubit(index: Int)
    case lineHorizontal
    case crossedLines
    case control(connected: ControlConnectivity)
    case oracle(connected: ControlConnectivity)
    case hadamard(connected: TargetConnectivity = .none)
    case not(connected: TargetConnectivity = .none)
    case phaseShift(radians: Double, connected: TargetConnectivity = .none)
    case rotation(axis: Gate.Axis, radians: Double, connected: TargetConnectivity = .none)
    case matrix(connected: TargetConnectivity = .none, showText: Bool = true)
    case matrixTop(connectedUp: Bool, showText: Bool = true)
    case matrixBottom(connectedDown: Bool)
    case matrixMiddle
    case matrixGap(connected: GapConnectivity = .none)
}

// MARK: - Hashable methods

extension CircuitViewPosition: Hashable {}
