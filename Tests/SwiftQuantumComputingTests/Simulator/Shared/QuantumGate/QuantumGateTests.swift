//
//  QuantumGateTests.swift
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

class QuantumGateTests: XCTestCase {

    // MARK: - Tests

    func testNonUnitaryMatrix_init_throwException() {
        // Given
        let complex = Complex(real: 1, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])

        // Then
        XCTAssertThrowsError(try QuantumGate(matrix: matrix))
    }

    func testUnitaryMatrix_init_returnGate() {
        // Given
        let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                                  [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])

        // Then
        XCTAssertNoThrow(try QuantumGate(matrix: matrix))
    }

    func testAnyGate_matrix_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                                  [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])
        let gate = try! QuantumGate(matrix: matrix)

        // Then
        XCTAssertEqual(gate.matrix, matrix)
    }

    func testAnyGate_qubitCount_returnExpectedValue() {
        // Given
        let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                                  [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])
        let gate = try! QuantumGate(matrix: matrix)

        // Then
        XCTAssertEqual(gate.qubitCount, 1)
    }

    static var allTests = [
        ("testNonUnitaryMatrix_init_throwException", testNonUnitaryMatrix_init_throwException),
        ("testUnitaryMatrix_init_returnGate", testUnitaryMatrix_init_returnGate),
        ("testAnyGate_matrix_returnExpectedMatrix", testAnyGate_matrix_returnExpectedMatrix),
        ("testAnyGate_qubitCount_returnExpectedValue", testAnyGate_qubitCount_returnExpectedValue)
    ]
}
