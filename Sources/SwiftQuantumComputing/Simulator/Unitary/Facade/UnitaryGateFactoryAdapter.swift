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

    private let maxConcurrency: Int
    private let transformation: UnitaryTransformation

    // MARK: - Internal init methods

    enum InitError: Error {
        case maxConcurrencyHasToBiggerThanZero
    }

    init(maxConcurrency: Int, transformation: UnitaryTransformation) throws {
        guard maxConcurrency > 0 else {
            throw InitError.maxConcurrencyHasToBiggerThanZero
        }

        self.maxConcurrency = maxConcurrency
        self.transformation = transformation
    }
}

// MARK: - UnitaryGateFactory methods

extension UnitaryGateFactoryAdapter: UnitaryGateFactory {
    func makeUnitaryGate(qubitCount: Int, gate: Gate) -> Result<UnitaryGate, QuantumOperatorError> {
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        switch extractor.extractCircuitMatrix(restrictedToCircuitQubitCount: qubitCount) {
        case .success(let circuitMatrix):
            let matrix = try! circuitMatrix.expandedRawMatrix(maxConcurrency: maxConcurrency).get()

            return .success(try! UnitaryGateAdapter(matrix: matrix, transformation: transformation))
        case .failure(let error):
            return .failure(error)
        }
    }
}
