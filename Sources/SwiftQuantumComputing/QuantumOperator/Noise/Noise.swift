//
//  Noise.swift
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

/// A generic quantum noise operator
public struct Noise {

    // MARK: - Internal types

    typealias InternalNoise = RawInputsExtracting &
        SimulatorKrausMatrixExtracting &
        SimplifiedNoiseConvertible

    // MARK: - Internal properties

    let noise: InternalNoise
    let noiseHash: AnyHashable

    // MARK: - Internal init methods

    init<T: InternalNoise & Hashable>(noise: T) {
        self.noise = noise

        noiseHash = AnyHashable(noise)
    }
}

// MARK: - Hashable methods

extension Noise: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.noiseHash == rhs.noiseHash
    }

    public func hash(into hasher: inout Hasher) {
        noiseHash.hash(into: &hasher)
    }
}

// MARK: - SimplifiedNoiseConvertible methods

extension Noise: SimplifiedNoiseConvertible {
    /// Check `SimplifiedNoiseConvertible.simplified`
    public var simplified: SimplifiedNoise {
        return noise.simplified
    }
}
