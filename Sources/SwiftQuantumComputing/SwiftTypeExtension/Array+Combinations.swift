//
//  Array+Combinations.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/12/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

extension Array {
    func combinations() -> Array<Self> {
        guard count > 0 else {
            return []
        }

        return (0...count).flatMap { combinations(startingAt: 0, count: $0) }
    }
}

private extension Array {
    func combinations(startingAt index: Int, count: Int) -> Array<Self> {
        guard count > 0 else {
            return [[]]
        }

        guard count > 1 else {
            return self[index...].map { [$0] }
        }

        let maxIndex = (self.count - count)
        return (index...maxIndex).flatMap { i in
            return combinations(startingAt: i + 1, count: count - 1).map { [self[i]] + $0 }
        }
    }
}
