//
//  GateFactoryTests.swift
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

class GateFactoryTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = Matrix([[Complex(1), Complex(0), Complex(0), Complex(0)],
                              [Complex(0), Complex(1), Complex(0), Complex(0)],
                              [Complex(0), Complex(0), Complex(0), Complex(1)],
                              [Complex(0), Complex(0), Complex(1), Complex(0)]])!

    // MARK: - Tests

    func testNonSquareMatrix_init_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = Matrix([[complex], [complex]])!

        // Then
        XCTAssertNil(GateFactory(qubitCount: validQubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizeNonPowerOfTwo_init_returnNil() {
        // Given
        let complex = Complex(real: 0, imag: 0)
        let matrix = Matrix([[complex, complex, complex],
                             [complex, complex, complex],
                             [complex, complex, complex]])!

        // Then
        XCTAssertNil(GateFactory(qubitCount: validQubitCount, baseMatrix: matrix))
    }

    func testSquareMatrixWithSizePowerOfTwoButBiggerThanQubitCount_init_returnNil() {
        // Given
        let qubitCount = 1

        // Then
        XCTAssertNil(GateFactory(qubitCount: qubitCount, baseMatrix: validMatrix))
    }

    func testSquareMatrixWithSizePowerOfTwoAndSmallerThanQubitCount_init_returnFactory() {
        // Then
        XCTAssertNotNil(GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix))
    }

    func testAnyFactoryAndRepeatedInputs_makeGate_returnNil() {
        // Given
        let factory = GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: 1, 1))
    }

    func testAnyFactoryAndInputsOutOfRange_makeGate_returnNil() {
        // Given
        let factory = GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: validQubitCount))
    }

    func testAnyFactoryAndMoreInputsThanGateTakes_makeGate_returnNil() {
        // Given
        let factory = GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: 2, 1, 0))
    }

    func testAnyFactoryAndLessInputsThanGateTakes_makeGate_returnNil() {
        // Given
        let factory = GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // Then
        XCTAssertNil(factory.makeGate(inputs: 0))
    }

    func testAnyFactoryWithSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_makeGate_returnExpectedGate() {
        // Given
        let factory = GateFactory(qubitCount: 2, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: 1, 0)

        // Then
        let expectedGate = Gate(matrix: validMatrix)!
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyFactoryWithSameQubitCountThatBaseMatrixAndInputsInReverseOrder_makeGate__returnExpectedGate() {
        // Given
        let factory = GateFactory(qubitCount: 2, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: 0, 1)

        // Then
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0), Complex(0)],
            [Complex(0), Complex(0), Complex(0), Complex(1)],
            [Complex(0), Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(1), Complex(0), Complex(0)]
        ]
        let expectedGate = Gate(matrix: Matrix(expectedElements)!)!
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyFactoryAndNonContiguousInputs_makeGate_returnExpectedGate() {
        // Given
        let factory = GateFactory(qubitCount: validQubitCount, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: 0, 2)

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
        let expectedGate = Gate(matrix: Matrix(expectedElements)!)!
        XCTAssertEqual(gate, expectedGate)
    }

    func testAnyFactoryAndContiguousInputsButInTheMiddle_makeGate_returnExpectedGate() {
        // Given
        let factory = GateFactory(qubitCount: 4, baseMatrix: validMatrix)!

        // When
        let gate = factory.makeGate(inputs: 2, 1)

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
        let expectedGate = Gate(matrix: Matrix(expectedElements)!)!
        XCTAssertEqual(gate, expectedGate)
    }
}
