//
//  UnitaryGateFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/10/2019.
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

struct UnitaryGateFactoryAdapter {}

// MARK: - UnitaryGateFactory methods

extension UnitaryGateFactoryAdapter: UnitaryGateFactory {
    func makeUnitaryGate(qubitCount: Int, gate: Gate) -> Result<UnitaryGate, GateError> {
        let extractor = SimulatorMatrixExtractor(extractor: gate)

        switch extractor.extractCircuitMatrix(restrictedToCircuitQubitCount: qubitCount) {
        case .success(let circuitMatrix):
            return .success(try! UnitaryGateAdapter(matrix: circuitMatrix.expandedRawMatrix()))
        case .failure(let error):
            return .failure(error)
        }
    }
}
