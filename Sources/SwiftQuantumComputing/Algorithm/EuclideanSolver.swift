//
//  EuclideanSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/02/2020.
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

/// Euclidean algorithm is a method for computing the Greatest Common Divisor of two numbers
public struct EuclideanSolver {

    /**
     Finds the Greatest Common Divisor (GCD) of `a` and `b`.

     - Parameter a: One integer.
     - Parameter b: Other integer.

     - Returns: GCD of `a` and `b`.

     Check [Euclidean algorithm](https://en.wikipedia.org/wiki/Euclidean_algorithm) for more details.
     */
    public static func findGreatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        var v1 = a
        var v2 = b
        while v2 != 0 {
            let temp = v2
            v2 = v1.quotientAndRemainder(dividingBy: v2, division: .euclidean).remainder
            v1 = temp
        }
        return v1
    }
}
