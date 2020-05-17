//
//  SimulatorCircuitMatrixFactoryAdapter.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/02/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

struct SimulatorCircuitMatrixFactoryAdapter {}

// MARK: - SimulatorCircuitMatrixFactory methods

extension SimulatorCircuitMatrixFactoryAdapter: SimulatorCircuitMatrixFactory {
    func makeCircuitMatrix(qubitCount: Int,
                           baseMatrix: Matrix,
                           inputs: [Int]) -> SimulatorCircuitMatrix {
        return SimulatorCircuitMatrixAdapter(qubitCount: qubitCount,
                                             baseMatrix: baseMatrix,
                                             inputs: inputs)
    }
}

// MARK: - SimulatorCircuitMatrixRowFactory methods

extension SimulatorCircuitMatrixFactoryAdapter: SimulatorCircuitMatrixRowFactory {
    func makeCircuitMatrixRow(qubitCount: Int,
                              baseMatrix: Matrix,
                              inputs: [Int]) -> SimulatorCircuitMatrixRow {
        return SimulatorCircuitMatrixAdapter(qubitCount: qubitCount,
                                             baseMatrix: baseMatrix,
                                             inputs: inputs)
    }
}

// MARK: - SimulatorCircuitMatrixElementFactory methods

extension SimulatorCircuitMatrixFactoryAdapter: SimulatorCircuitMatrixElementFactory {
    func makeCircuitMatrixElement(qubitCount: Int,
                                  baseMatrix: Matrix,
                                  inputs: [Int]) -> SimulatorCircuitMatrixElement {
        return SimulatorCircuitMatrixAdapter(qubitCount: qubitCount,
                                             baseMatrix: baseMatrix,
                                             inputs: inputs)
    }
}
