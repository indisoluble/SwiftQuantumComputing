//
//  Matrix+TwoLevelUnitaryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/10/2020.
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

class Matrix_TwoLevelUnitaryTests: XCTestCase {

    // MARK: - Properties

    let count = 4
    let submatrix = Matrix.makeHadamard()

    // MARK: - Tests

    func testCountEqualToTwo_makeTwoLevelUnitary_throwException() {
        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: 2,
                                                             submatrix: submatrix,
                                                             firstIndex: 0,
                                                             secondIndex: 1) {
            error = e
        }
        XCTAssertEqual(error, .passCountBiggerThanTwo)
    }

    func testNonSquareSubmatrix_makeTwoLevelUnitary_throwException() {
        // Given
        let nonSquareMatrix = try! Matrix([[.one, .zero, .zero], [.zero, .one, .zero]])

        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: count,
                                                             submatrix: nonSquareMatrix,
                                                             firstIndex: 0,
                                                             secondIndex: 1) {
            error = e
        }
        XCTAssertEqual(error, .submatrixIsNot2x2)
    }

    func testNon2x2Submatrix_makeTwoLevelUnitary_throwException() {
        // Given
        let non2x2Matrix = try! Matrix(
            [[.one, .zero, .zero],
             [.zero, .one, .zero],
             [.zero, .zero, .one]]
        )

        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: count,
                                                             submatrix: non2x2Matrix,
                                                             firstIndex: 0,
                                                             secondIndex: 1) {
            error = e
        }
        XCTAssertEqual(error, .submatrixIsNot2x2)
    }

    func testNonUnitarySubmatrix_makeTwoLevelUnitary_throwException() {
        // Given
        let non2x2Matrix = try! Matrix([[.one, .zero], [.i, .one]])

        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: count,
                                                             submatrix: non2x2Matrix,
                                                             firstIndex: 0,
                                                             secondIndex: 1) {
            error = e
        }
        XCTAssertEqual(error, .submatrixIsNotUnitary)
    }

    func testUnsortedIndexes_makeTwoLevelUnitary_throwException() {
        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: count,
                                                             submatrix: submatrix,
                                                             firstIndex: 1,
                                                             secondIndex: 0) {
            error = e
        }
        XCTAssertEqual(error, .firstIndexIsNotSmallerThanSecondIndex)
    }

    func testIndexesOutOfRange_makeTwoLevelUnitary_throwException() {
        // Then
        var error: Matrix.MakeTwoLevelUnitaryError?
        if case .failure(let e) = Matrix.makeTwoLevelUnitary(count: count,
                                                             submatrix: submatrix,
                                                             firstIndex: 0,
                                                             secondIndex: count + 1) {
            error = e
        }
        XCTAssertEqual(error, .indexesOutOfRange)
    }

    func testValidSubmatrixCountToFourAndPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix() {
        // When
        let matrix = try! Matrix.makeTwoLevelUnitary(count: count,
                                                     submatrix: submatrix,
                                                     firstIndex: 0,
                                                     secondIndex: 1).get()

        // Then
        let expectedMatrix = try! Matrix(
            [[submatrix[0, 0], submatrix[0, 1], .zero, .zero],
             [submatrix[1, 0], submatrix[1, 1], .zero, .zero],
             [.zero, .zero, .one, .zero],
             [.zero, .zero, .zero, .one]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testValidSubmatrixCountToFourAndOtherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix() {
        // When
        let matrix = try! Matrix.makeTwoLevelUnitary(count: count,
                                                     submatrix: submatrix,
                                                     firstIndex: 2,
                                                     secondIndex: 3).get()

        // Then
        let expectedMatrix = try! Matrix(
            [[.one, .zero, .zero, .zero],
             [.zero, .one, .zero, .zero],
             [.zero, .zero, submatrix[0, 0], submatrix[0, 1]],
             [.zero, .zero, submatrix[1, 0], submatrix[1, 1]]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testValidSubmatrixCountToFourAndAnotherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix() {
        // When
        let matrix = try! Matrix.makeTwoLevelUnitary(count: count,
                                                     submatrix: submatrix,
                                                     firstIndex: 0,
                                                     secondIndex: 2).get()

        // Then
        let expectedMatrix = try! Matrix(
            [[submatrix[0, 0], .zero, submatrix[0, 1], .zero],
             [.zero, .one, .zero, .zero],
             [submatrix[1, 0], .zero, submatrix[1, 1], .zero],
             [.zero, .zero, .zero, .one]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    func testValidSubmatrixCountToFourAndOneMorePairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix() {
        // When
        let matrix = try! Matrix.makeTwoLevelUnitary(count: count,
                                                     submatrix: submatrix,
                                                     firstIndex: 1,
                                                     secondIndex: 3).get()

        // Then
        let expectedMatrix = try! Matrix(
            [[.one, .zero, .zero, .zero],
             [.zero, submatrix[0, 0], .zero, submatrix[0, 1]],
             [.zero, .zero, .one, .zero],
             [.zero, submatrix[1, 0], .zero, submatrix[1, 1]]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    static var allTests = [
        ("testCountEqualToTwo_makeTwoLevelUnitary_throwException",
         testCountEqualToTwo_makeTwoLevelUnitary_throwException),
        ("testNonSquareSubmatrix_makeTwoLevelUnitary_throwException",
         testNonSquareSubmatrix_makeTwoLevelUnitary_throwException),
        ("testNon2x2Submatrix_makeTwoLevelUnitary_throwException",
         testNon2x2Submatrix_makeTwoLevelUnitary_throwException),
        ("testNonUnitarySubmatrix_makeTwoLevelUnitary_throwException",
         testNonUnitarySubmatrix_makeTwoLevelUnitary_throwException),
        ("testUnsortedIndexes_makeTwoLevelUnitary_throwException",
         testUnsortedIndexes_makeTwoLevelUnitary_throwException),
        ("testIndexesOutOfRange_makeTwoLevelUnitary_throwException",
         testIndexesOutOfRange_makeTwoLevelUnitary_throwException),
        ("testValidSubmatrixCountToFourAndPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix",
         testValidSubmatrixCountToFourAndPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix),
        ("testValidSubmatrixCountToFourAndOtherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix",
         testValidSubmatrixCountToFourAndOtherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix),
        ("testValidSubmatrixCountToFourAndAnotherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix",
         testValidSubmatrixCountToFourAndAnotherPairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix),
        ("testValidSubmatrixCountToFourAndOneMorePairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix",
         testValidSubmatrixCountToFourAndOneMorePairOfIndexes_makeTwoLevelUnitary_returnExpectedMatrix)
    ]
}
