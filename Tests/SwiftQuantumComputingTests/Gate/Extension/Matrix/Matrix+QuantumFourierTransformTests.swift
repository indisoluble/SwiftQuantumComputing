//
//  Matrix+QuantumFourierTransformTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/03/2020.
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

class Matrix_QuantumFourierTransformTests: XCTestCase {

    // MARK: - Tests

    func testCountEqualToZero_makeQuantumFourierTransform_throwError() {
        // Then
        var error: Matrix.MakeQuantumFourierTransformError?
        if case .failure(let e) = Matrix.makeQuantumFourierTransform(count: 0) {
            error = e
        }
        XCTAssertEqual(error, .passCountBiggerThanZero)
    }

    func testCountEqualToFour_makeQuantumFourierTransform_returnExpectedMatrix() {
        // When
        let result = try! Matrix.makeQuantumFourierTransform(count: 4).get()

        // Then
        let val = 1.0 / 2.0
        let expectedResult = try! Matrix([
            [Complex(val), Complex(val), Complex(val), Complex(val)],
            [Complex(val), Complex(imaginary: val), Complex(-val), Complex(imaginary: -val)],
            [Complex(val), Complex(-val), Complex(val), Complex(-val)],
            [Complex(val), Complex(imaginary: -val), Complex(-val), Complex(imaginary: val)]
        ])
        XCTAssertTrue(result.isApproximatelyEqual(to: expectedResult, absoluteTolerance: 0.00001))
    }

    static var allTests = [
        ("testCountEqualToZero_makeQuantumFourierTransform_throwError",
         testCountEqualToZero_makeQuantumFourierTransform_throwError),
        ("testCountEqualToFour_makeQuantumFourierTransform_returnExpectedMatrix",
         testCountEqualToFour_makeQuantumFourierTransform_returnExpectedMatrix)
    ]
}
