//
//  main.swift
//  SQCMeasurePerformance
//
//  Created by Enrique de la Torre on 01/05/2021.
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

import ArgumentParser

enum Mode: String, CaseIterable, ExpressibleByArgument {
    case fullMatrix
    case rowByRow
    case elementByElement
    case direct
}

enum Circuit: String, CaseIterable, ExpressibleByArgument {
    case hadamards
    case halfHadamardsHalfNots
    case controlledHadamards
    case fullyControlledHadamards
    case oracleHadamards
}

struct SQCMeasurePerformance: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Calculate how long it takes to produce a statevector",
        discussion: """
            This application provides multiple configuration options, try
            different values to check the performance of this quantum
            circuit simulator in your computer.
            """
    )

    @Option(name: .shortAndLong,
            help: "Execution mode: \(Mode.allCases.map({ "\($0)" }).joined(separator: ", ")).")
    var mode = Mode.direct

    @Option(name: [.customShort("t"), .customLong("threads")],
            help: "Maximum number of threads used by the simulator.")
    var concurrency = 1

    @Option(name: [.short, .customLong("qubits")],
            help: "Number of qubits to be simulated.")
    var qubitCount = 18

    @Option(name: [.customShort("g"), .customLong("gates")],
            help: ArgumentHelp("Set of gates that compose the circuit: " +
                                "\(Circuit.allCases.map({ "\($0)" }).joined(separator: ", "))."))
    var circuit = Circuit.fullyControlledHadamards

    @Option(name: [.short, .customLong("replicate")],
            help: "How many times 'gates' are replicated to compose a longer circuit.")
    var replicateCircuit = 1

    @Option(name: [.customShort("l"), .customLong("loop")],
            help: "How many times the circuit is simulated to get an average execution time.")
    var repeatExecution = 1

    mutating func validate() throws {
        switch mode {
        case .fullMatrix:
            guard concurrency == 1 else {
                throw ValidationError(
                    "'mode' \(mode) runs in a single thread, please set 'threads' to 1."
                )
            }
        case .rowByRow, .elementByElement, .direct:
            guard concurrency >= 1 else {
                throw ValidationError("Please specify a number of 'threads' of at least 1.")
            }
        }

        let minQubitCount: Int
        switch circuit {
        case .hadamards, .halfHadamardsHalfNots:
            minQubitCount = 1
        case .controlledHadamards, .fullyControlledHadamards, .oracleHadamards:
            minQubitCount = 2
        }
        guard qubitCount >= minQubitCount else {
            throw ValidationError(
                "For \(circuit) 'gates', please specify at least \(minQubitCount) 'qubits'."
            )
        }

        guard replicateCircuit >= 1 else {
            throw ValidationError("Please specify a 'replicate' of at least 1.")
        }

        guard repeatExecution >= 1 else {
            throw ValidationError("Please specify a 'loop' of at least 1.")
        }
    }
}

SQCMeasurePerformance.main()
