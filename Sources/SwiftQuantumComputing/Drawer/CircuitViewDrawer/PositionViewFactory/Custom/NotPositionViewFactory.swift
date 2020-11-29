//
//  NotPositionViewFactory.swift
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

struct NotPositionViewFactory {

    // MARK: - Private properties

    private let connected: PositionViewFactoryConnectivity.Target

    // MARK: - Internal init methods

    init(connected: PositionViewFactoryConnectivity.Target = .none) {
        self.connected = connected
    }
}

// MARK: - Hashable methods

extension NotPositionViewFactory: Hashable {}

// MARK: - PositionViewFactory methods

extension NotPositionViewFactory: PositionViewFactory {
    func makePositionView(frame: CGRect) -> PositionView {
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
    }
}
