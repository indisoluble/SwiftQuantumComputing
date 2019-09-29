//
//  CircuitFacade.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/08/2018.
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

struct CircuitFacade {

    // MARK: - Circuit properties

    let gates: [FixedGate]

    // MARK: - Private properties

    private let statevectorSimulator: StatevectorSimulator

    // MARK: - Internal init methods

    init(gates: [FixedGate], statevectorSimulator: StatevectorSimulator) {
        self.gates = gates
        self.statevectorSimulator = statevectorSimulator
    }
}

// MARK: - CustomStringConvertible methods

extension CircuitFacade: CustomStringConvertible {
    var description: String {
        return gates.description
    }
}

// MARK: - Circuit methods

extension CircuitFacade: Circuit {
    func measure(qubits: [Int], afterInputting bits: String) throws -> [Double] {
        guard qubits.count > 0 else {
            throw MeasureError.qubitsCanNotBeAnEmptyList
        }

        guard CircuitFacade.areQubitsUnique(qubits) else {
            throw MeasureError.qubitsAreNotUnique
        }

        guard CircuitFacade.areQubitsSorted(qubits) else {
            throw MeasureError.qubitsAreNotSorted
        }

        let statevector = try statevectorSimulator.statevector(afterInputting: bits, in: gates)

        guard CircuitFacade.areQubitsInsideBounds(qubits, of: statevector) else {
            throw MeasureError.qubitsAreNotInsideBounds
        }

        var result = Array(repeating: Double(0), count: Int.pow(2, qubits.count))

        for index in 0..<statevector.count {
            let derivedIndex = index.derived(takingBitsAt: qubits)
            let measure = statevector[index].squaredModulus

            result[derivedIndex] += measure
        }

        return result
    }
}

// MARK: - Private body

private extension CircuitFacade {

    // MARK: - Private class methods

    static func areQubitsUnique(_ qubits: [Int]) -> Bool {
        return (qubits.count == Set(qubits).count)
    }

    static func areQubitsSorted(_ qubits: [Int]) -> Bool {
        return (qubits == qubits.sorted(by: >))
    }

    static func areQubitsInsideBounds(_ qubits: [Int], of vector: Vector) -> Bool {
        let qubitCount = Int.log2(vector.count)
        let validQubits = (0..<qubitCount)

        return qubits.allSatisfy { validQubits.contains($0) }
    }
}
