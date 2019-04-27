//
//  ConfigurableGeneticGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/01/2019.
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

struct ConfigurableGeneticGate {

    // MARK: - Private properties

    private let inputs: [Int]

    // MARK: - Internal init methods

    init(inputs: [Int]) {
        self.inputs = inputs
    }
}

// MARK: - GeneticGate methods

extension ConfigurableGeneticGate: GeneticGate {
    func makeFixed(truthTable: [String], truthTableQubitCount: Int) throws -> Fixed {
        var oracle: OracleGate!
        do {
            oracle = try OracleGate(truthTable: truthTable,
                                    truthTableQubitCount: truthTableQubitCount)
        } catch OracleGate.InitError.truthTableQubitCountHasToBeBiggerThanZero {
            throw GeneticError.useCaseTruthTableQubitCountHasToBeBiggerThanZeroToMakeOracle
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        let gate = try oracle.makeFixed(inputs: inputs)

        return (gate: gate, didUseTruthTable: true)
    }
}
