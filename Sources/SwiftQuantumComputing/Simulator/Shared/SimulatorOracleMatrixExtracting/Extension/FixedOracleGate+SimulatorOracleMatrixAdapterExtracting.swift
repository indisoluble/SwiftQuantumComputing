//
//  FixedOracleGate+SimulatorOracleMatrixAdapterExtracting.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/04/2021.
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

import Foundation

// MARK: - SimulatorOracleMatrixAdapterExtracting methods

extension FixedOracleGate: SimulatorOracleMatrixAdapterExtracting {
    func extractOracleMatrixAdapter() -> Result<SimulatorOracleMatrixAdapter, GateError> {
        guard !controls.isEmpty else {
            return .failure(.gateControlsCanNotBeAnEmptyList)
        }

        let truthCount = controls.count

        let entries: [TruthTableEntry]
        do {
            entries = try truthTable.map { try TruthTableEntry(truth: $0, truthCount: truthCount) }
        } catch TruthTableEntry.InitError.truthCanNotBeRepresentedWithGivenTruthCount {
            return .failure(.gateTruthTableCanNotBeRepresentedWithGivenControlCount)
        } catch TruthTableEntry.InitError.truthHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes {
            return .failure(.gateTruthTableEntriesHaveToBeNonEmptyStringsComposedOnlyOfZerosAndOnes)
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        switch gate.extractOracleMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(let matrix):
            let finalCount = truthCount + matrix.controlCount

            let finalEntries: [TruthTableEntry]
            if matrix.controlCount == 0 {
                finalEntries = entries
            } else if matrix.truthTable.isEmpty {
                finalEntries = []
            } else {
                finalEntries = entries.lazy.flatMap { e in matrix.truthTable.lazy.map { e + $0 } }
            }

            return .success(SimulatorOracleMatrixAdapter(truthTable: finalEntries,
                                                         controlCount: finalCount,
                                                         controlledCountableMatrix: matrix.controlledCountableMatrix))
        }
    }
}
