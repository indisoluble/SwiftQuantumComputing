//
//  MainXorGaussianEliminationSolverFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/01/2020.
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

/// Conforms `XorGaussianEliminationSolverFactory`. Use to create new `XorGaussianEliminationSolver` instances
public struct MainXorGaussianEliminationSolverFactory {

    // MARK: - Public init methods

    /// Initialize a `MainXorGaussianEliminationSolverFactory` instance
    public init() {}
}

// MARK: - XorGaussianEliminationSolverFactory methods

extension MainXorGaussianEliminationSolverFactory: XorGaussianEliminationSolverFactory {

    /// Check `XorGaussianEliminationSolverFactory.makeSolver()`
    public func makeSolver() -> XorGaussianEliminationSolver {
        let systemFactory = XorEquationSystemFactoryAdapter()
        let bruteForceSolver = XorEquationSystemBruteForceSolver(factory: systemFactory)
        let preSolver = XorEquationSystemPreSimplificationSolver(solver: bruteForceSolver)

        return XorGaussianEliminationSolverFacade(solver: preSolver)
    }
}
