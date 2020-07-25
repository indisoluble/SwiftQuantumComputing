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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Matrix_TensorProductTests: XCTestCase {

    // MARK: - Tests

    func testTwoMatrices_tensorProduct_returnExpectedMatrix() {
        // Given
        let lhsElements: [[Complex<Double>]] = [
            [Complex(3, 2), Complex(5, -1), Complex(imaginary: 2)],
            [.zero, Complex(12), Complex(6, -3)],
            [Complex(2), Complex(4, 4), Complex(9, 3)]
        ]
        let lhs = try! Matrix(lhsElements)

        let rhsElements: [[Complex<Double>]] = [
            [.one, Complex(3, 4), Complex(5, -7)],
            [Complex(10, 2), Complex(6), Complex(2, 5)],
            [.zero, .one, Complex(2, 9)]
        ]
        let rhs = try! Matrix(rhsElements)

        // When
        let result = Matrix.tensorProduct(lhs, rhs)

        // Then
        let expectedElements: [[Complex<Double>]] = [
            [Complex(3, 2), Complex(1, 18), Complex(29, -11),
             Complex(5, -1), Complex(19, 17), Complex(18, -40),
             Complex(imaginary: 2), Complex(-8, 6), Complex(14, 10)],
            [Complex(26, 26), Complex(18, 12), Complex(-4, 19),
             Complex(52), Complex(30, -6), Complex(15, 23),
             Complex(-4, 20), Complex(imaginary: 12), Complex(-10, 4)],
            [.zero, Complex(3, 2), Complex(-12, 31),
             .zero, Complex(5, -1), Complex(19, 43),
             .zero, Complex(imaginary: 2), Complex(-18, 4)],
            [.zero, .zero, .zero,
             Complex(12), Complex(36, 48), Complex(60, -84),
             Complex(6, -3), Complex(30, 15), Complex(9, -57)],
            [.zero, .zero, .zero,
             Complex(120, 24), Complex(72), Complex(24, 60),
             Complex(66, -18), Complex(36, -18), Complex(27, 24)],
            [.zero, .zero, .zero,
             .zero, Complex(12), Complex(24, 108),
             .zero, Complex(6, -3), Complex(39, 48)],
            [Complex(2), Complex(6, 8), Complex(10, -14),
             Complex(4, 4), Complex(-4, 28), Complex(48, -8),
             Complex(9, 3), Complex(15, 45), Complex(66, -48)],
            [Complex(20, 4), Complex(12), Complex(4, 10),
             Complex(32, 48), Complex(24, 24), Complex(-12, 28),
             Complex(84, 48), Complex(54, 18), Complex(3, 51)],
            [.zero, Complex(2), Complex(4, 18),
             .zero, Complex(4, 4), Complex(-28, 44),
             .zero, Complex(9, 3), Complex(-9, 87)]
        ]
        let expectedResult = try? Matrix(expectedElements)
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testTwoMatrices_tensorProduct_returnExpectedMatrix",
         testTwoMatrices_tensorProduct_returnExpectedMatrix)
    ]
}
