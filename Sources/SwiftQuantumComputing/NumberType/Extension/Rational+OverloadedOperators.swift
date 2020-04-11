//
//  Rational+OverloadedOperators.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/03/2020.
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

// MARK: - Overloaded operators

extension Rational {

    // MARK: - Internal operators

    static func -(lhs: Rational, rhs: Rational) -> Rational {
        var numerator = 0
        var denominator = 0
        if lhs.denominator == rhs.denominator {
            numerator = lhs.numerator - rhs.numerator
            denominator = lhs.denominator
        } else {
            numerator = lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator
            denominator = lhs.denominator * rhs.denominator
        }

        return try! Rational(numerator: numerator, denominator: denominator)
    }

    static func <(lhs: Rational, rhs: Rational) -> Bool {
        var lNumerator = lhs.numerator
        var rNumerator = rhs.numerator
        if lhs.denominator != rhs.denominator {
            lNumerator *= rhs.denominator
            rNumerator *= lhs.denominator
        }

        return lNumerator < rNumerator
    }

    static func <=(lhs: Rational, rhs: Rational) -> Bool {
        var lNumerator = lhs.numerator
        var rNumerator = rhs.numerator
        if lhs.denominator != rhs.denominator {
            lNumerator *= rhs.denominator
            rNumerator *= lhs.denominator
        }

        return lNumerator <= rNumerator
    }
}
