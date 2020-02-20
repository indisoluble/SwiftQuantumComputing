//
//  Matrix+TensorProductTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/02/2020.
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

class Matrix_TensorProductTests: XCTestCase {

    // MARK: - Tests

    func testTwoMatrices_tensorProduct_returnExpectedMatrix() {
        // Given
        let lhsElements = [
            [Complex(real: 3, imag: 2), Complex(real: 5, imag: -1), Complex(real: 0, imag: 2)],
            [Complex(real: 0, imag: 0), Complex(real: 12, imag: 0), Complex(real: 6, imag: -3)],
            [Complex(real: 2, imag: 0), Complex(real: 4, imag: 4), Complex(real: 9, imag: 3)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements = [
            [Complex(real: 1, imag: 0), Complex(real: 3, imag: 4), Complex(real: 5, imag: -7)],
            [Complex(real: 10, imag: 2), Complex(real: 6, imag: 0), Complex(real: 2, imag: 5)],
            [Complex(real: 0, imag: 0), Complex(real: 1, imag: 0), Complex(real: 2, imag: 9)]
        ]
        let rhs = try! Matrix(rhsElements)

        // When
        let result = Matrix.tensorProduct(lhs, rhs)

        // Then
        let expectedElements = [
            [Complex(real: 3, imag: 2), Complex(real: 1, imag: 18), Complex(real: 29, imag: -11),
             Complex(real: 5, imag: -1), Complex(real: 19, imag: 17), Complex(real: 18, imag: -40),
             Complex(real: 0, imag: 2), Complex(real: -8, imag: 6), Complex(real: 14, imag: 10)],
            [Complex(real: 26, imag: 26), Complex(real: 18, imag: 12), Complex(real: -4, imag: 19),
             Complex(real: 52, imag: 0), Complex(real: 30, imag: -6), Complex(real: 15, imag: 23),
             Complex(real: -4, imag: 20), Complex(real: 0, imag: 12), Complex(real: -10, imag: 4)],
            [Complex(real: 0, imag: 0), Complex(real: 3, imag: 2), Complex(real: -12, imag: 31),
             Complex(real: 0, imag: 0), Complex(real: 5, imag: -1), Complex(real: 19, imag: 43),
             Complex(real: 0, imag: 0), Complex(real: 0, imag: 2), Complex(real: -18, imag: 4)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 0),
             Complex(real: 12, imag: 0), Complex(real: 36, imag: 48), Complex(real: 60, imag: -84),
             Complex(real: 6, imag: -3), Complex(real: 30, imag: 15), Complex(real: 9, imag: -57)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 0),
             Complex(real: 120, imag: 24), Complex(real: 72, imag: 0), Complex(real: 24, imag: 60),
             Complex(real: 66, imag: -18), Complex(real: 36, imag: -18), Complex(real: 27, imag: 24)],
            [Complex(real: 0, imag: 0), Complex(real: 0, imag: 0), Complex(real: 0, imag: 0),
             Complex(real: 0, imag: 0), Complex(real: 12, imag: 0), Complex(real: 24, imag: 108),
             Complex(real: 0, imag: 0), Complex(real: 6, imag: -3), Complex(real: 39, imag: 48)],
            [Complex(real: 2, imag: 0), Complex(real: 6, imag: 8), Complex(real: 10, imag: -14),
             Complex(real: 4, imag: 4), Complex(real: -4, imag: 28), Complex(real: 48, imag: -8),
             Complex(real: 9, imag: 3), Complex(real: 15, imag: 45), Complex(real: 66, imag: -48)],
            [Complex(real: 20, imag: 4), Complex(real: 12, imag: 0), Complex(real: 4, imag: 10),
             Complex(real: 32, imag: 48), Complex(real: 24, imag: 24), Complex(real: -12, imag: 28),
             Complex(real: 84, imag: 48), Complex(real: 54, imag: 18), Complex(real: 3, imag: 51)],
            [Complex(real: 0, imag: 0), Complex(real: 2, imag: 0), Complex(real: 4, imag: 18),
             Complex(real: 0, imag: 0), Complex(real: 4, imag: 4), Complex(real: -28, imag: 44),
             Complex(real: 0, imag: 0), Complex(real: 9, imag: 3), Complex(real: -9, imag: 87)]
        ]
        let expectedResult = try? Matrix(expectedElements)
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testTwoMatrices_tensorProduct_returnExpectedMatrix",
         testTwoMatrices_tensorProduct_returnExpectedMatrix)
    ]
}
