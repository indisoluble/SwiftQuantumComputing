//
//  Complex+MatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/07/2020.
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

class Complex_MatrixTests: XCTestCase {

    // MARK: - Tests

    func testNotOneByOneMatrix_init_throwException() {
        // Given
        let matrix = try! Matrix([[.zero, .zero], [.zero, .zero]])

        // Then
        XCTAssertThrowsError(try Complex(matrix))
    }

    func testOneByOneMatrix_init_returnExpectedComplexNumber() {
        // Given
        let expectedValue = Complex<Double>(10, 10)
        let matrix = try! Matrix([[expectedValue]])

        // Then
        XCTAssertEqual(try? Complex(matrix), expectedValue)
    }

    static var allTests = [
        ("testNotOneByOneMatrix_init_throwException",
         testNotOneByOneMatrix_init_throwException),
        ("testOneByOneMatrix_init_returnExpectedComplexNumber",
         testOneByOneMatrix_init_returnExpectedComplexNumber)
    ]
}
