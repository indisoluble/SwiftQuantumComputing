//
//  Matrix+AverageTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/02/2020.
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

class Matrix_AverageTests: XCTestCase {

    // MARK: - Tests

    func testCountEqualToZero_makeAverage_throwException() {
        // Then
        var error: Matrix.MakeAverageError?
        if case .failure(let e) = Matrix.makeAverage(count: 0) {
            error = e
        }
        XCTAssertEqual(error, .passCountBiggerThanZero)
    }

    func testCountBiggerThanZero_mamakeAveragekeMatrix_returnExpectedMatrix() {
        // Given
        let count = 3

        // When
        let matrix = try? Matrix.makeAverage(count: count).get()

        // Then
        let value = Complex(Double(1) / Double(count))
        let expectedMatrix = try? Matrix([[value, value, value],
                                          [value, value, value],
                                          [value, value, value]])
        XCTAssertEqual(matrix, expectedMatrix)
    }

    static var allTests = [
        ("testCountEqualToZero_makeAverage_throwException",
         testCountEqualToZero_makeAverage_throwException),
        ("testCountBiggerThanZero_mamakeAveragekeMatrix_returnExpectedMatrix",
         testCountBiggerThanZero_mamakeAveragekeMatrix_returnExpectedMatrix)
    ]
}
