//
//  XorGaussianEliminationSolverFacade.swift
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

// MARK: - Main body

struct XorGaussianEliminationSolverFacade {

    // MARK: - Private properties

    private let solver: XorEquationSystemSimpleSolver

    // MARK: - Internal init methods

    init(solver: XorEquationSystemSimpleSolver) {
        self.solver = solver
    }
}

// MARK: - XorGaussianEliminationSolver methods

extension XorGaussianEliminationSolverFacade: XorGaussianEliminationSolver {
    func findActivatedVariablesInEquations(_ equations: Set<Set<Int>>) -> [[Int]] {
        var solverEquations: [[XorEquationComponent]] = []

        var next = equations
        for variable in Set(equations.flatMap { $0 }).sorted(by: >) {
            guard let index = next.firstIndex(where: { $0.contains(variable) }) else {
                continue
            }

            let equation = next.remove(at: index)

            let solverEquation = equation.map { XorEquationComponent.variable(id: $0) }
            solverEquations.append(solverEquation)

            next = Set(next.map {
                return ($0.contains(variable) ? $0.symmetricDifference(equation) : $0)
            })
        }

        return solver.findActivatedVariablesInEquations(solverEquations)
    }
}
