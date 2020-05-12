//
//  SimulatorCircuitMatrixAdapterTests.swift
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

class SimulatorCircuitMatrixAdapterTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = try! Matrix([[Complex.one, Complex.zero, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.one, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.zero, Complex.zero, Complex.one],
                                   [Complex.zero, Complex.zero, Complex.one, Complex.zero]])
    let validInputs = [1, 0]
    let otherValidMatrix = try! Matrix([[Complex.zero, Complex.one], [Complex.one, Complex.zero]])
    let otherValidInputs = [0]

    // MARK: - Tests

    func testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrixAdapter(qubitCount: 2,
                                                baseMatrix: validMatrix,
                                                inputs: validInputs)

        // Then
        XCTAssertEqual(sut.rawMatrix, validMatrix)
    }

    func testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrixAdapter(qubitCount: 1,
                                                baseMatrix: otherValidMatrix,
                                                inputs: otherValidInputs)

        // Then
        XCTAssertEqual(sut.rawMatrix, otherValidMatrix)
    }

    func testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrixAdapter(qubitCount: 2,
                                                baseMatrix: validMatrix,
                                                inputs: validInputs.reversed())

        // Then
        let expectedElements = [
            [Complex.one, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one],
            [Complex.zero, Complex.zero, Complex.one, Complex.zero],
            [Complex.zero, Complex.one, Complex.zero, Complex.zero]
        ]
        XCTAssertEqual(sut.rawMatrix, try? Matrix(expectedElements))
    }

    func testNonContiguousInputs_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrixAdapter(qubitCount: validQubitCount,
                                                baseMatrix: validMatrix,
                                                inputs: [0, 2])

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
        XCTAssertEqual(sut.rawMatrix, try? Matrix(expectedElements))
    }

    func testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrixAdapter(qubitCount: 4,
                                                baseMatrix: validMatrix,
                                                inputs: [2, 1])

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
        XCTAssertEqual(sut.rawMatrix, try? Matrix(expectedElements))
    }

    static var allTests = [
        ("testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix",
         testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_rawMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_rawMatrix_returnExpectedMatrix),
        ("testNonContiguousInputs_rawMatrix_returnExpectedMatrix",
         testNonContiguousInputs_rawMatrix_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix)
    ]
}
