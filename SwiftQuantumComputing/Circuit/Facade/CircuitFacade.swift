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
import os.log

// MARK: - Main body

struct CircuitFacade {

    // MARK: - Internal properties

    let qubitCount: Int

    // MARK: - Private properties

    private let circuit: [Gate]
    private let drawer: Drawable
    private let backend: Backend

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init?(circuit: [Gate], drawer: Drawable, qubitCount: Int, backend: Backend) {
        guard qubitCount > 0 else {
            os_log("init: a circuit has to have at least 1 qubit",
                   log: CircuitFacade.logger,
                   type: .debug)

            return nil
        }

        self.circuit = circuit
        self.drawer = drawer
        self.qubitCount = qubitCount
        self.backend = backend
    }
}

// MARK: - CustomStringConvertible methods

extension CircuitFacade: CustomStringConvertible {
    var description: String {
        return "Circuit with \(qubitCount) qubits & \(circuit.count) gates"
    }
}

// MARK: - CustomPlaygroundDisplayConvertible methods

extension CircuitFacade: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        return drawer.drawCircuit(circuit)
    }
}

// MARK: - Circuit methods

extension CircuitFacade: Circuit {
    func applyingGate(_ gate: Gate) -> CircuitFacade {
        return CircuitFacade(circuit: (circuit + [gate]),
                             drawer: drawer,
                             qubitCount: qubitCount,
                             backend: backend)!
    }

    func measure(qubits: [Int]) -> [Double]? {
        return backend.measureQubits(qubits, in: circuit)
    }
}
