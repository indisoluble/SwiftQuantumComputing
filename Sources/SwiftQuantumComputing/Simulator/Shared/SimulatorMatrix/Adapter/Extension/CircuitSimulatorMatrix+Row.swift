//
//  CircuitSimulatorMatrix+Row.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/06/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

extension CircuitSimulatorMatrix {
    enum RowError: Error {
        case indexOutOfRange
        case passMaxConcurrencyBiggerThanZero
    }

    func row(_ index: Int, maxConcurrency: Int) -> Result<Vector, RowError> {
        guard index >= 0 && index < count else {
            return .failure(.indexOutOfRange)
        }

        switch Vector.makeVector(count: count,
                                 maxConcurrency: maxConcurrency,
                                 value: { self[index, $0] }) {
        case .success(let vector):
            return .success(vector)
        case .failure(.passMaxConcurrencyBiggerThanZero):
            return .failure(.passMaxConcurrencyBiggerThanZero)
        case .failure(.passCountBiggerThanZero):
            fatalError("Unexpected error.")
        }
    }
}
