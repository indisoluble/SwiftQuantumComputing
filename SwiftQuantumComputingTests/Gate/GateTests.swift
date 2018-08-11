//
//  GateTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 11/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class GateTests: XCTestCase {

    // MARK: - Tests

    func testNonUnitaryMatrix_init_returnNil() {
        // Given
        let complex = Complex(real: 1, imag: 0)
        let matrix = Matrix([[complex, complex, complex],
                             [complex, complex, complex],
                             [complex, complex, complex]])!

        // Then
        XCTAssertNil(Gate(matrix: matrix))
    }

    func testUnitaryMatrix_init_returnGate() {
        // Given
        let matrix = Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                             [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])!

        // Then
        XCTAssertNotNil(Gate(matrix: matrix))
    }

    func testAnyGateAndVectorWithDifferentSizeThanGate_apply_returnNil() {
        // Given
        let matrix = Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!
        let gate = Gate(matrix: matrix)!

        let vector = Vector([Complex(1), Complex(0), Complex(0)])!

        // Then
        XCTAssertNil(gate.apply(to: vector))
    }

    func testAnyGateAndVectorWithSameSizeThanGate_apply_returnExpectedVector() {
        // Given
        let matrix = Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!
        let gate = Gate(matrix: matrix)!

        let vector = Vector([Complex(1), Complex(0)])!

        // When
        let result = gate.apply(to: vector)

        // Then
        let expectedResult = Vector([Complex(0), Complex(1)])
        XCTAssertEqual(result, expectedResult)
    }
}
