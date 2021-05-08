//
//  SimulatorOracleMatrixAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/04/2021.
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

// MARK: - Main body

struct SimulatorOracleMatrixAdapter {

    // MARK: - SimulatorOracleMatrix properties

    let truthTable: [TruthTableEntry]
    let controlCount: Int
    let controlledCountableMatrix: SimulatorMatrixExtracting.SimulatorMatrixCountable

    // MARK: - Internal methods

    func expandedOracleMatrix() -> OracleSimulatorMatrix {
        return OracleSimulatorMatrix(truthTable: truthTable,
                                     controlCount: controlCount,
                                     controlledCountableMatrix: controlledCountableMatrix)
    }

    // MARK: - Internal class methods

    static func makeAdapter(controls: [Int],
                            truthTable: [String],
                            extractor: SimulatorOracleMatrixExtracting) -> Result<SimulatorOracleMatrixAdapter, GateError> {
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

        let extractedMatrix: SimulatorOracleMatrix
        switch extractor.extractOracleMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(let matrix):
            extractedMatrix = matrix
        }

        let extractedCount = extractedMatrix.controlCount
        let finalCount = truthCount + extractedCount

        let extractedTruth = extractedMatrix.truthTable
        let finalEntries: [TruthTableEntry]
        if extractedCount == 0 {
            finalEntries = entries
        } else if extractedTruth.isEmpty {
            finalEntries = []
        } else {
            finalEntries = entries.lazy.flatMap { e in extractedTruth.lazy.map { e + $0 } }
        }

        return .success(SimulatorOracleMatrixAdapter(truthTable: finalEntries,
                                                     controlCount: finalCount,
                                                     controlledCountableMatrix: extractedMatrix.controlledCountableMatrix))
    }
}

// MARK: - SimulatorOracleMatrix methods

extension SimulatorOracleMatrixAdapter: SimulatorOracleMatrix {}
