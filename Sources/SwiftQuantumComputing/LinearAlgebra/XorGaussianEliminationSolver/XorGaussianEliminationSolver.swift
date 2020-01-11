//
//  XorGaussianEliminationSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/01/2020.
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

// MARK: - Protocol definition

/**
 Implementation of Gaussian elimination algorithm for system of XOR equations, i.e. equations like the following:
 x2 ^ x1 ^ x0 = 0.
 */
public protocol XorGaussianEliminationSolver {

    /**
     Find all possible solutions for a system of XOR equations.

     - Parameter equations: Set of equations where each equation is represented by a set of indexes. For example,
     the following equation: x2 ^ x0 = 0, is represented with this set: (2, 0).

     - Returns: A list of solutions where each solution is a list of indexes. If a system of equations if composed of variables:
     x0, x1 & x2 and in a given solution x1=0 while x0=1 & x2=1, the list of indexes for this solutions is: (2, 0)
     */
    func findActivatedVariablesInEquations(_ equations: Set<Set<Int>>) -> [[Int]]
}
