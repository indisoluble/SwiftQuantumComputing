//
//  CSMElementByElementStatevectorTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/05/2020.
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

class CSMElementByElementStatevectorTransformationTests: XCTestCase {

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_init_throwError() {
        // Then
        XCTAssertThrowsError(try CSMElementByElementStatevectorTransformation(maxConcurrency: 0))
    }

    func testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2
        var elements = Array(repeating: Complex<Double>.zero, count: Int.pow(2, qubitCount))
        elements[0] = .one

        let vector = try! Vector(elements)
        let adapter = try! CSMElementByElementStatevectorTransformation(maxConcurrency: 1)

        let circuitElement = CircuitSimulatorMatrix(qubitCount: qubitCount,
                                                    baseMatrix: Matrix.makeNot(),
                                                    inputs: [0])

        // When
        let result = adapter.apply(matrix: circuitElement, toStatevector: vector)

        // Then
        let expectedVector = try! Vector([Complex.zero, Complex.one, Complex.zero, Complex.zero])
        XCTAssertEqual(result, expectedVector)
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_init_throwError",
         testMaxConcurrencyEqualToZero_init_throwError),
        ("testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne)
    ]

}
