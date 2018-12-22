//
//  OracleGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/12/2018.
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

public struct OracleGateFactory {

    // MARK: - Private properties

    private let matrix: Matrix
    private let qubitCount: Int

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Public init methods

    public init(matrix: Matrix) {
        self.matrix = matrix
        qubitCount = Int.log2(matrix.rowCount)
    }
}

// MARK: - CircuitGateFactory methods

extension OracleGateFactory: CircuitGateFactory {
    public func makeGate(inputs: [Int]) -> Gate? {
        guard qubitCount > 0 else {
            os_log("makeGate: unable to produce a U gate with 0 qubits (check matrix)",
                   log: OracleGateFactory.logger,
                   type: .debug)

            return nil
        }

        guard inputs.count >= qubitCount else {
            os_log("makeGate: not enough inputs to produce a U gate",
                   log: OracleGateFactory.logger,
                   type: .debug)

            return nil
        }

        return .oracle(matrix: matrix, inputs: Array(inputs[0..<qubitCount]))
    }
}
