//
//  ContinuedFractionsSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/03/2020.
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

/// [Continued Fractions](https://en.wikipedia.org/wiki/Continued_fraction) can be used to find an
/// approximation to a given `Rational` number
public struct ContinuedFractionsSolver {

    /// Errors throwed by `ContinuedFractionsSolver.findApproximation(of:differenceBelowOrEqual:)`
    public enum FindApproximationError: Error {
        /// Throwed if `limit` is zero or negative. Notice that a `limit` equal to zero, the approximation is the same
        /// provided `value`
        case limitHasToBeBiggerThanZero
        /// Throwed if `value` is zero or negative. Notice that the only possible approximation for zero is zero
        case valueHasToBeBiggerThanZero
    }

    /**
     Finds an approximation to a `value` with a difference below `limit`.

     - Parameter value: `Rational` number for which an approximation is required.
     - Parameter limit: `Rational` number that sets the maximum difference between the result and `value`.

     - Returns: A `Rational` number which distance to `value` is below or equal to `limit`.
     Or `FindApproximationError` error.
     */
    public static func findApproximation(of value: Rational,
                                         differenceBelowOrEqual limit: Rational) -> Result<Rational, FindApproximationError> {
        guard Rational.zero < value else {
            return .failure(.valueHasToBeBiggerThanZero)
        }

        guard Rational.zero < limit else {
            return .failure(.limitHasToBeBiggerThanZero)
        }

        var numerators = (0, 1)
        var denominators = (1, 0)

        var nextValue = try! Rational(numerator: 1, denominator: value.numerator)
        var remainder = value.denominator

        var result = Rational.zero

        while !((value - result).magnitude <= limit) {
            nextValue = try! Rational(numerator: nextValue.denominator, denominator: remainder)

            var quotient = 0
            (quotient, remainder) = nextValue.quotientAndRemainder()

            result = try! Rational(numerator: quotient * numerators.1 + numerators.0,
                                   denominator: quotient * denominators.1 + denominators.0)

            numerators.0 = numerators.1
            denominators.0 = denominators.1
            numerators.1 = result.numerator
            denominators.1 = result.denominator
        }

        return .success(result)
    }
}
