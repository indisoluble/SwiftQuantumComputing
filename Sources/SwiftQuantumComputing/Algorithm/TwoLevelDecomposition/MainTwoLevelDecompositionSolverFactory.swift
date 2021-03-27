//
//  MainTwoLevelDecompositionSolverFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/03/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

/// Conforms `TwoLevelDecompositionSolverFactory`. Use to create new `TwoLevelDecompositionSolver` instances
public struct MainTwoLevelDecompositionSolverFactory {

    // MARK: - Public types

    /// Define further decomposition of single qubits gates performed by
    /// `TwoLevelDecompositionSolver.decomposeGate(:restrictedToCircuitQubitCount:)`
    public enum SingleQubitGateDecomposition {
        /// Fully controlled two-level matrix gates are not further decomposed
        case none
        /// Fully controlled two-level matrix gates are decomposed using Cosine-Sine algorithm so the resulting sequence will
        /// be composed of not gates and fully controlled phase shifts, z-rotations, y-rotations & not gates
        case cosineSine
    }

    // MARK: - Private properties

    private let singleQubitGateDecomposer: SingleQubitGateDecompositionSolver

    // MARK: - Public init methods

    /// Initialize a `MainTwoLevelDecompositionSolverFactory` instance
    public init(singleQubitGateDecomposition: SingleQubitGateDecomposition = .cosineSine) {
        singleQubitGateDecomposer = MainTwoLevelDecompositionSolverFactory.makeSingleQubitSolver(decomposition: singleQubitGateDecomposition)
    }
}

// MARK: - TwoLevelDecompositionSolverFactory methods

extension MainTwoLevelDecompositionSolverFactory: TwoLevelDecompositionSolverFactory {

    /// Check `TwoLevelDecompositionSolverFactory.makeSolver()`
    public func makeSolver() -> TwoLevelDecompositionSolver {
        return TwoLevelDecompositionSolverFacade(singleQubitGateDecomposer: singleQubitGateDecomposer)
    }
}

// MARK: - Private body

private extension MainTwoLevelDecompositionSolverFactory {

    // MARK: - Private class methods

    static func makeSingleQubitSolver(decomposition: SingleQubitGateDecomposition) -> SingleQubitGateDecompositionSolver {
        switch decomposition {
        case .none:
            return DummySingleQubitGateDecompositionSolver()
        case .cosineSine:
            return CosineSineDecompositionSolver()
        }
    }
}
