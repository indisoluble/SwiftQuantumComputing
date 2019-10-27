//
//  QuantumGateFactoryTests.swift
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

class QuantumGateFactoryTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = try! Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                                   [Complex(0), Complex(1), Complex(0), Complex(0)],
                                   [Complex(0), Complex(0), Complex(0), Complex(1)],
                                   [Complex(0), Complex(0), Complex(1), Complex(0)]])

    // MARK: - Tests

    func testNonSquareMatrix_init_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex], [complex]])

        // Then
        XCTAssertThrowsError(try QuantumGateFactory(qubitCount: validQubitCount,
                                                    baseMatrix: matrix))
    }

    func testSquareMatrixWithSizeNonPowerOfTwo_init_throwException() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])

        // Then
        XCTAssertThrowsError(try QuantumGateFactory(qubitCount: validQubitCount,
                                                    baseMatrix: matrix))
    }

    func testSquareMatrixWithSizePowerOfTwoButBiggerThanQubitCount_init_throwException() {
        // Given
        let qubitCount = 1

        // Then
        XCTAssertThrowsError(try QuantumGateFactory(qubitCount: qubitCount,
                                                    baseMatrix: validMatrix))
    }

    func testOneByOneMatrixAndQubitCountEqualToZero_init_throwException() {
        // Given
        let matrix = try! Matrix([[Complex(0)]])
        let qubitCount = 0

        // Then
        XCTAssertThrowsError(try QuantumGateFactory(qubitCount: qubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizePowerOfTwoAndSmallerThanQubitCount_init_returnGateFactory() {
        // Then
        XCTAssertNoThrow(try QuantumGateFactory(qubitCount: validQubitCount,
                                                baseMatrix: validMatrix))
    }

    func testAnyGateFactoryAndRepeatedInputs_makeGate_throwException() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)

        // Then
        XCTAssertThrowsError(try factory.makeGate(inputs: [1, 1]))
    }

    func testAnyGateFactoryAndInputsOutOfRange_makeGate_throwException() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)

        // Then
        XCTAssertThrowsError(try factory.makeGate(inputs: [validQubitCount]))
    }

    func testAnyGateFactoryAndMoreInputsThanGateTakes_makeGate_throwException() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)

        // Then
        XCTAssertThrowsError(try factory.makeGate(inputs: [2, 1, 0]))
    }

    func testAnyGateFactoryAndLessInputsThanGateTakes_makeGate_throwException() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)

        // Then
        XCTAssertThrowsError(try factory.makeGate(inputs: []))
    }

    func testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeGate_returnExpectedGate() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: 2, baseMatrix: validMatrix)

        // When
        let gate = try? factory.makeGate(inputs: [1, 0])

        // Then
        let expectedGate = try! QuantumGate(matrix: validMatrix)
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeGate_returnExpectedGate() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: 2, baseMatrix: validMatrix)

        // When
        let gate = try? factory.makeGate(inputs: [0, 1])

        // Then
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0)]
        ]
        let expectedGate = try! QuantumGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyGateFactoryAndNonContiguousInputs_makeGate_returnExpectedGate() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)

        // When
        let gate = try? factory.makeGate(inputs: [0, 2])

        // Then
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0)]
        ]
        let expectedGate = try! QuantumGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyGateFactoryAndContiguousInputsButInTheMiddle_makeGate_returnExpectedGate() {
        // Given
        let factory = try! QuantumGateFactory(qubitCount: 4, baseMatrix: validMatrix)

        // When
        let gate = try? factory.makeGate(inputs: [2, 1])

        // Then
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(0),
             Complex(0), Complex(0), Complex(0), Complex(0), Complex(0), Complex(1), Complex(0), Complex(0)]]
        let expectedGate = try! QuantumGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }

    static var allTests = [
        ("testNonSquareMatrix_init_throwException",
         testNonSquareMatrix_init_throwException),
        ("testSquareMatrixWithSizeNonPowerOfTwo_init_throwException",
         testSquareMatrixWithSizeNonPowerOfTwo_init_throwException),
        ("testSquareMatrixWithSizePowerOfTwoButBiggerThanQubitCount_init_throwException",
         testSquareMatrixWithSizePowerOfTwoButBiggerThanQubitCount_init_throwException),
        ("testOneByOneMatrixAndQubitCountEqualToZero_init_throwException",
         testOneByOneMatrixAndQubitCountEqualToZero_init_throwException),
        ("testSquareMatrixWithSizePowerOfTwoAndSmallerThanQubitCount_init_returnGateFactory",
         testSquareMatrixWithSizePowerOfTwoAndSmallerThanQubitCount_init_returnGateFactory),
        ("testAnyGateFactoryAndRepeatedInputs_makeGate_throwException",
         testAnyGateFactoryAndRepeatedInputs_makeGate_throwException),
        ("testAnyGateFactoryAndInputsOutOfRange_makeGate_throwException",
         testAnyGateFactoryAndInputsOutOfRange_makeGate_throwException),
        ("testAnyGateFactoryAndMoreInputsThanGateTakes_makeGate_throwException",
         testAnyGateFactoryAndMoreInputsThanGateTakes_makeGate_throwException),
        ("testAnyGateFactoryAndLessInputsThanGateTakes_makeGate_throwException",
         testAnyGateFactoryAndLessInputsThanGateTakes_makeGate_throwException),
        ("testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeGate_returnExpectedGate",
         testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeGate_returnExpectedGate),
        ("testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeGate_returnExpectedGate",
         testAnyGateFactoryWithSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeGate_returnExpectedGate),
        ("testAnyGateFactoryAndNonContiguousInputs_makeGate_returnExpectedGate",
         testAnyGateFactoryAndNonContiguousInputs_makeGate_returnExpectedGate),
        ("testAnyGateFactoryAndContiguousInputsButInTheMiddle_makeGate_returnExpectedGate",
         testAnyGateFactoryAndContiguousInputsButInTheMiddle_makeGate_returnExpectedGate)
    ]
}
