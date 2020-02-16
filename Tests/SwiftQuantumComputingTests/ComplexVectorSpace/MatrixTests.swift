//
//  MatrixTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 29/07/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class MatrixTests: XCTestCase {

    // MARK: - Tests

    func testEmptyArray_init_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix([]))
    }

    func testEmptyRow_init_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix([[]]))
    }

    func testRowsWithDifferentColumnCount_init_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let elements: [[Complex]] = [[complex], [complex, complex]]

        // Then
        XCTAssertThrowsError(try Matrix(elements))
    }

    func testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let elements: [[Complex]] = [[complex], [complex]]

        // When
        let matrix = try? Matrix(elements)

        // Then
        XCTAssertEqual(matrix?.rowCount, 2)
        XCTAssertEqual(matrix?.columnCount, 1)
    }

    func testNonSquareMatrix_isSquare_returnFalse() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex], [complex]])

        // Then
        XCTAssertFalse(matrix.isSquare)
    }

    func testSquareMatrix_isSquare_returnTrue() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex, complex], [complex, complex]])

        // Then
        XCTAssertTrue(matrix.isSquare)
    }

    func testAnyMatrix_first_returnExpectedValue() {
        // Given
        let expectedValue = Complex(real: 10, imag: 10)
        let elements = [
            [expectedValue, Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertEqual(matrix.first, expectedValue)
    }

    func testAnyMatrix_subscript_returnExpectedValue() {
        // Given
        let expectedValue = Complex(real: 10, imag: 10)
        let elements = [
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)],
            [Complex(real: 0, imag: 0), expectedValue],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0)]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertEqual(matrix[1,1], expectedValue)
    }

    func testAnyMatrix_loop_returnExpectedSequence() {
        // Given
        let elements = [
            [Complex.one, Complex.zero, Complex(2)],
            [Complex.one, Complex.zero, Complex(2)],
            [Complex.one, Complex.zero, Complex(2)]
        ]
        let matrix = try! Matrix(elements)

        // When
        let sequence = matrix.map { $0 }

        // Then
        let expectedSequence = [
            Complex.one, Complex.one, Complex.one,
            Complex.zero, Complex.zero, Complex.zero,
            Complex(2), Complex(2), Complex(2)
        ]
        XCTAssertEqual(sequence, expectedSequence)
    }

    func testNonSquareMatrix_isUnitary_returnFalse() {
        // Given
        let complex = Complex(real: 1, imag: 0)
        let matrix = try! Matrix([[complex], [complex]])

        // Then
        XCTAssertFalse(matrix.isUnitary(accuracy: 0.001))
    }

    func testSquareNonUnitaryMatrix_isUnitary_returnFalse() {
        // Given
        let complex = Complex(real: 1, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])

        // Then
        XCTAssertFalse(matrix.isUnitary(accuracy: 0.001))
    }

    func testUnitaryMatrix_isUnitary_returnTrue() {
        // Given
        let elements = [
            [Complex(real: (1 / 2), imag: (1 / 2)),
             Complex(real: 0, imag: (1 / sqrt(3))),
             Complex(real: (3 / (2 * sqrt(15))), imag: (1 / (2 * sqrt(15))))],
            [Complex(real: -(1 / 2), imag: 0),
             Complex(real: (1 / sqrt(3)), imag: 0),
             Complex(real: (4 / (2 * sqrt(15))), imag: (3 / (2 * sqrt(15))))],
            [Complex(real: (1 / 2), imag: 0),
             Complex(real: 0, imag: -(1 / sqrt(3))),
             Complex(real: 0, imag: (5 / (2 * sqrt(15))))]
        ]
        let matrix = try! Matrix(elements)

        // Then
        XCTAssertTrue(matrix.isUnitary(accuracy: 0.001))
    }

    func testZeroRowCount_makeMatrix_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix.makeMatrix(rowCount: 0,
                                                   columnCount: 1,
                                                   value: { _,_ in Complex.zero }))
    }

    func testZeroColumnCount_makeMatrix_throwException() {
        // Then
        XCTAssertThrowsError(try Matrix.makeMatrix(rowCount: 1,
                                                   columnCount: 0,
                                                   value: { _,_ in Complex.zero }))
    }

    func testOneRowOneColumn_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 1, columnCount: 1) { _,_ in Complex.one }

        // Then
        let expectedMatrix = try? Matrix([[Complex.one]])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix() {
        // When
        let matrix = try? Matrix.makeMatrix(rowCount: 2, columnCount: 3) { (r, c) -> Complex in
            return Complex(real: Double(r), imag: Double(c))
        }

        // Then
        let expectedMatrix = try? Matrix([
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 1), Complex(real: 0, imag: 2)],
            [Complex(real: 1, imag: 0), Complex(real: 1, imag: 1), Complex(real: 1, imag: 2)]
        ])

        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix() {
        // Given
        let complex = Complex(real: 3, imag: 2)
        let row = [Complex(real: 6, imag: 3),
                   Complex(real: 0, imag: 0),
                   Complex(real: 5, imag: 1),
                   Complex(real: 4, imag: 0)]
        let matrix = try! Matrix([row, row])

        // When
        let result = (complex * matrix)

        // Then
        let expectedRow = [Complex(real: 12, imag: 21),
                           Complex(real: 0, imag: 0),
                           Complex(real: 13, imag: 13),
                           Complex(real: 12, imag: 8)]
        let expectedResult = try? Matrix([expectedRow, expectedRow])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let lhs = try! Matrix([[complex, complex]])
        let rhs = try! Matrix([[complex], [complex], [complex]])

        // Then
        XCTAssertThrowsError(try lhs * rhs)
    }

    func testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix() {
        // Given
        let lhsElements = [
            [Complex(real: 3, imag: 2), Complex(real: 0, imag: 0), Complex(real: 5, imag: -6)],
            [Complex(real: 1, imag: 0), Complex(real: 4, imag: 2), Complex(real: 0, imag: 1)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhs = try! Matrix([[Complex(real: 5, imag: 0), Complex(real: 2, imag: -1)],
                               [Complex(real: 0, imag: 0), Complex(real: 4, imag: 5)],
                               [Complex(real: 7, imag: -4), Complex(real: 2, imag: 7)]])

        // When
        let result = (try? lhs * rhs)

        // Then
        let expectedResult = try? Matrix([[Complex(real: 26, imag: -52), Complex(real: 60, imag: 24)],
                                          [Complex(real: 9, imag: 7), Complex(real: 1, imag: 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let lhs = try! Matrix([[complex, complex, complex]])
        let rhs = try! Matrix([[complex], [complex], [complex]])

        // Then
        XCTAssertThrowsError(try Matrix.Transformation.adjointed(lhs) * rhs)
    }

    func testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix() {
        // Given
        let lhsElements = [
            [Complex(real: 3, imag: -2), Complex(real: 1, imag: 0)],
            [Complex(real: 0, imag: 0), Complex(real: 4, imag: -2)],
            [Complex(real: 5, imag: 6), Complex(real: 0, imag: -1)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhs = try! Matrix([[Complex(real: 5, imag: 0), Complex(real: 2, imag: -1)],
                               [Complex(real: 0, imag: 0), Complex(real: 4, imag: 5)],
                               [Complex(real: 7, imag: -4), Complex(real: 2, imag: 7)]])

        // When
        let result = (try? Matrix.Transformation.adjointed(lhs) * rhs)

        // Then
        let expectedResult = try? Matrix([[Complex(real: 26, imag: -52), Complex(real: 60, imag: 24)],
                                          [Complex(real: 9, imag: 7), Complex(real: 1, imag: 29)]])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyArray_init_throwException",
         testEmptyArray_init_throwException),
        ("testEmptyRow_init_throwException",
         testEmptyRow_init_throwException),
        ("testRowsWithDifferentColumnCount_init_throwException",
         testRowsWithDifferentColumnCount_init_throwException),
        ("testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns",
         testRowsWithSameColumnCount_init_returnMatrixWithExpectedNumberOfRowsAndColumns),
        ("testNonSquareMatrix_isSquare_returnFalse",
         testNonSquareMatrix_isSquare_returnFalse),
        ("testSquareMatrix_isSquare_returnTrue",
         testSquareMatrix_isSquare_returnTrue),
        ("testAnyMatrix_first_returnExpectedValue",
         testAnyMatrix_first_returnExpectedValue),
        ("testAnyMatrix_subscript_returnExpectedValue",
         testAnyMatrix_subscript_returnExpectedValue),
        ("testNonSquareMatrix_isUnitary_returnFalse",
         testNonSquareMatrix_isUnitary_returnFalse),
        ("testSquareNonUnitaryMatrix_isUnitary_returnFalse",
         testSquareNonUnitaryMatrix_isUnitary_returnFalse),
        ("testUnitaryMatrix_isUnitary_returnTrue",
         testUnitaryMatrix_isUnitary_returnTrue),
        ("testZeroRowCount_makeMatrix_throwException",
         testZeroRowCount_makeMatrix_throwException),
        ("testZeroColumnCount_makeMatrix_throwException",
         testZeroColumnCount_makeMatrix_throwException),
        ("testOneRowOneColumn_makeMatrix_returnExpectedMatrix",
         testOneRowOneColumn_makeMatrix_returnExpectedMatrix),
        ("testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix",
         testAnyRowsAndColumns_makeMatrix_returnExpectedMatrix),
        ("testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix",
         testOneComplexNumberAndOneMatrix_multiply_returnExpectedMatrix),
        ("testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException",
         testMatrixWithColumnCountDifferentThanRowCountInSecondMatrix_multiply_throwException),
        ("testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix",
         testMatrixWithColumnCountEqualToRowCountInSecondMatrix_multiply_returnExpectedMatrix),
        ("testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException",
         testMatrixWithRowCountDifferentThanRowCountInSecondMatrix_adjointedMultiply_throwException),
        ("testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix",
         testMatrixWithRowCountEqualToRowCountInSecondMatrix_adjointedMultiply_returnExpectedMatrix)
    ]
}
