//
//  OracleSimulatorMatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/10/2020.
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
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class OracleSimulatorMatrixTests: XCTestCase {

    // MARK: - Properties

    let nonSquareMatrix = try! Matrix([[.zero, .one]])
    let nonPowerOfTwoSizeMatrix = try! Matrix([
        [.zero, .zero, .zero],
        [.zero, .zero, .zero],
        [.zero, .zero, .zero]
    ])
    let notMatrix = Matrix.makeNot()
    let twoByTwoMatrix = try! Matrix([
        [Complex(2), Complex(3)],
        [Complex(4), Complex(5)]
    ])

    // MARK: - Tests

    func testControlCountBiggerThanZeroAndEmptyTruthTable_expandedRawMatrix_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let matrix = OracleSimulatorMatrix(truthTable: [],
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        XCTAssertEqual(matrix.expandedRawMatrix(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_expandedRawMatrix_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let matrix = OracleSimulatorMatrix(truthTable: [""],
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        XCTAssertEqual(matrix.expandedRawMatrix(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndNonSensicalTruthTable_expandedRawMatrix_returnExpectedIdentity() {
        // Given
        let truthTable = [" 01", "01a", "a01", "0a1", "0 1"]
        let controlCount = 5
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        XCTAssertEqual(matrix.expandedRawMatrix(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroAndTruthTableOutOfRange_expandedRawMatrix_returnExpectedIdentity() {
        // Given
        let controlCount = 5
        let truthTable = [String(repeating: "1", count: controlCount + 1)]
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        XCTAssertEqual(matrix.expandedRawMatrix(),
                       try! Matrix.makeIdentity(count: Int.pow(2, controlCount + 1)).get())
    }

    func testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let truthTable = ["0000000001"]
        let controlCount = 1
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedMatrix)
    }

    func testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let truthTable = ["1", "1"]
        let controlCount = 1
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

        // Then
        let rows: [[Complex<Double>]] = [
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero]
        ]
        let expectedMatrix = try! Matrix(rows)
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedMatrix)
    }

    func testValidControlCountNotMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: notMatrix)

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
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedMatrix)
    }

    func testValidControlCountAnyValidMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let truthTable = ["01", "11"]
        let controlCount = 2
        let controlledMatrix = try! Matrix([
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero],
            [.one, .zero, .zero, .zero]
        ])
        let matrix = OracleSimulatorMatrix(truthTable: truthTable,
                                           controlCount: controlCount,
                                           controlledMatrix: controlledMatrix)

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
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedMatrix)
    }

    func testTwoByTwoMatrixControlCountEqualToOneAndControlActivated_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let matrix = OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                           controlledMatrix: twoByTwoMatrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, Complex(2), Complex(3)],
            [.zero, .zero, Complex(4), Complex(5)]
        ])
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedResult)
    }

    func testTwoByTwoMatrixControlCountEqualToTwoAndAllControlsActivated_expandedRawMatrix_returnExpectedMatrix() {
        // Given
        let matrix = OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 2,
                                           controlledMatrix: twoByTwoMatrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, Complex(2), Complex(3)],
            [.zero, .zero, .zero, .zero, .zero, .zero, Complex(4), Complex(5)]
        ])
        XCTAssertEqual(matrix.expandedRawMatrix(), expectedResult)
    }

    static var allTests = [
        ("testControlCountBiggerThanZeroAndEmptyTruthTable_expandedRawMatrix_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndEmptyTruthTable_expandedRawMatrix_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_expandedRawMatrix_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndTruthTableWithEmptyValue_expandedRawMatrix_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndNonSensicalTruthTable_expandedRawMatrix_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndNonSensicalTruthTable_expandedRawMatrix_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroAndTruthTableOutOfRange_expandedRawMatrix_returnExpectedIdentity",
         testControlCountBiggerThanZeroAndTruthTableOutOfRange_expandedRawMatrix_returnExpectedIdentity),
        ("testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_expandedRawMatrix_returnExpectedMatrix",
         testControlCountBiggerThanZeroNotMatrixAndTruthTableWithMoreBitsThanControlsButInRange_expandedRawMatrix_returnExpectedMatrix),
        ("testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_expandedRawMatrix_returnExpectedMatrix",
         testControlCountBiggerThanZeroNotMatrixAndTruthTableWithWithRepeatedCorrectValues_expandedRawMatrix_returnExpectedMatrix),
        ("testValidControlCountNotMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix",
         testValidControlCountNotMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix),
        ("testValidControlCountAnyValidMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix",
         testValidControlCountAnyValidMatrixAndTruthTable_expandedRawMatrix_returnExpectedMatrix),
        ("testTwoByTwoMatrixControlCountEqualToOneAndControlActivated_expandedRawMatrix_returnExpectedMatrix",
         testTwoByTwoMatrixControlCountEqualToOneAndControlActivated_expandedRawMatrix_returnExpectedMatrix),
        ("testTwoByTwoMatrixControlCountEqualToTwoAndAllControlsActivated_expandedRawMatrix_returnExpectedMatrix",
         testTwoByTwoMatrixControlCountEqualToTwoAndAllControlsActivated_expandedRawMatrix_returnExpectedMatrix)
    ]
}
