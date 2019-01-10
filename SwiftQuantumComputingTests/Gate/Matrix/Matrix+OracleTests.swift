//
//  Matrix+OracleTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/01/2019.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Matrix_OracleTests: XCTestCase {

    // MARK: - Tests

    func testNegativeControlCountAndEmptyTruthTable_makeOracle_returNil() {
        // Then
        XCTAssertNil(Matrix.makeOracle(truthTable: [], controlCount: -1))
    }

    func testControlCountEqualToZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 0

        // Then
        XCTAssertEqual(Matrix.makeOracle(truthTable: [], controlCount: controlCount),
                       Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)))
    }

    func testControlCountBiggerThanZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5

        // Then
        XCTAssertEqual(Matrix.makeOracle(truthTable: [], controlCount: controlCount),
                       Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)))
    }

    func testControlCountBiggerThanZeroAndNonSensicalTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let truthTable = [" 01", "01a", "a01", "0a1", "0 1"]
        let controlCount = 5

        // Then
        XCTAssertEqual(Matrix.makeOracle(truthTable: truthTable, controlCount: controlCount),
                       Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)))
    }

    func testControlCountBiggerThanZeroAndTruthTableOutOfRange_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let truthTable = [String(repeating: "1", count: controlCount + 1)]

        // Then
        XCTAssertEqual(Matrix.makeOracle(truthTable: truthTable, controlCount: controlCount),
                       Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)))
    }

    func testControlCountBiggerThanZeroAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["0000000001"]
        let controlCount = 1

        // When
        let matrix = Matrix.makeOracle(truthTable: truthTable, controlCount: controlCount)

        // Then
        let rows = [
            [Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(1), Complex(0)]
        ]
        let expectedMatrix = Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testControlCountBiggerThanZeroAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["1", "1"]
        let controlCount = 1

        // When
        let matrix = Matrix.makeOracle(truthTable: truthTable, controlCount: controlCount)

        // Then
        let rows = [
            [Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(1), Complex(0)]
        ]
        let expectedMatrix = Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testValidControlCountAndTruthTable_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2

        // When
        let matrix = Matrix.makeOracle(truthTable: truthTable, controlCount: controlCount)

        // Then
        let rows = [
            [Complex(1), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1),
             Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(1), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(1), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(1), Complex(0)]
        ]
        let expectedMatrix = Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }
}
