//
//  RegisterGateFactoryTests.swift
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

class RegisterGateFactoryTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = try! Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                                   [Complex(0), Complex(1), Complex(0), Complex(0)],
                                   [Complex(0), Complex(0), Complex(0), Complex(1)],
                                   [Complex(0), Complex(0), Complex(1), Complex(0)]])

    // MARK: - Tests

    func testNonSquareMatrix_init_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex], [complex]])

        // Then
        XCTAssertNil(RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizeNonPowerOfTwo_init_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = try! Matrix([[complex, complex, complex],
                                  [complex, complex, complex],
                                  [complex, complex, complex]])

        // Then
        XCTAssertNil(RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizePowerOfTwoButBiggerThanQubitCount_init_returnNil() {
        // Given
        let qubitCount = 1

        // Then
        XCTAssertNil(RegisterGateFactory(qubitCount: qubitCount, baseMatrix: validMatrix))
    }

    func testOneByOneMatrixAndQubitCountEqualToZero_init_returnNil() {
        // Given
        let matrix = try! Matrix([[Complex(0)]])
        let qubitCount = 0

        // Then
        XCTAssertNil(RegisterGateFactory(qubitCount: qubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizePowerOfTwoAndSmallerThanQubitCount_init_returnRegisterGateFactory() {
        // Then
        XCTAssertNotNil(RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix))
    }

    func testAnyRegisterGateFactoryAndRepeatedInputs_makeGate_returnNil() {
        // Given
        let factory = RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: [1, 1]))
    }

    func testAnyRegisterGateFactoryAndInputsOutOfRange_makeGate_returnNil() {
        // Given
        let factory = RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: [validQubitCount]))
    }

    func testAnyRegisterGateFactoryAndMoreInputsThanGateTakes_makeGate_returnNil() {
        // Given
        let factory = RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: [2, 1, 0]))
    }

    func testAnyRegisterGateFactoryAndLessInputsThanGateTakes_makeGate_returnNil() {
        // Given
        let factory = RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: []))
    }

    func testAnyRegisterGateFactoryWithSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeGate_returnExpectedRegisterGate() {
        // Given
        let factory = RegisterGateFactory(qubitCount: 2, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: [1, 0])

        // Then
        let expectedGate = try! RegisterGate(matrix: validMatrix)
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyRegisterGateFactoryWithSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeGate_returnExpectedRegisterGate() {
        // Given
        let factory = RegisterGateFactory(qubitCount: 2, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: [0, 1])

        // Then
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0)]
        ]
        let expectedGate = try! RegisterGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyRegisterGateFactoryAndNonContiguousInputs_makeGate_returnExpectedRegisterGate() {
        // Given
        let factory = RegisterGateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: [0, 2])

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
        let expectedGate = try! RegisterGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyRegisterGateFactoryAndContiguousInputsButInTheMiddle_makeGate_returnExpectedRegisterGate() {
        // Given
        let factory = RegisterGateFactory(qubitCount: 4, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: [2, 1])

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
        let expectedGate = try! RegisterGate(matrix: try! Matrix(expectedElements))
        XCTAssertEqual(gate, expectedGate)
    }
}
