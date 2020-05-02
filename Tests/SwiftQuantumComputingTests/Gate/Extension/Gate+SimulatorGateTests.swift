//
//  Gate+SimulatorGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 18/04/2020.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Gate_SimulatorGateTests: XCTestCase {

    // MARK: - Properties

    let nonPowerOfTwoSizeMatrix = try! Matrix([
        [Complex.zero, Complex.zero, Complex.zero],
        [Complex.zero, Complex.zero, Complex.zero],
        [Complex.zero, Complex.zero, Complex.zero]
    ])
    let nonUnitaryMatrix = try! Matrix([
        [Complex.zero, Complex.one],
        [Complex.one, Complex.one]
    ])
    let validMatrix = try! Matrix([
        [Complex.one, Complex.zero, Complex.zero, Complex.zero],
        [Complex.zero, Complex.one, Complex.zero, Complex.zero],
        [Complex.zero, Complex.zero, Complex.zero, Complex.one],
        [Complex.zero, Complex.zero, Complex.one, Complex.zero]
    ])
    let validQubitCount = 3
    let validInputs = [2, 1]

    // MARK: - Tests

    func testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException() {
        // Given
        let gate = Gate.controlledMatrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0], control: 1)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateControlledMatrixWithNonUnitaryMatrix_extract_throwException() {
        // Given
        let gate = Gate.controlledMatrix(matrix: nonUnitaryMatrix, inputs: [0], control: 1)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithNonUnitaryMatrix_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonUnitaryMatrix, inputs: [0])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [2, 1, 0])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithValidMatrixAndRepeatedInputs_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [1, 1])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extract_throwException() {
        // Given
        let qubitCount = 0
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: qubitCount))
    }

    func testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extract_throwException() {
        // Given
        let qubitCount = 1
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: qubitCount))
    }

    func testGateMatrixWithValidMatrixAndInputsOutOfRange_extract_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, validQubitCount])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    func testGateMatrixWithValidMatrixAndValidInputs_extract_returnExpectedValues() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // When
        let result = try? gate.extract(restrictedToCircuitQubitCount: validQubitCount)

        // Then
        XCTAssertEqual(result?.matrix, validMatrix)
        XCTAssertEqual(result?.inputs, validInputs)
    }

    static var allTests = [
        ("testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException",
         testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException),
        ("testGateMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException",
         testGateMatrixWithNonPowerOfTwoSizeMatrix_extract_throwException),
        ("testGateControlledMatrixWithNonUnitaryMatrix_extract_throwException",
         testGateControlledMatrixWithNonUnitaryMatrix_extract_throwException),
        ("testGateMatrixWithNonUnitaryMatrix_extract_throwException",
         testGateMatrixWithNonUnitaryMatrix_extract_throwException),
        ("testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extract_throwException",
         testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extract_throwException),
        ("testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extract_throwException",
         testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extract_throwException),
        ("testGateMatrixWithValidMatrixAndRepeatedInputs_extract_throwException",
         testGateMatrixWithValidMatrixAndRepeatedInputs_extract_throwException),
        ("testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extract_throwException",
         testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extract_throwException),
        ("testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extract_throwException",
         testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extract_throwException),
        ("testGateMatrixWithValidMatrixAndInputsOutOfRange_extract_throwException",
         testGateMatrixWithValidMatrixAndInputsOutOfRange_extract_throwException),
        ("testGateMatrixWithValidMatrixAndValidInputs_extract_returnExpectedValues",
         testGateMatrixWithValidMatrixAndValidInputs_extract_returnExpectedValues)
    ]
}
