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

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func randomlyApplyingGates(builtWith matrices: [Matrix], depth: Int) -> Self? {
        let qubits = Array(0..<self.qubitCount)

        return applyingGates(randomlySelectedWith: { matrices.randomElement() },
                             on: { qubits.shuffled() },
                             depth: depth)
    }

    func applyingGates(randomlySelectedWith randomMatrix:(() -> Matrix?),
                       on shuffledQubits:(() -> [Int]),
                       depth: Int) -> Self? {
        guard (depth >= 0) else {
            return nil
        }

        let gates = (0..<depth).map { (_) -> (matrix: Matrix, inputs: [Int])? in
            guard let matrix = randomMatrix() else {
                return nil
            }

            let matrixQubitCount = Int.log2(matrix.rowCount)

            var inputs = shuffledQubits()
            if (matrixQubitCount < inputs.count) {
                inputs = Array(inputs[..<matrixQubitCount])
            }

            return (matrix, inputs)
        }

        return gates.reduce(self) { (circuit, gate) -> Self? in
            guard let (matrix, inputs) = gate else {
                return circuit
            }

            return circuit?.applyingGate(builtWith: matrix, inputs: inputs)
        }
    }
}
