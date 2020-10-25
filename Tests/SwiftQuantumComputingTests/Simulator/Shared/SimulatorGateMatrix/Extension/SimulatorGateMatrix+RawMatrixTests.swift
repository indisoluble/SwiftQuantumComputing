//
//  SimulatorGateMatrix+RawMatrixTests.swift
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

class SimulatorGateMatrix_RawMatrixTests: XCTestCase {

    // MARK: - Tests

    func testSingleQubitMatrix_rowCount_returnExpectedValue() {
        // Given
        let matrix = Matrix.makeNot()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.singleQubitMatrix(matrix: matrix).rowCount, 2)
    }

    func testFullyControlledSingleQubitMatrix_rowCount_returnExpectedValue() {
        // Given
        let matrix = Matrix.makeControlledNot()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.fullyControlledSingleQubitMatrix(matrix: matrix).rowCount,
                       4)
    }

    func testOtherMultiQubitMatrix_rowCount_returnExpectedValue() {
        // Given
        let matrix = try! Matrix.makeOracle(truthTable: ["00"],
                                            controlCount: 2,
                                            controlledMatrix: .makeNot()).get()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.otherMultiQubitMatrix(matrix: matrix).rowCount, 8)
    }

    func testSingleQubitMatrix_rawMatrix_returnExpectedMatrix() {
        // Given
        let matrix = Matrix.makeNot()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.singleQubitMatrix(matrix: matrix).rawMatrix, matrix)
    }

    func testFullyControlledSingleQubitMatrix_rawMatrix_returnExpectedMatrix() {
        // Given
        let matrix = Matrix.makeControlledNot()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.fullyControlledSingleQubitMatrix(matrix: matrix).rawMatrix,
                       matrix)
    }

    func testOtherMultiQubitMatrix_rawMatrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix.makeOracle(truthTable: ["00"],
                                            controlCount: 2,
                                            controlledMatrix: .makeNot()).get()

        // Then
        XCTAssertEqual(SimulatorGateMatrix.otherMultiQubitMatrix(matrix: matrix).rawMatrix, matrix)
    }

    static var allTests = [
        ("testSingleQubitMatrix_rowCount_returnExpectedValue",
         testSingleQubitMatrix_rowCount_returnExpectedValue),
        ("testFullyControlledSingleQubitMatrix_rowCount_returnExpectedValue",
         testFullyControlledSingleQubitMatrix_rowCount_returnExpectedValue),
        ("testOtherMultiQubitMatrix_rowCount_returnExpectedValue",
         testOtherMultiQubitMatrix_rowCount_returnExpectedValue),
        ("testSingleQubitMatrix_rawMatrix_returnExpectedMatrix",
         testSingleQubitMatrix_rawMatrix_returnExpectedMatrix),
        ("testFullyControlledSingleQubitMatrix_rawMatrix_returnExpectedMatrix",
         testFullyControlledSingleQubitMatrix_rawMatrix_returnExpectedMatrix),
        ("testOtherMultiQubitMatrix_rawMatrix_returnExpectedMatrix",
         testOtherMultiQubitMatrix_rawMatrix_returnExpectedMatrix)
    ]
}
