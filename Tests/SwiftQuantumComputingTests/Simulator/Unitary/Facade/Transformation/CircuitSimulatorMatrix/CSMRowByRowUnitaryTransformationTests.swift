//
//  CSMRowByRowUnitaryTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/06/2021.
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

class CSMRowByRowUnitaryTransformationTests: XCTestCase {

    // MARK: - Tests

    func testUnitaryCalculationConcurrencyEqualToZero_init_throwException() {
        // Then
        XCTAssertThrowsError(try CSMRowByRowUnitaryTransformation(calculationConcurrency: 0,
                                                                  expansionConcurrency: 1))
    }

    func testRowExpansionConcurrencyEqualToZero_init_throwException() {
        // Then
        XCTAssertThrowsError(try CSMRowByRowUnitaryTransformation(calculationConcurrency: 1,
                                                                  expansionConcurrency: 0))
    }

    func testGivenHadamardAndNot_apply_returnExpectedMatrix() {
        // Given
        let sut = try! CSMRowByRowUnitaryTransformation(calculationConcurrency: 1,
                                                        expansionConcurrency: 1)
        let circuitMatrix = CircuitSimulatorMatrix(qubitCount: 1,
                                                   baseMatrix: Matrix.makeNot(),
                                                   inputs: [0])

        // When
        let result = sut.apply(circuitMatrix: circuitMatrix, toUnitary: Matrix.makeHadamard())

        // Then
        let expectedResult = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex.one, Complex(-1)],
                                                                   [Complex.one, Complex.one]])))
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testUnitaryCalculationConcurrencyEqualToZero_init_throwException",
         testUnitaryCalculationConcurrencyEqualToZero_init_throwException),
        ("testRowExpansionConcurrencyEqualToZero_init_throwException",
         testRowExpansionConcurrencyEqualToZero_init_throwException),
        ("testGivenHadamardAndNot_apply_returnExpectedMatrix",
         testGivenHadamardAndNot_apply_returnExpectedMatrix)
    ]
}
