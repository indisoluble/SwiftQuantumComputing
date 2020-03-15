//
//  Int+QuotientAndRemainderWithDivisionType.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/02/2020.
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

extension Int {
    /// Type of division used in `Int.quotientAndRemainder(dividingBy:division:)`
    public enum DivisionType {
        /// Euclidean division
        case euclidean
        /// Floored division
        case floored
        /// Swift standard division
        case swift
    }

    /**
     Returns the quotient and remainder of this value after `division` by `other`.

     - Parameter other: Divisor.
     - Parameter division: A type of division.

     - Returns: Quotient and remainder of this value divided by `other`.

     Check [Modulo operation](https://en.wikipedia.org/wiki/Modulo_operation) for more details.
     */
    public func quotientAndRemainder(dividingBy other: Int,
                                     division: DivisionType) -> (quotient: Int, remainder: Int) {
        switch division {
        case .euclidean:
            let quotient = euclideanQuotient(dividingBy: other)

            return (quotient, self - other * quotient)
        case .floored:
            let quotient = flooredQuotient(dividingBy: other)

            return (quotient, self - other * quotient)
        case .swift:
            return quotientAndRemainder(dividingBy: other)
        }
    }
}

private extension Int {
    func flooredQuotient(dividingBy other: Int) -> Int {
        return Int((Double(self) / Double(other)).rounded(.down))
    }

    func euclideanQuotient(dividingBy other: Int) -> Int {
        return other.signum() * flooredQuotient(dividingBy: abs(other))
    }
}
