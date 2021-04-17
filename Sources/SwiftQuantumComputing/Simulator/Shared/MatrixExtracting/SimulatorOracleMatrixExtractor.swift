//
//  SimulatorOracleMatrixExtractor.swift
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

// MARK: - Main body

struct SimulatorOracleMatrixExtractor {

    // MARK: - Internal types

    typealias InternalExtractor = SimulatorOracleMatrixExtracting & RawInputsExtracting

    // MARK: - Private properties

    private let extractor: InternalExtractor

    // MARK: - Internal init methods

    init(extractor: InternalExtractor) {
        self.extractor = extractor
    }
}

// MARK: - RawInputsExtracting methods

extension SimulatorOracleMatrixExtractor: RawInputsExtracting {
    func extractRawInputs() -> [Int] {
        return extractor.extractRawInputs()
    }
}

// MARK: - MatrixExtracting methods

extension SimulatorOracleMatrixExtractor: MatrixExtracting {
    func extractMatrix() -> Result<AnySimulatorOracleMatrix, GateError> {
        switch extractor.extractOracleMatrix() {
        case .success(let matrix):
            return .success(AnySimulatorOracleMatrix(matrix: matrix))
        case .failure(let error):
            return .failure(error)
        }
    }
}
