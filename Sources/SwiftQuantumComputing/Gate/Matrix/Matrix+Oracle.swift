//
//  Matrix+Oracle.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/01/2019.
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

extension Matrix {

    // MARK: - Internal class methods

    static func makeOracle(truthTable: [String], controlCount: Int) throws -> Matrix {
        guard controlCount > 0 else {
            throw GateError.gateOracleControlsCanNotBeAnEmptyList
        }

        let truthTableAsInts = Matrix.truthTableAsInts(truthTable)
        let columnCount = Int.pow(2, controlCount + 1)

        var rows: [[Complex]] = []

        for controlValue in 0..<Int.pow(2, controlCount) {
            let isControlValueTrue = truthTableAsInts.contains(controlValue)

            var row = Array(repeating: Complex(0), count: columnCount)
            row[2 * controlValue + (isControlValueTrue ? 1 : 0)] = Complex(1)
            rows.append(row)

            row = Array(repeating: Complex(0), count: columnCount)
            row[2 * controlValue + (isControlValueTrue ? 0 : 1)] = Complex(1)
            rows.append(row)
        }

        return try! Matrix(rows)
    }
}

// MARK: - Private body

private extension Matrix {

    // MARK: - Private class methods

    static func truthTableAsInts(_ truthTable: [String]) -> [Int] {
        var result: [Int] = []

        for truth in truthTable {
            guard let truthAsInt = Int(truth, radix: 2) else {
                continue
            }

            result.append(truthAsInt)
        }

        return result
    }
}
