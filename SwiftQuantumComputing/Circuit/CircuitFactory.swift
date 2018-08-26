//
//  CircuitFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
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

public struct CircuitFactory {

    // MARK: - Public class methods

    public static func makeEmptyCircuit(qubitCount: Int) -> Circuit? {
        guard let register = Register(qubitCount: qubitCount) else {
            return nil
        }

        let factory = CircuitGateFactoryAdapter(qubitCount: qubitCount)

        return GenericCircuit(register: register, factory: factory)
    }

    public static func makeRandomlyGeneratedCircuit(qubitCount: Int,
                                                    gateCount: Int,
                                                    gateMatrices: [Matrix]) -> Circuit? {
        guard ((qubitCount >= 0) && (gateCount >= 0)) else {
            return nil
        }

        let qubits = Array(0..<qubitCount)
        
        let gates = (0..<gateCount).map { (_) -> (matrix: Matrix, inputs: [Int])? in
            guard let matrix = gateMatrices.randomElement() else {
                return nil
            }

            let matrixQubitCount = Int.log2(matrix.rowCount)

            var inputs = qubits.shuffled()
            if (matrixQubitCount < qubitCount) {
                inputs = Array(inputs[..<matrixQubitCount])
            }

            return (matrix, inputs)
        }

        let emptyCircuit = makeEmptyCircuit(qubitCount: qubitCount)
        return gates.reduce(emptyCircuit) { (circuit, gate) -> Circuit? in
            guard let (matrix, inputs) = gate else {
                return circuit
            }

            return circuit?.applyingGate(builtWith: matrix, inputs: inputs)
        }
    }
}
