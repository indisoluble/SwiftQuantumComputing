//
//  UnitaryGateAdapter.swift
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

struct UnitaryGateAdapter {

    // MARK: - Private properties

    private let matrix: Matrix

    private let qubitCount: Int

    // MARK: - Internal init methods

    enum InitError: Error {
        case matrixIsNotSquare
        case matrixRowCountHasToBeAPowerOfTwo
    }

    init(matrix: Matrix) throws {
        guard matrix.isSquare else {
            throw InitError.matrixIsNotSquare
        }

        guard matrix.rowCount.isPowerOfTwo else {
            throw InitError.matrixRowCountHasToBeAPowerOfTwo
        }

        qubitCount = Int.log2(matrix.rowCount)

        self.matrix = matrix
    }
}

// MARK: - UnitaryGate methods

extension UnitaryGateAdapter: UnitaryGate {
    func unitary() -> Result<Matrix, UnitaryMatrixError> {
        guard matrix.isApproximatelyUnitary(absoluteTolerance: SharedConstants.tolerance) else {
            return .failure(.matrixIsNotUnitary)
        }

        return .success(matrix)
    }

    func applying(_ gate: Gate) -> Result<UnitaryGate, GateError> {
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        switch extractor.extractCircuitMatrix(restrictedToCircuitQubitCount: qubitCount) {
        case .success(let circuitMatrix):
            let nextMatrix = try! (circuitMatrix.expandedRawMatrix() * matrix).get()

            return .success(try! UnitaryGateAdapter(matrix: nextMatrix))
        case .failure(let error):
            return .failure(error)
        }
    }
}
