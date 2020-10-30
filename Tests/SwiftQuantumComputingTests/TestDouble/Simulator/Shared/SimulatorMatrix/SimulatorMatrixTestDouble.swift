//
//  SimulatorMatrixTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 30/10/2020.
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

import ComplexModule
import Foundation

@testable import SwiftQuantumComputing

// MARK: - Main body

final class SimulatorMatrixTestDouble {

    // MARK: - Internal properties

    private (set) var countCount = 0
    var countResult = 0

    private (set) var subscriptRowColumnCount = 0
    private (set) var lastSubscriptRowColumnRow: Int?
    private (set) var lastSubscriptRowColumnColumn: Int?
    var subscriptRowColumnResult = Complex<Double>.zero
}

// MARK: - SimulatorMatrix methods

extension SimulatorMatrixTestDouble: SimulatorMatrix {
    var count: Int {
        countCount += 1

        return countResult
    }

    subscript(row: Int, column: Int) -> Complex<Double> {
        subscriptRowColumnCount += 1

        lastSubscriptRowColumnRow = row
        lastSubscriptRowColumnColumn = column

        return subscriptRowColumnResult
    }
}
