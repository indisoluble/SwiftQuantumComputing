//
//  XorEquationSystemBruteForceSolver.swift
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

struct XorEquationSystemBruteForceSolver {

    // MARK: - Private properties

    private let factory: XorEquationSystemFactory

    // MARK: - Internal init methods

    init(factory: XorEquationSystemFactory) {
        self.factory = factory
    }
}

// MARK: - XorEquationSystemSimpleSolver methods

extension XorEquationSystemBruteForceSolver: XorEquationSystemSimpleSolver {
    func findSolutions(for equations: [Equation]) -> [ActivatedVariables] {
        let combinations = extractVariableIds(from: equations).combinations()
        let system = factory.makeSystem(equations: equations)

        return combinations.filter { system.solves(activatingVariables: $0) }
    }
}

// MARK: - Private body

private extension XorEquationSystemBruteForceSolver {

    // MARK: - Private methods

    func extractVariableIds(from equations: [Equation]) -> [Int] {
        var ids: Set<Int> = []

        for equation in equations {
            for case .variable(let id) in equation {
                ids.update(with: id)
            }
        }

        return Array(ids)
    }
}
