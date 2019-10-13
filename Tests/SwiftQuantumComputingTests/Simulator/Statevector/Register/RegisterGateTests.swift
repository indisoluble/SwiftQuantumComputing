//
//  RegisterGateTests.swift
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

class RegisterGateTests: XCTestCase {

    // MARK: - Tests

    func testNonUnitaryMatrix_init_throwException() {
        // Given
        let complex = Complex(real: 1, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])

        // Then
        XCTAssertThrowsError(try RegisterGate(matrix: matrix))
    }

    func testUnitaryMatrix_init_returnRegisterGate() {
        // Given
        let matrix = try! Matrix([[Complex(real: 0, imag: 0), Complex(real: 0, imag: -1)],
                                  [Complex(real: 0, imag: 1), Complex(real: 0, imag: 0)]])

        // Then
        XCTAssertNoThrow(try RegisterGate(matrix: matrix))
    }

    func testAnyRegisterGateAndVectorWithDifferentSizeThanGate_apply_throwException() {
        // Given
        let matrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrix)

        let vector = try! Vector([Complex(1), Complex(0), Complex(0)])

        // Then
        XCTAssertThrowsError(try gate.apply(to: vector))
    }

    func testAnyRegisterGateAndVectorWithSameSizeThanGate_apply_returnExpectedVector() {
        // Given
        let matrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrix)

        let vector = try! Vector([Complex(1), Complex(0)])

        // When
        let result = try? gate.apply(to: vector)

        // Then
        let expectedResult = try! Vector([Complex(0), Complex(1)])
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyRegisterGateAndMatrixWithRowCountDifferentThanGateMatrixColumnCount_apply_throwException() {
        // Given
        let matrixGate = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrixGate)

        let matrix = try! Matrix([[Complex(1), Complex(0)]])

        // Then
        XCTAssertThrowsError(try gate.apply(to: matrix))
    }

    func testAnyRegisterGateAndMatrixWithRowCountSameThanGateMatrixColumnCount_apply_returnExpectedVector() {
        // Given
        let matrixGate = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrixGate)

        let matrix = try! Matrix([[Complex(1)], [Complex(0)]])

        // When
        let result = try? gate.apply(to: matrix)

        // Then
        let expectedResult = try! Matrix([[Complex(0)], [Complex(1)]])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testNonUnitaryMatrix_init_throwException",
         testNonUnitaryMatrix_init_throwException),
        ("testUnitaryMatrix_init_returnRegisterGate",
         testUnitaryMatrix_init_returnRegisterGate),
        ("testAnyRegisterGateAndVectorWithDifferentSizeThanGate_apply_throwException",
         testAnyRegisterGateAndVectorWithDifferentSizeThanGate_apply_throwException),
        ("testAnyRegisterGateAndVectorWithSameSizeThanGate_apply_returnExpectedVector",
         testAnyRegisterGateAndVectorWithSameSizeThanGate_apply_returnExpectedVector),
        ("testAnyRegisterGateAndMatrixWithRowCountDifferentThanGateMatrixColumnCount_apply_throwException",
         testAnyRegisterGateAndMatrixWithRowCountDifferentThanGateMatrixColumnCount_apply_throwException),
        ("testAnyRegisterGateAndMatrixWithRowCountSameThanGateMatrixColumnCount_apply_returnExpectedVector",
         testAnyRegisterGateAndMatrixWithRowCountSameThanGateMatrixColumnCount_apply_returnExpectedVector)
    ]
}
