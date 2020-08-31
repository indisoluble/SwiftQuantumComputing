//
//  PositionViewFullyConnectable.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/08/2020.
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

// MARK: - Internal types

enum PositionViewConnectivity {
    case none
    case up
    case down
    case both

    // MARK: - Internal init methods

    init(_ connectivity: CircuitViewPosition.ControlConnectivity) {
        switch connectivity {
        case .up:
            self = .up
        case .down:
            self = .down
        case .both:
            self = .both
        }
    }

    init(_ connectivity: CircuitViewPosition.TargetConnectivity) {
        switch connectivity {
        case .none:
            self = .none
        case .up:
            self = .up
        case .down:
            self = .down
        case .both:
            self = .both
        }
    }
}

// MARK: - Protocol definition

protocol PositionViewFullyConnectable {
    var connectionUp: SQCView! { get }
    var conenctionDown: SQCView! { get }
}

// MARK: - PositionViewFullyConnectable default implementations

extension PositionViewFullyConnectable {
    func configureConnectivity(_ connectivity: PositionViewConnectivity) {
        switch connectivity {
        case .none:
            connectionUp.isHidden = true
            conenctionDown.isHidden = true
        case .up:
            connectionUp.isHidden = false
            conenctionDown.isHidden = true
        case .down:
            connectionUp.isHidden = true
            conenctionDown.isHidden = false
        case .both:
            connectionUp.isHidden = false
            conenctionDown.isHidden = false
        }
    }
}
