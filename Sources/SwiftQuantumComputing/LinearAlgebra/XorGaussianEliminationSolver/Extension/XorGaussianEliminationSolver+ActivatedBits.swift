//
//  XorGaussianEliminationSolver+ActivatedBits.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/01/2020.
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

extension XorGaussianEliminationSolver {

    // MARK: - Public methods

    /**
     Find all possible solutions for a system of XOR equations.

     - Parameter equations: List of equations where each equation is represented by a binary string. For example,
     the following equation: x2 ^ x0 = 0, is represented with this string: '101'.

     - Returns: A list of solutions where each solution is a binary string. If a system of equations if composed of variables:
     x0, x1 & x2 and in a given solution x1=0 while x0=1 & x2=1, the string for this solutions is: '101'
     */
    public func findActivatedVariablesInEquations(_ equations: [String]) -> [String] {
        let minCount = equations.reduce(0) { $0 > $1.count ? $0 : $1.count }
        let result = findActivatedVariablesInEquations(Set(equations.map { $0.activatedBits }))

        return result.map { String(activatedBits: Set($0), minCount: minCount) }
    }
}
