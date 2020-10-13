//
//  TwoLevelDecompositionSolver+Gates.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/10/2020.
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

extension TwoLevelDecompositionSolver {

    // MARK: - Internal class methods

    enum DecomposeGatesError: Error, Equatable {
        case gateThrowedError(gate: Gate, error: GateError)
    }

    static func decomposeGates(_ gates: [Gate],
                               restrictedToCircuitQubitCount qubitCount: Int) -> Result<[Gate], DecomposeGatesError> {
        var result: [Gate] = []
        for gate in gates {
            switch decomposeGate(gate, restrictedToCircuitQubitCount: qubitCount) {
            case .success(let decomposition):
                result.append(contentsOf: decomposition)
            case .failure(let error):
                return .failure(.gateThrowedError(gate: gate, error: error))
            }
        }

        return .success(result)
    }
}
