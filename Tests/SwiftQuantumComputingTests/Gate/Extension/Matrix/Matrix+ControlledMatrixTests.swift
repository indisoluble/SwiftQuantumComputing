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

    // MARK: - Tests

    func testOneByOneMatrix_makeControlledMatrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[Complex(2)]])

        // When
        let result = Matrix.makeControlledMatrix(matrix: matrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero],
            [.zero, Complex(2)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testOneByTwoMatrix_makeControlledMatrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[Complex(2), Complex(3)]])

        // When
        let result = Matrix.makeControlledMatrix(matrix: matrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, .zero, Complex(2), Complex(3)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoByOneMatrix_makeControlledMatrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[Complex(2)], [Complex(3)]])

        // When
        let result = Matrix.makeControlledMatrix(matrix: matrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero],
            [.zero, .zero],
            [.zero, Complex(2)],
            [.zero, Complex(3)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoByTwoMatrix_makeControlledMatrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [Complex(2), Complex(3)],
            [Complex(4), Complex(5)]
        ])

        // When
        let result = Matrix.makeControlledMatrix(matrix: matrix)

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, Complex(2), Complex(3)],
            [.zero, .zero, Complex(4), Complex(5)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testOneByOneMatrix_makeControlledMatrix_returnExpectedMatrix",
         testOneByOneMatrix_makeControlledMatrix_returnExpectedMatrix),
        ("testOneByTwoMatrix_makeControlledMatrix_returnExpectedMatrix",
         testOneByTwoMatrix_makeControlledMatrix_returnExpectedMatrix),
        ("testTwoByOneMatrix_makeControlledMatrix_returnExpectedMatrix",
         testTwoByOneMatrix_makeControlledMatrix_returnExpectedMatrix),
        ("testTwoByTwoMatrix_makeControlledMatrix_returnExpectedMatrix",
         testTwoByTwoMatrix_makeControlledMatrix_returnExpectedMatrix)
    ]
}
