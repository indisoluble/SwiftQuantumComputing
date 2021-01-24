//
//  SimulatorGateMatrix+CountTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/11/2020.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class SimulatorGateMatrix_CountTests: XCTestCase {

    // MARK: - Tests

    func testSingleQubitMatrix_count_returnExpectedValue() {
        // Given
        let matrix = Matrix.makeNot()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.matrix(matrix: matrix).count, 2)
    }

    func testNotMatrixAndControlCountToTwo_count_returnExpectedValue() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 2

        // Then
        XCTAssertEqual(SimulatorGateMatrix.fullyControlledMatrix(controlledMatrix: controlledMatrix,
                                                                 controlCount: controlCount).count,
                       8)
    }

    func testOtherMultiQubitMatrix_count_returnExpectedValue() {
        // Given
        let matrix = OracleSimulatorMatrix(truthTable: ["00"],
                                           controlCount: 2,
                                           controlledMatrix: Matrix.makeNot()).rawMatrix

        // Then
        XCTAssertEqual(SimulatorGateMatrix.matrix(matrix: matrix).count, 8)
    }

    static var allTests = [
        ("testSingleQubitMatrix_rowCount_returnExpectedValue",
         testSingleQubitMatrix_count_returnExpectedValue),
        ("testNotMatrixAndControlCountToTwo_count_returnExpectedValue",
         testNotMatrixAndControlCountToTwo_count_returnExpectedValue),
        ("testOtherMultiQubitMatrix_count_returnExpectedValue",
         testOtherMultiQubitMatrix_count_returnExpectedValue)
    ]
}
