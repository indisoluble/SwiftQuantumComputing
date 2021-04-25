//
//  AnySimulatorOracleMatrix+MatrixCountableTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 18/04/2021.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class AnySimulatorOracleMatrix_MatrixCountableTests: XCTestCase {

    // MARK: - Tests

    func testNotMatrix_matrixCount_returnExpectedValue() {
        // Given
        let sut = AnySimulatorOracleMatrix(matrix: Matrix.makeNot())

        // Then
        XCTAssertEqual(sut.count, 2)
    }

    func testNotMatrixAndTruthTableWithOneControl_matrixCount_returnExpectedValue() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let count = 1
        let entry = try! TruthTableEntry(repeating: "0", count: count)
        let adapter = SimulatorOracleMatrixAdapter(truthTable: [entry],
                                                   controlCount: count,
                                                   controlledCountableMatrix: controlledMatrix)
        let sut = AnySimulatorOracleMatrix(matrix: adapter)

        // Then
        XCTAssertEqual(sut.count, 4)
    }

    func testNotMatrixAndTruthTableWithTwoControls_matrixCount_returnExpectedValue() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let count = 2
        let entry = try! TruthTableEntry(repeating: "0", count: count)
        let adapter = SimulatorOracleMatrixAdapter(truthTable: [entry],
                                                   controlCount: count,
                                                   controlledCountableMatrix: controlledMatrix)
        let sut = AnySimulatorOracleMatrix(matrix: adapter)

        // Then
        XCTAssertEqual(sut.count, 8)
    }

    static var allTests = [
        ("testNotMatrix_matrixCount_returnExpectedValue",
         testNotMatrix_matrixCount_returnExpectedValue),
        ("testNotMatrixAndTruthTableWithOneControl_matrixCount_returnExpectedValue",
         testNotMatrixAndTruthTableWithOneControl_matrixCount_returnExpectedValue),
        ("testNotMatrixAndTruthTableWithTwoControls_matrixCount_returnExpectedValue",
         testNotMatrixAndTruthTableWithTwoControls_matrixCount_returnExpectedValue)
    ]
}
