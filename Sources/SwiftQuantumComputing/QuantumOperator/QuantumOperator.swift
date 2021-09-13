//
//  QuantumOperator.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/09/2021.
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

/// A generic quantum operator
public struct QuantumOperator {

    // MARK: - Internal types

    typealias InternalOperator = RawInputsExtracting &
        SimulatorKrausMatrixExtracting &
        SimplifiedQuantumOperatorConvertible

    // MARK: - Internal properties

    let quantumOperator: InternalOperator
    let quantumOperatorHash: AnyHashable

    // MARK: - Internal init methods

    init<T: InternalOperator & Hashable>(quantumOperator: T) {
        self.quantumOperator = quantumOperator

        quantumOperatorHash = AnyHashable(quantumOperator)
    }
}

// MARK: - Hashable methods

extension QuantumOperator: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.quantumOperatorHash == rhs.quantumOperatorHash
    }

    public func hash(into hasher: inout Hasher) {
        quantumOperatorHash.hash(into: &hasher)
    }
}

// MARK: - SimplifiedQuantumOperatorConvertible methods

extension QuantumOperator: SimplifiedQuantumOperatorConvertible {
    /// Check `SimplifiedQuantumOperatorConvertible.simplified`
    public var simplified: SimplifiedQuantumOperator {
        return quantumOperator.simplified
    }
}
