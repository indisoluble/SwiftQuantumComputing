//
//  Matrix+TransposedTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/09/2020.
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

class Matrix_TransposedTests: XCTestCase {

    // MARK: - Tests

    func testSquareMatrix_transposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[.i, .one], [Complex(1, 1), .zero]])

        // When
        let result = matrix.transposed()

        // Then
        let expectedResult = try! Matrix([[.i, Complex(1, 1)], [.one, .zero]])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithMoreColumnsThanRows_transposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [.one, Complex(-2, -1), Complex(5)],
            [Complex(1, 1), .i, Complex(4, -2)]
        ])

        // When
        let result = matrix.transposed()

        // Then
        let expectedResult = try! Matrix([
            [.one, Complex(1, 1)],
            [Complex(-2, -1), .i],
            [Complex(5), Complex(4, -2)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    func testMatrixWithMoreRowsThanColumns_transposed_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([
            [.one, Complex(1, -1)],
            [Complex(-2, 1), Complex(imaginary: -1)],
            [Complex(5), Complex(4, 2)]
        ])

        // When
        let result = matrix.transposed()

        // Then
        let expectedResult = try! Matrix([
            [.one, Complex(-2, 1), Complex(5)],
            [Complex(1, -1), Complex(imaginary: -1), Complex(4, 2)]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testSquareMatrix_transposed_returnExpectedMatrix",
         testSquareMatrix_transposed_returnExpectedMatrix),
        ("testMatrixWithMoreColumnsThanRows_transposed_returnExpectedMatrix",
         testMatrixWithMoreColumnsThanRows_transposed_returnExpectedMatrix),
        ("testMatrixWithMoreRowsThanColumns_transposed_returnExpectedMatrix",
         testMatrixWithMoreRowsThanColumns_transposed_returnExpectedMatrix)
    ]
}
