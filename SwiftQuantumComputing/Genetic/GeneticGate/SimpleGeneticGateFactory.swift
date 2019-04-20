//
//  SimpleGeneticGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/01/2019.
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

struct SimpleGeneticGateFactory {

    // MARK: - Private properties

    private let gate: Gate

    // MARK: - Internal init methods

    init(gate: Gate) {
        self.gate = gate
    }
}

// MARK: - GeneticGateFactory methods

extension SimpleGeneticGateFactory: GeneticGateFactory {
    func makeGate(inputs: [Int]) throws -> GeneticGate {
        var fixedGate: FixedGate!
        do {
            fixedGate = try gate.makeFixed(inputs: inputs)
        } catch GateMakeFixedError.notEnoughInputsToProduceAGate {
            throw GeneticGateFactoryMakeGateError.notEnoughInputsToProduceAGeneticGate(with: gate)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        return SimpleGeneticGate(gate: fixedGate)
    }
}
