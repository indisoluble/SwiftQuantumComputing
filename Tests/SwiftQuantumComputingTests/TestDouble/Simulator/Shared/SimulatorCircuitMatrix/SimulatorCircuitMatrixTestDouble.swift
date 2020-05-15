//
//  SimulatorCircuitMatrixTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/05/2020.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class SimulatorCircuitMatrixTestDouble {

    // MARK: - Internal properties

    private (set) var rawMatrixCount = 0
    var rawMatrixResult = Matrix.makeNot()

    private (set) var subscriptRowCount = 0
    private (set) var lastSubscriptRowRow: Int?
    var subscriptRowResult = try! Vector([Complex.zero])

    private (set) var subscriptRowColumnCount = 0
    private (set) var lastSubscriptRowColumnRow: Int?
    private (set) var lastSubscriptRowColumnColumn: Int?
    var subscriptRowColumnResult = Complex.zero
}

// MARK: - SimulatorCircuitMatrix methods

extension SimulatorCircuitMatrixTestDouble: SimulatorCircuitMatrix {
    var rawMatrix: Matrix {
        rawMatrixCount += 1

        return rawMatrixResult
    }
}

// MARK: - SimulatorCircuitMatrixRow methods

extension SimulatorCircuitMatrixTestDouble: SimulatorCircuitMatrixRow {
    subscript(row: Int) -> Vector {
        subscriptRowCount += 1

        lastSubscriptRowRow = row

        return subscriptRowResult
    }
}

// MARK: - SimulatorCircuitMatrixElement methods

extension SimulatorCircuitMatrixTestDouble: SimulatorCircuitMatrixElement {
    subscript(row: Int, column: Int) -> Complex {
        subscriptRowColumnCount += 1

        lastSubscriptRowColumnRow = row
        lastSubscriptRowColumnColumn = column

        return subscriptRowColumnResult
    }
}
