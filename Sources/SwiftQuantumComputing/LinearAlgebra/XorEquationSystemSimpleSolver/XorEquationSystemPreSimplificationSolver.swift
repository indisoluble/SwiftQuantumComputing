//
//  XorEquationSystemPreSimplificationSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/01/2020.
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

struct XorEquationSystemPreSimplificationSolver {

    // MARK: - Private properties

    private let solver: XorEquationSystemSimpleSolver

    // MARK: - Internal init methods

    init(solver: XorEquationSystemSimpleSolver) {
        self.solver = solver
    }
}

// MARK: - XorEquationSystemSimpleSolver methods

extension XorEquationSystemPreSimplificationSolver: XorEquationSystemSimpleSolver {
    func findActivatedVariablesInEquations(_ equations: [[XorEquationComponent]]) -> [[Int]] {
        guard !equations.isEmpty else {
            return []
        }

        var activated: [Int] = []

        var next = equations
        while let index = next.firstIndex(where: { countVariables(in: $0) == 1 }) {
            let (ids, constant) = reduceConstants(in: next.remove(at: index))

            if constant {
                activated.append(ids[0])
            }

            next = next.map { simplifyEquantion($0, replacingVariable: ids[0], with: constant) }
        }

        return (next.isEmpty ?
            [activated] :
            solver.findActivatedVariablesInEquations(next).map { $0 + activated })
    }
}

// MARK: - Private body

private extension XorEquationSystemPreSimplificationSolver {

    // MARK: - Private types

    typealias SingleConstantEquation = (variableIds: [Int], constantActivated: Bool)

    // MARK: - Private methods

    func countVariables(in equation: [XorEquationComponent]) -> Int {
        var count = 0
        for case .variable(_) in equation {
            count += 1
        }

        return count
    }

    func reduceConstants(in equation: [XorEquationComponent]) -> SingleConstantEquation {
        return equation.reduce(([], false) as SingleConstantEquation) { (acc, component) in
            switch component {
            case .variable(let id):
                return (acc.variableIds + [id], acc.constantActivated)
            case .constant(let activated):
                return (acc.variableIds, acc.constantActivated ^ activated)
            }
        }
    }

    func simplifyEquantion(_ equation: [XorEquationComponent],
                           replacingVariable variableId: Int,
                           with constant: Bool) -> [XorEquationComponent] {
        return equation.map { component in
            if case .variable(let id) = component, id == variableId {
                return .constant(activated: constant)
            }

            return component
        }
    }
}
