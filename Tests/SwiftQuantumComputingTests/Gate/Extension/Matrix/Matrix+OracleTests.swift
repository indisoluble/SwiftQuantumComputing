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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Matrix_OracleTests: XCTestCase {

    // MARK: - Tests

    func testNegativeControlCountAndEmptyTruthTable_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [], controlCount: -1) {
            error = e
        }
        XCTAssertEqual(error, .controlsCanNotBeAnEmptyList)
    }

    func testControlCountEqualToZeroAndEmptyTruthTable_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [], controlCount: 0) {
            error = e
        }
        XCTAssertEqual(error, .controlsCanNotBeAnEmptyList)
    }

    func testControlCountBiggerThanZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: [], controlCount: controlCount).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: [""], controlCount: controlCount).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndNonSensicalTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let truthTable = [" 01", "01a", "a01", "0a1", "0 1"]
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: truthTable,
                                              controlCount: controlCount).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableOutOfRange_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let truthTable = [String(repeating: "1", count: controlCount + 1)]

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: truthTable,
                                              controlCount: controlCount).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["0000000001"]
        let controlCount = 1

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount).get()

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testControlCountBiggerThanZeroAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["1", "1"]
        let controlCount = 1

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount).get()

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testValidControlCountAndTruthTable_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount).get()

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    static var allTests = [
        ("testNegativeControlCountAndEmptyTruthTable_makeOracle_throwException",
         testNegativeControlCountAndEmptyTruthTable_makeOracle_throwException),
        ("testControlCountEqualToZeroAndEmptyTruthTable_makeOracle_throwException",
         testControlCountEqualToZeroAndEmptyTruthTable_makeOracle_throwException),
        ("testControlCountBiggerThanZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_makeOracle_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_makeOracle_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndNonSensicalTruthTable_makeOracle_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndNonSensicalTruthTable_makeOracle_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndTruthTableOutOfRange_makeOracle_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndTruthTableOutOfRange_makeOracle_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix",
         testControlCountBiggerThanZeroAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix),
        ("testControlCountBiggerThanZeroAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix",
         testControlCountBiggerThanZeroAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix),
        ("testValidControlCountAndTruthTable_makeOracle_returnExpectedMatrix",
         testValidControlCountAndTruthTable_makeOracle_returnExpectedMatrix)
    ]
}
