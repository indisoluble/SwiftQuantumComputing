//
//  Matrix+ConjugateTransposedTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/03/2020.
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

class Matrix_ConjugateTransposedTests: XCTestCase {

    // MARK: - Tests

    func testSquareMatrix_conjugateTransposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [Complex(real: 0, imag: 1), Complex(real: 1, imag: 0)],
            [Complex(real: 1, imag: 1), Complex(real: 0, imag: 0)],
        ])

        // When
        let result = matrix.conjugateTransposed()

        // Then
        let expectedResult = try! Matrix([
            [Complex(real: 0, imag: -1), Complex(real: 1, imag: -1)],
            [Complex(real: 1, imag: 0), Complex(real: 0, imag: 0)],
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithMoreColumnsThanRows_conjugateTransposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [Complex(real: 1, imag: 0), Complex(real: -2, imag: -1), Complex(real: 5, imag: 0)],
            [Complex(real: 1, imag: 1), Complex(real: 0, imag: 1), Complex(real: 4, imag: -2)]
        ])

        // When
        let result = matrix.conjugateTransposed()

        // Then
        let expectedResult = try! Matrix([
            [Complex(real: 1, imag: 0), Complex(real: 1, imag: -1)],
            [Complex(real: -2, imag: 1), Complex(real: 0, imag: -1)],
            [Complex(real: 5, imag: 0), Complex(real: 4, imag: 2)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithMoreRowsThanColumns_conjugateTransposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [Complex(real: 1, imag: 0), Complex(real: 1, imag: -1)],
            [Complex(real: -2, imag: 1), Complex(real: 0, imag: -1)],
            [Complex(real: 5, imag: 0), Complex(real: 4, imag: 2)]
        ])

        // When
        let result = matrix.conjugateTransposed()

        // Then
        let expectedResult = try! Matrix([
            [Complex(real: 1, imag: 0), Complex(real: -2, imag: -1), Complex(real: 5, imag: 0)],
            [Complex(real: 1, imag: 1), Complex(real: 0, imag: 1), Complex(real: 4, imag: -2)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testSquareMatrix_conjugateTransposed_returnExpectedMatrix",
         testSquareMatrix_conjugateTransposed_returnExpectedMatrix),
        ("testMatrixWithMoreColumnsThanRows_conjugateTransposed_returnExpectedMatrix",
         testMatrixWithMoreColumnsThanRows_conjugateTransposed_returnExpectedMatrix),
        ("testMatrixWithMoreRowsThanColumns_conjugateTransposed_returnExpectedMatrix",
         testMatrixWithMoreRowsThanColumns_conjugateTransposed_returnExpectedMatrix)
    ]
}
