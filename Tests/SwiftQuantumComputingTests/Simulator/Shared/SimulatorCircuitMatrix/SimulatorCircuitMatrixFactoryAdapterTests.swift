//
//  SimulatorCircuitMatrixFactoryAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/02/2020.
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

class SimulatorCircuitMatrixFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = try! Matrix([[Complex.one, Complex.zero, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.one, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.zero, Complex.zero, Complex.one],
                                   [Complex.zero, Complex.zero, Complex.one, Complex.zero]])
    let validInputs = [1, 0]
    let otherValidMatrix = try! Matrix([[Complex.zero, Complex.one], [Complex.one, Complex.zero]])
    let otherValidInputs = [0]

    let sut = SimulatorCircuitMatrixFactoryAdapter()

    // MARK: - Tests

    func testMatrixWithSizeNonPowerOfTwo_makeCircuitMatrix_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])
        let gate = Gate.matrix(matrix: matrix, inputs: [0])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testNonUnitaryMatrix_makeCircuitMatrix_throwException() {
        // Given
        let matrix = try! Matrix([[Complex.zero, Complex.one], [Complex.one, Complex.one]])
        let gate = Gate.matrix(matrix: matrix, inputs: [0])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException() {
        // Given
        let qubitCount = 0
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: qubitCount, gate: gate))
    }

    func testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException() {
        // Given
        let qubitCount = 1
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: qubitCount, gate: gate))
    }

    func testRepeatedInputs_makeCircuitMatrix_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [1, 1])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testInputsOutOfRange_makeCircuitMatrix_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, validQubitCount])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testMoreInputsThanGateTakes_makeCircuitMatrix_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [2, 1, 0])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testLessInputsThanGateTakes_makeCircuitMatrix_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [])

        // Then
        XCTAssertThrowsError(try sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate))
    }

    func testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // When
        let matrix = try? sut.makeCircuitMatrix(qubitCount: 2, gate: gate)

        // Then
        XCTAssertEqual(matrix, validMatrix)
    }

    func testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix() {
        // Given
        let gate = Gate.matrix(matrix: otherValidMatrix, inputs: otherValidInputs)

        // When
        let matrix = try? sut.makeCircuitMatrix(qubitCount: 1, gate: gate)

        // Then
        XCTAssertEqual(matrix, otherValidMatrix)
    }

    func testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeCircuitMatrix_returnExpectedMatrix() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs.reversed())

        // When
        let matrix = try? sut.makeCircuitMatrix(qubitCount: 2, gate: gate)

        // Then
        let expectedElements = [
            [Complex.one, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one],
            [Complex.zero, Complex.zero, Complex.one, Complex.zero],
            [Complex.zero, Complex.one, Complex.zero, Complex.zero]
        ]
        XCTAssertEqual(matrix, try? Matrix(expectedElements))
    }

    func testNonContiguousInputs_makeCircuitMatrix_returnExpectedMatrix() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, 2])

        // When
        let matrix = try? sut.makeCircuitMatrix(qubitCount: validQubitCount, gate: gate)

        // Then
        let expectedElements = [
            [Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero]
        ]
        XCTAssertEqual(matrix, try? Matrix(expectedElements))
    }

    func testContiguousInputsButInTheMiddle_makeCircuitMatrix_returnExpectedMatrix() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [2, 1])

        // When
        let matrix = try? sut.makeCircuitMatrix(qubitCount: 4, gate: gate)

        // Then
        let expectedElements = [
            [Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero,
             Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one, Complex.zero, Complex.zero]]
        XCTAssertEqual(matrix, try? Matrix(expectedElements))
    }

    static var allTests = [
        ("testMatrixWithSizeNonPowerOfTwo_makeCircuitMatrix_throwException",
         testMatrixWithSizeNonPowerOfTwo_makeCircuitMatrix_throwException),
        ("testNonUnitaryMatrix_makeCircuitMatrix_throwException",
         testNonUnitaryMatrix_makeCircuitMatrix_throwException),
        ("testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException",
         testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException),
        ("testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException",
         testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException),
        ("testRepeatedInputs_makeCircuitMatrix_throwException",
         testRepeatedInputs_makeCircuitMatrix_throwException),
        ("testInputsOutOfRange_makeCircuitMatrix_throwException",
         testInputsOutOfRange_makeCircuitMatrix_throwException),
        ("testMoreInputsThanGateTakes_makeCircuitMatrix_throwException",
         testMoreInputsThanGateTakes_makeCircuitMatrix_throwException),
        ("testLessInputsThanGateTakes_makeCircuitMatrix_throwException",
         testLessInputsThanGateTakes_makeCircuitMatrix_throwException),
        ("testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix",
         testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_makeCircuitMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeCircuitMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeCircuitMatrix_returnExpectedMatrix),
        ("testNonContiguousInputs_makeCircuitMatrix_returnExpectedMatrix",
         testNonContiguousInputs_makeCircuitMatrix_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_makeCircuitMatrix_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_makeCircuitMatrix_returnExpectedMatrix)
    ]
}
