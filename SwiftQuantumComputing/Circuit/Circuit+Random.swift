//
//  Circuit+Random.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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
import os.log

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func randomlyApplyingGates(_ gates: [CircuitGate], depth: Int) -> Self? {
        let qubits = Array(0..<self.qubitCount)

        return applyingGates(randomlySelectedWith: { gates.randomElement() },
                             on: { qubits.shuffled() },
                             depth: depth)
    }

    // MARK: - Internal methods

    func applyingGates(randomlySelectedWith randomGate:(() -> CircuitGate?),
                       on shuffledQubits:(() -> [Int]),
                       depth: Int) -> Self? {
        guard (depth >= 0) else {
            os_log("applyingGates failed: pass depth bigger than 0",
                   log: LoggerFactory.makeLogger(),
                   type: .debug)

            return nil
        }

        let tuples = (0..<depth).map { (_) -> (CircuitGate, [Int])? in
            guard let gate = randomGate() else {
                return nil
            }

            let matrixQubitCount = Int.log2(gate.matrix.rowCount)

            var inputs = shuffledQubits()
            if (matrixQubitCount < inputs.count) {
                inputs = Array(inputs[..<matrixQubitCount])
            }

            return (gate, inputs)
        }

        return tuples.reduce(self) { (circuit, tuple) -> Self? in
            guard let (gate, inputs) = tuple else {
                return circuit
            }

            return circuit?.applyingGate(gate, inputs: inputs)
        }
    }
}
