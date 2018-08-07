//
//  Polar.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/07/2018.
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

// MARK: - Main body

struct Polar {

    // MARK: - Public properties

    let magnitude: Double
    let phase: Double

    // MARK: - Init methods

    init(magnitude: Double, phase: Double) {
        self.magnitude = magnitude
        self.phase = phase
    }

    init(_ complex: Complex) {
        let magnitude = complex.modulus
        let phase = atan(complex.imag / complex.real)

        self.init(magnitude: magnitude, phase: phase)
    }

    // MARK: - Public methods

    func normalized() -> Polar {
        let angleCircunference = (2 * Double.pi)

        var normalizedPhase = phase.truncatingRemainder(dividingBy: angleCircunference)
        if (normalizedPhase < 0) {
            normalizedPhase += angleCircunference
        }

        return Polar(magnitude: magnitude, phase: normalizedPhase)
    }
}

// MARK: - CustomStringConvertible methods

extension Polar: CustomStringConvertible {
    var description: String {
        return "(\(magnitude),\(phase)rad)"
    }
}

// MARK: - Overloaded operators

extension Polar {
    static func *(lhs: Polar, rhs: Polar) -> Polar {
        let magnitude = (lhs.magnitude * rhs.magnitude)
        let phase = (lhs.phase + rhs.phase)

        return Polar(magnitude: magnitude, phase: phase)
    }

    static func /(lhs: Polar, rhs: Polar) -> Polar {
        let magnitude = (lhs.magnitude / rhs.magnitude)
        let phase = (lhs.phase - rhs.phase)

        return Polar(magnitude: magnitude, phase: phase)
    }
}
