//
//  CircuitStatevector+CircuitDensityMatrixTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 18/07/2021.
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

class CircuitStatevector_CircuitDensityMatrixTests: XCTestCase {

    // MARK: - Tests

    func testAnyStatevector_densityMatrix_returnExpectedResult() {
        // Given
        let value = Complex(1.0 / sqrt(2.0))
        let vector = try!  Vector([value, .zero, .zero, value])
        let statevector = try! MainCircuitStatevectorFactory().makeStatevector(vector: vector).get()

        // When
        let result = statevector.densityMatrix()

        // Then
        let expectedValue = Complex(1.0 / 2.0)
        let expectedResult = try! Matrix([
            [expectedValue, .zero, .zero, expectedValue],
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero],
            [expectedValue, .zero, .zero, expectedValue]
        ])
        XCTAssertTrue(expectedResult.isApproximatelyEqual(to: result.densityMatrix,
                                                          absoluteTolerance: SharedConstants.tolerance))
    }

    func testOtherStatevector_densityMatrix_returnExpectedResult() {
        // Given
        let vector = try!  Vector([.one, .zero, .zero, .zero])
        let statevector = try! MainCircuitStatevectorFactory().makeStatevector(vector: vector).get()

        // When
        let result = statevector.densityMatrix()

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero]
        ])
        XCTAssertTrue(expectedResult.isApproximatelyEqual(to: result.densityMatrix,
                                                          absoluteTolerance: SharedConstants.tolerance))
    }

    func testAnotherStatevector_densityMatrix_returnExpectedResult() {
        // Given
        let vector = try!  Vector([.zero, .one, .zero, .zero])
        let statevector = try! MainCircuitStatevectorFactory().makeStatevector(vector: vector).get()

        // When
        let result = statevector.densityMatrix()

        // Then
        let expectedResult = try! Matrix([
            [.zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero]
        ])
        XCTAssertTrue(expectedResult.isApproximatelyEqual(to: result.densityMatrix,
                                                          absoluteTolerance: SharedConstants.tolerance))
    }

    static var allTests = [
        ("testAnyStatevector_densityMatrix_returnExpectedResult",
         testAnyStatevector_densityMatrix_returnExpectedResult),
        ("testOtherStatevector_densityMatrix_returnExpectedResult",
         testOtherStatevector_densityMatrix_returnExpectedResult),
        ("testAnotherStatevector_densityMatrix_returnExpectedResult",
         testAnotherStatevector_densityMatrix_returnExpectedResult)
    ]
}
