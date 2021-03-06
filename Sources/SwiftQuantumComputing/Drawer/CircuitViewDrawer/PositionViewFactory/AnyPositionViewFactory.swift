//
//  AnyPositionViewFactory.swift
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

struct AnyPositionViewFactory {

    // MARK: - Private properties

    private let factory: PositionViewFactory
    private let anyHash: AnyHashable

    // MARK: - Internal init methods

    init<T: PositionViewFactory & Hashable>(circuitViewPosition: T) {
        factory = circuitViewPosition
        anyHash = AnyHashable(circuitViewPosition)
    }
}

// MARK: - Hashable methods

extension AnyPositionViewFactory: Hashable {
    static func == (lhs: AnyPositionViewFactory, rhs: AnyPositionViewFactory) -> Bool {
        return lhs.anyHash == rhs.anyHash
    }

    func hash(into hasher: inout Hasher) {
        anyHash.hash(into: &hasher)
    }
}

// MARK: - PositionViewFactory methods

extension AnyPositionViewFactory: PositionViewFactory {
    func makePositionView(frame: CGRect) -> PositionView {
        return factory.makePositionView(frame: frame)
    }
}
