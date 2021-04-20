//
//  FixedControlledGate+SimulatorOracleMatrixAdapterExtracting.swift
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

// MARK: - SimulatorOracleMatrixExtracting methods

extension FixedControlledGate: SimulatorOracleMatrixAdapterExtracting {
    func extractOracleMatrixAdapter() -> Result<SimulatorOracleMatrixAdapter, GateError> {
        guard !controls.isEmpty else {
            return .failure(.gateControlsCanNotBeAnEmptyList)
        }

        switch gate.extractOracleMatrix() {
        case .failure(let error):
            return .failure(error)
        case .success(let matrix):
            let entry = try! TruthTableEntry(repeating: "1", count: controls.count)
            let truthTable = (matrix.truthTable.isEmpty ?
                                [entry] :
                                matrix.truthTable.map { entry + $0 } )

            return .success(SimulatorOracleMatrixAdapter(truthTable: truthTable,
                                                         controlledCountableMatrix: matrix.controlledCountableMatrix))
        }
    }
}
