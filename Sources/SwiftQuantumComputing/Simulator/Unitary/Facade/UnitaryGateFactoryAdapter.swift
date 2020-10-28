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

struct UnitaryGateFactoryAdapter {

    // MARK: - Private properties

    private let matrixFactory: SimulatorCircuitMatrixFactory

    // MARK: - Internal init methods

    init(matrixFactory: SimulatorCircuitMatrixFactory) {
        self.matrixFactory = matrixFactory
    }
}

// MARK: - UnitaryGateFactory methods

extension UnitaryGateFactoryAdapter: UnitaryGateFactory {
    func makeGate(qubitCount: Int, simulatorGate: SimulatorGate) -> Result<UnitaryGate, GateError> {
        switch simulatorGate.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
        case .success((let simulatorGateMatrix, let inputs)):
            let circuitMatrix = matrixFactory.makeCircuitMatrix(qubitCount: qubitCount,
                                                                baseMatrix: simulatorGateMatrix.rawMatrix,
                                                                inputs: inputs)
            let adapter = try! UnitaryGateAdapter(matrix: circuitMatrix.rawMatrix,
                                                  matrixFactory: matrixFactory)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
}
