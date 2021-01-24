//
//  SimulatorGateMatrix+MatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/10/2020.
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

class SimulatorGateMatrix_MatrixTests: XCTestCase {

    // MARK: - Tests

    func testSingleQubitMatrix_matrix_returnExpectedMatrix() {
        // Given
        let matrix = Matrix.makeNot()

        // When
        let result = SimulatorGateMatrix.matrix(matrix: matrix).matrix

        // Then
        XCTAssertEqual(result.rawMatrix, matrix)
    }

    func testNotMatrixAndControlCountToOne_matrix_returnExpectedMatrix() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 1

        // When
        let result = SimulatorGateMatrix.fullyControlledMatrix(controlledMatrix: controlledMatrix,
                                                               controlCount: controlCount).matrix

        // Then
        let expectedMatrix = Matrix.makeControlledNot()
        XCTAssertEqual(result.rawMatrix, expectedMatrix)
    }

    func testOtherMultiQubitMatrix_matrix_returnExpectedMatrix() {
        // Given
        let matrix = OracleSimulatorMatrix(truthTable: ["00"],
                                           controlCount: 2,
                                           controlledMatrix: Matrix.makeNot()).rawMatrix

        // When
        let result = SimulatorGateMatrix.matrix(matrix: matrix).matrix

        // Then
        XCTAssertEqual(result.rawMatrix, matrix)
    }

    static var allTests = [
        ("testSingleQubitMatrix_matrix_returnExpectedMatrix",
         testSingleQubitMatrix_matrix_returnExpectedMatrix),
        ("testNotMatrixAndControlCountToOne_matrix_returnExpectedMatrix",
         testNotMatrixAndControlCountToOne_matrix_returnExpectedMatrix),
        ("testOtherMultiQubitMatrix_matrix_returnExpectedMatrix",
         testOtherMultiQubitMatrix_matrix_returnExpectedMatrix)
    ]
}
