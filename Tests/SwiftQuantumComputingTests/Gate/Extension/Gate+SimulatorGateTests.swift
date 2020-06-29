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

    func testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.controlledMatrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0], control: 1)

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixRowCountHasToBeAPowerOfTwo)
    }

    func testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixRowCountHasToBeAPowerOfTwo)
    }

    func testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.controlledMatrix(matrix: nonUnitaryMatrix, inputs: [0], control: 1)

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
    }

    func testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonUnitaryMatrix, inputs: [0])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
    }

    func testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [2, 1, 0])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateInputCountDoesNotMatchGateMatrixQubitCount)
    }

    func testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateInputCountDoesNotMatchGateMatrixQubitCount)
    }

    func testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [1, 1])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateInputsAreNotUnique)
    }

    func testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException() {
        // Given
        let qubitCount = 0
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .circuitQubitCountHasToBeBiggerThanZero)
    }

    func testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException() {
        // Given
        let qubitCount = 1
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateMatrixHandlesMoreQubitsThatCircuitActuallyHas)
    }

    func testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, validQubitCount])

        // Then
        var error: GateError?
        if case .failure(let e) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateInputsAreNotInBound)
    }

    func testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // When
        var matrix: Matrix?
        var inputs: [Int]?
        if case .success(let result) = gate.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(matrix, validMatrix)
        XCTAssertEqual(inputs, validInputs)
    }

    static var allTests = [
        ("testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException",
         testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException),
        ("testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException",
         testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException),
        ("testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException",
         testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException),
        ("testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException",
         testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues",
         testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues)
    ]
}
