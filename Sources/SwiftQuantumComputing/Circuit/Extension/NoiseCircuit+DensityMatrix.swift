//
//  NoiseCircuit+DensityMatrix.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/08/2021.
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

extension NoiseCircuit {

    // MARK: - Public methods

    public func densityMatrix(withFactory factory: CircuitDensityMatrixFactory = MainCircuitDensityMatrixFactory()) -> Result<CircuitDensityMatrix, DensityMatrixError> {
        let initialState = try! Matrix.makeState(value: 0, qubitCount: gates.qubitCount()).get()
        let initialDensityMatrix = try! factory.makeDensityMatrix(matrix: initialState).get()

        return densityMatrix(withInitialState: initialDensityMatrix)
    }
}
