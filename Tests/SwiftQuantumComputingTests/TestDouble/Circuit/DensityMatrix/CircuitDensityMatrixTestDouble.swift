//
//  CircuitDensityMatrixTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 28/07/2021.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class CircuitDensityMatrixTestDouble {

    // MARK: - Internal properties

    private (set) var densityMatrixCount = 0
    var densityMatrixResult = Matrix.makeNot()
}

// MARK: - CircuitDensityMatrix methods

extension CircuitDensityMatrixTestDouble: CircuitDensityMatrix {
    var densityMatrix: Matrix {
        densityMatrixCount += 1

        return densityMatrixResult
    }
}

// MARK: - CircuitProbabilities methods

extension CircuitDensityMatrixTestDouble: CircuitProbabilities {}
