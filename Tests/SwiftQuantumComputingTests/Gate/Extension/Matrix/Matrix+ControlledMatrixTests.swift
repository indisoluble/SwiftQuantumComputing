//
//  Matrix+ControlledMatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/03/2020.
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

class Matrix_ControlledMatrixTests: XCTestCase {

    // MARK: - Properties
    let nonSquareMatrix = try! Matrix([[.zero, .one]])
    let nonPowerOfTwoSizeMatrix = try! Matrix([
        [.zero, .zero, .zero],
        [.zero, .zero, .zero],
        [.zero, .zero, .zero]
    ])
    let twoByTwoMatrix = try! Matrix([
        [Complex(2), Complex(3)],
        [Complex(4), Complex(5)]
    ])


    // MARK: - Tests

    func testNonSquareMatrix_makeControlledMatrix_throwException() {
        // Then
        var error: Matrix.MakeControlledMatrixError?
        if case .failure(let e) = Matrix.makeControlledMatrix(matrix: nonSquareMatrix,
                                                              controlCount: 1) {
            error = e
        }
        XCTAssertEqual(error, .matrixIsNotSquare)
    }

    func testNonPowerOfTwoSizeMatrix_makeControlledMatrix_throwException() {
        // Then
        var error: Matrix.MakeControlledMatrixError?
        if case .failure(let e) = Matrix.makeControlledMatrix(matrix: nonPowerOfTwoSizeMatrix,
                                                              controlCount: 1) {
            error = e
        }
        XCTAssertEqual(error, .matrixRowCountHasToBeAPowerOfTwo)
    }

    func testControlCountEqualToZero_makeControlledMatrix_throwException() {
        // Then
        var error: Matrix.MakeControlledMatrixError?
        if case .failure(let e) = Matrix.makeControlledMatrix(matrix: twoByTwoMatrix,
                                                              controlCount: 0) {
            error = e
        }
        XCTAssertEqual(error, .controlCountHasToBeBiggerThanZero)
    }

    func testTwoByTwoMatrixAndControlCountEqualToOne_makeControlledMatrix_returnExpectedMatrix() {
        // When
        let result = try? Matrix.makeControlledMatrix(matrix: twoByTwoMatrix, controlCount: 1).get()

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, Complex(2), Complex(3)],
            [.zero, .zero, Complex(4), Complex(5)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoByTwoMatrixAndControlCountEqualToTwo_makeControlledMatrix_returnExpectedMatrix() {
        // When
        let result = try? Matrix.makeControlledMatrix(matrix: twoByTwoMatrix, controlCount: 2).get()

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
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testNonSquareMatrix_makeControlledMatrix_throwException",
         testNonSquareMatrix_makeControlledMatrix_throwException),
        ("testNonPowerOfTwoSizeMatrix_makeControlledMatrix_throwException",
         testNonPowerOfTwoSizeMatrix_makeControlledMatrix_throwException),
        ("testControlCountEqualToZero_makeControlledMatrix_throwException",
         testControlCountEqualToZero_makeControlledMatrix_throwException),
        ("testTwoByTwoMatrixAndControlCountEqualToOne_makeControlledMatrix_returnExpectedMatrix",
         testTwoByTwoMatrixAndControlCountEqualToOne_makeControlledMatrix_returnExpectedMatrix),
        ("testTwoByTwoMatrixAndControlCountEqualToTwo_makeControlledMatrix_returnExpectedMatrix",
         testTwoByTwoMatrixAndControlCountEqualToTwo_makeControlledMatrix_returnExpectedMatrix)
    ]
}
