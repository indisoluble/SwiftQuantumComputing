//
//  Matrix+IsHermitianTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class Matrix_IsHermitianTests: XCTestCase {

    // MARK: - Tests

    func testNonSquareMatrix_isHermitian_returnFalse() {
        // Given
        let row = [Complex<Double>.zero, Complex<Double>.zero]
        let matrix = try! Matrix((0..<(row.count + 1)).map({ _ in row }))

        // Then
        XCTAssertFalse(matrix.isHermitian)
    }

    func testNonHermitianSquareMatrix_isHermitian_returnFalse() {
        // Given
        let row = [Complex<Double>.one, Complex<Double>.i]
        let matrix = try! Matrix((0..<row.count).map({ _ in row }))

        // Then
        XCTAssertFalse(matrix.isHermitian)
    }

    func testAlmostHermitianMatrix_isHermitian_returnFalse() {
        // Given
        let matrix = try! Matrix([
            [.zero, Complex(1, -1), Complex(2, -3)],
            [Complex(1, 1), .one, Complex(4, -5)],
            [Complex(2, -3), Complex(4, 5), Complex(2)]
        ])

        // Then
        XCTAssertFalse(matrix.isHermitian)
    }

    func testAnotherAlmostHermitianMatrix_isHermitian_returnFalse() {
        // Given
        let matrix = try! Matrix([
            [.zero, Complex(1, -1), Complex(2, -3)],
            [Complex(1, 1), .one, Complex(4, -5)],
            [Complex(2, 3), Complex(4, 5), Complex(2, 1)]
        ])

        // Then
        XCTAssertFalse(matrix.isHermitian)
    }

    func testHermitianMatrix_isHermitian_returnTrue() {
        // Given
        let matrix = try! Matrix([
            [.one, Complex(3), .zero],
            [Complex(3), .one, Complex(-1)],
            [.zero, Complex(-1), .one]
        ])

        // Then
        XCTAssertTrue(matrix.isHermitian)
    }

    func testAnotherHermitianMatrix_isHermitian_returnTrue() {
        // Given
        let matrix = try! Matrix([
            [.zero, Complex(1, -1), Complex(2, -3)],
            [Complex(1, 1), .one, Complex(4, -5)],
            [Complex(2, 3), Complex(4, 5), Complex(2)]
        ])

        // Then
        XCTAssertTrue(matrix.isHermitian)
    }

    static var allTests = [
        ("testNonSquareMatrix_isHermitian_returnFalse",
         testNonSquareMatrix_isHermitian_returnFalse),
        ("testNonHermitianSquareMatrix_isHermitian_returnFalse",
         testNonHermitianSquareMatrix_isHermitian_returnFalse),
        ("testAlmostHermitianMatrix_isHermitian_returnFalse",
         testAlmostHermitianMatrix_isHermitian_returnFalse),
        ("testAnotherAlmostHermitianMatrix_isHermitian_returnFalse",
         testAnotherAlmostHermitianMatrix_isHermitian_returnFalse),
        ("testHermitianMatrix_isHermitian_returnTrue",
         testHermitianMatrix_isHermitian_returnTrue),
        ("testAnotherHermitianMatrix_isHermitian_returnTrue",
         testAnotherHermitianMatrix_isHermitian_returnTrue)
    ]
}
