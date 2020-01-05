//
//  XorEquationSystemAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/12/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

struct XorEquationSystemAdapter {

    // MARK: - Private properties

    private let equations: [XorEquationSystemSimpleSolver.Equation]

    // MARK: - Internal init methods

    init(equations: [XorEquationSystemSimpleSolver.Equation]) {
        self.equations = equations
    }
}

// MARK: - XorEquationSystem methods

extension XorEquationSystemAdapter: XorEquationSystem {
    func solves(activatingVariables variables: XorEquationSystemSimpleSolver.ActivatedVariables) -> Bool {
        return equations.reduce(true) { (acc, equation) in
            return acc && !XorEquationSystemAdapter.value(of: equation,
                                                          activatedVariables: variables)
        }
    }
}

// MARK: - Private body

private extension XorEquationSystemAdapter {

    // MARK: - Private class methods

    static func value(of equation: XorEquationSystemSimpleSolver.Equation,
                      activatedVariables: XorEquationSystemSimpleSolver.ActivatedVariables) -> Bool {
        return equation.reduce(false) { (acc, component) in
            return acc ^ XorEquationSystemAdapter.value(of: component,
                                                        activatedVariables: activatedVariables)
        }
    }

    static func value(of component: XorEquationComponent,
                      activatedVariables: XorEquationSystemSimpleSolver.ActivatedVariables) -> Bool {
        switch component {
        case .constant(let activated):
            return activated
        case .variable(let id):
            return activatedVariables.contains(id)
        }
    }
}
