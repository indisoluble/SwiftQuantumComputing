//
//  SimulatorCircuitMatrixTests.swift
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

class SimulatorCircuitMatrixTests: XCTestCase {

    // MARK: - Properties
    let twoQubitCount = 2
    let validInputs = [1, 0]
    let validMatrix = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero],
        [.zero, .zero, .zero, .one],
        [.zero, .zero, .one, .zero]
    ])
    let validMatrixWithReversedValidInputs = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .zero, .zero, .one],
        [.zero, .zero, .one, .zero],
        [.zero, .one, .zero, .zero]
    ])

    let oneQubitCount = 1
    let otherValidInputs = [0]
    let otherValidMatrix = try! Matrix([[.zero, .one], [.one, .zero]])

    let threeQubitCount = 3
    let nonContiguousInputs = [0, 2]
    let expectedThreeQubitMatrix = try! Matrix([
        [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
        [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
        [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero]
    ])

    let fourQubitCount = 4
    let contiguousInputsButInTheMiddle = [2, 1]
    let expectedFourQubitMatrix = try! Matrix([
        [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
         .zero, .zero, .zero, .zero, .zero, .one, .zero, .zero]
    ])

    // MARK: - Tests

    func testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: twoQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: validInputs)

        // Then
        XCTAssertEqual(sut.rawMatrix, validMatrix)
    }

    func testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: oneQubitCount,
                                         baseMatrix: otherValidMatrix,
                                         inputs: otherValidInputs)

        // Then
        XCTAssertEqual(sut.rawMatrix, otherValidMatrix)
    }

    func testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: twoQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: validInputs.reversed())

        // Then
        XCTAssertEqual(sut.rawMatrix, validMatrixWithReversedValidInputs)
    }

    func testNonContiguousInputs_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        XCTAssertEqual(sut.rawMatrix, expectedThreeQubitMatrix)
    }

    func testNonContiguousInputs_subscriptRow_returnExpectedValues() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        for row in 0..<expectedThreeQubitMatrix.rowCount {
            let vector = sut[row]

            for column in 0..<expectedThreeQubitMatrix.columnCount {
                XCTAssertEqual(vector[column], expectedThreeQubitMatrix[row, column])
            }
        }
    }

    func testNonContiguousInputs_subscriptRowColumn_returnExpectedValues() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        for row in 0..<expectedThreeQubitMatrix.rowCount {
            for column in 0..<expectedThreeQubitMatrix.columnCount {
                XCTAssertEqual(sut[row, column], expectedThreeQubitMatrix[row, column])
            }
        }
    }

    func testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: fourQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: contiguousInputsButInTheMiddle)

        // Then
        XCTAssertEqual(sut.rawMatrix, expectedFourQubitMatrix)
    }

    func testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: fourQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: contiguousInputsButInTheMiddle)

        // Then
        for row in 0..<expectedFourQubitMatrix.rowCount {
            let vector = sut[row]

            for column in 0..<expectedFourQubitMatrix.columnCount {
                XCTAssertEqual(vector[column], expectedFourQubitMatrix[row, column])
            }
        }
    }

    func testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix() {
        // When
        let sut = SimulatorCircuitMatrix(qubitCount: fourQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: contiguousInputsButInTheMiddle)

        // Then
        for row in 0..<expectedFourQubitMatrix.rowCount {
            for column in 0..<expectedFourQubitMatrix.columnCount {
                XCTAssertEqual(sut[row, column], expectedFourQubitMatrix[row, column])
            }
        }
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
        ("testNonContiguousInputs_subscriptRow_returnExpectedValues",
         testNonContiguousInputs_subscriptRow_returnExpectedValues),
        ("testNonContiguousInputs_subscriptRowColumn_returnExpectedValues",
         testNonContiguousInputs_subscriptRowColumn_returnExpectedValues),
        ("testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_rawMatrix_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix)
    ]
}
