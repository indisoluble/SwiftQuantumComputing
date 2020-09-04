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

    // MARK: - Properties

    let nonSquareMatrix = try! Matrix([[.zero, .one]])
    let nonPowerOfTwoSizeMatrix = try! Matrix([
        [.zero, .zero, .zero],
        [.zero, .zero, .zero],
        [.zero, .zero, .zero]
    ])
    let notMatrix = Matrix.makeNot()

    // MARK: - Tests

    func testNonSquareMatrix_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [],
                                                    controlCount: 1,
                                                    controlledMatrix: nonSquareMatrix) {
            error = e
        }
        XCTAssertEqual(error, .matrixIsNotSquare)
    }

    func testNonPowerOfTwoSizeMatrix_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [],
                                                    controlCount: 1,
                                                    controlledMatrix: nonPowerOfTwoSizeMatrix) {
            error = e
        }
        XCTAssertEqual(error, .matrixRowCountHasToBeAPowerOfTwo)
    }

    func testNegativeControlCountAndEmptyTruthTable_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [],
                                                    controlCount: -1,
                                                    controlledMatrix: notMatrix) {
            error = e
        }
        XCTAssertEqual(error, .controlCountHasToBeBiggerThanZero)
    }

    func testControlCountEqualToZeroAndEmptyTruthTable_makeOracle_throwException() {
        // Then
        var error: Matrix.MakeOracleError?
        if case .failure(let e) = Matrix.makeOracle(truthTable: [],
                                                    controlCount: 0,
                                                    controlledMatrix: notMatrix) {
            error = e
        }
        XCTAssertEqual(error, .controlCountHasToBeBiggerThanZero)
    }

    func testControlCountBiggerThanZeroAndEmptyTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: [],
                                              controlCount: controlCount,
                                              controlledMatrix: notMatrix).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: [""],
                                              controlCount: controlCount,
                                              controlledMatrix: notMatrix).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndNonSensicalTruthTable_makeOracle_returnExpectedIdentity() {
        // Given
        let truthTable = [" 01", "01a", "a01", "0a1", "0 1"]
        let controlCount = 5

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: truthTable,
                                              controlCount: controlCount,
                                              controlledMatrix: notMatrix).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableOutOfRange_makeOracle_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let truthTable = [String(repeating: "1", count: controlCount + 1)]

        // Then
        XCTAssertEqual(try? Matrix.makeOracle(truthTable: truthTable,
                                              controlCount: controlCount,
                                              controlledMatrix: notMatrix).get(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["0000000001"]
        let controlCount = 1

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount,
                                            controlledMatrix: notMatrix).get()

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

    func testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["1", "1"]
        let controlCount = 1

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount,
                                            controlledMatrix: notMatrix).get()

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

    func testValidControlCountNotMatrixAndTruthTable_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount,
                                            controlledMatrix: notMatrix).get()

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

    func testValidControlCountAnyValidMatrixAndTruthTable_makeOracle_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2
        let controlledMatrix = try! Matrix([
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero],
            [.one, .zero, .zero, .zero]
        ])

        // When
        let matrix = try? Matrix.makeOracle(truthTable: truthTable,
                                            controlCount: controlCount,
                                            controlledMatrix: controlledMatrix).get()

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
             .zero, .zero, .zero, .zero, .one, .zero, .zero, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix, expectedMatrix)
    }

    static var allTests = [
        ("testNonSquareMatrix_makeOracle_throwException",
         testNonSquareMatrix_makeOracle_throwException),
        ("testNonPowerOfTwoSizeMatrix_makeOracle_throwException",
         testNonPowerOfTwoSizeMatrix_makeOracle_throwException),
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
        ("testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix",
         testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_makeOracle_returnExpectedMatrix),
        ("testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix",
         testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_makeOracle_returnExpectedMatrix),
        ("testValidControlCountNotMatrixAndTruthTable_makeOracle_returnExpectedMatrix",
         testValidControlCountNotMatrixAndTruthTable_makeOracle_returnExpectedMatrix),
        ("testValidControlCountAnyValidMatrixAndTruthTable_makeOracle_returnExpectedMatrix",
         testValidControlCountAnyValidMatrixAndTruthTable_makeOracle_returnExpectedMatrix)
    ]
}
