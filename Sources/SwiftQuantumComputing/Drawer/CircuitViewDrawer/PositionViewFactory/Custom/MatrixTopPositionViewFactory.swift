//
//  MatrixTopPositionViewFactory.swift
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

struct MatrixTopPositionViewFactory {

    // MARK: - Private properties

    private let connectedUp: Bool
    private let showText: Bool

    // MARK: - Internal init methods

    init(connectedUp: Bool, showText: Bool = true) {
        self.connectedUp = connectedUp
        self.showText = showText
    }
}

// MARK: - Hashable methods

extension MatrixTopPositionViewFactory: Hashable {}

// MARK: - PositionViewFactory methods

extension MatrixTopPositionViewFactory: PositionViewFactory {
    func makePositionView(frame: CGRect) -> PositionView {
        var view = MatrixTopPositionView(frame: frame)
        view.text = (showText ? "U" : "")
        view.isConnected = connectedUp

        return view
    }
}
