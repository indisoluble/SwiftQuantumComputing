//
//  CircuitSimulatorMatrixTests.swift
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

class CircuitSimulatorMatrixTests: XCTestCase {

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

    func testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: twoQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: validInputs)

        // Then
        var error: ExpandedRawMatrixError?
        if case .failure(let e) = sut.expandedRawMatrix(maxConcurrency: 0) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: twoQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: validInputs)

        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(), validMatrix)
    }

    func testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: oneQubitCount,
                                         baseMatrix: otherValidMatrix,
                                         inputs: otherValidInputs)

        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(), otherValidMatrix)
    }

    func testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_expandedRawMatrix_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: twoQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: validInputs.reversed())

        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(),
                       validMatrixWithReversedValidInputs)
    }

    func testNonContiguousInputs_expandedRawMatrix_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(),
                       expectedThreeQubitMatrix)
    }

    func testNonContiguousInputs_subscriptRow_returnExpectedValues() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        for row in 0..<expectedThreeQubitMatrix.rowCount {
            let vector = try! sut.row(row, maxConcurrency: 1).get()

            for column in 0..<expectedThreeQubitMatrix.columnCount {
                XCTAssertEqual(vector[column], expectedThreeQubitMatrix[row, column])
            }
        }
    }

    func testNonContiguousInputs_subscriptRowColumn_returnExpectedValues() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: threeQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: nonContiguousInputs)

        // Then
        for row in 0..<expectedThreeQubitMatrix.rowCount {
            for column in 0..<expectedThreeQubitMatrix.columnCount {
                XCTAssertEqual(sut[row, column], expectedThreeQubitMatrix[row, column])
            }
        }
    }

    func testContiguousInputsButInTheMiddle_expandedRawMatrix_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: fourQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: contiguousInputsButInTheMiddle)

        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(), expectedFourQubitMatrix)
    }

    func testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: fourQubitCount,
                                         baseMatrix: validMatrix,
                                         inputs: contiguousInputsButInTheMiddle)

        // Then
        for row in 0..<expectedFourQubitMatrix.rowCount {
            let vector = try! sut.row(row, maxConcurrency: 1).get()

            for column in 0..<expectedFourQubitMatrix.columnCount {
                XCTAssertEqual(vector[column], expectedFourQubitMatrix[row, column])
            }
        }
    }

    func testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix() {
        // When
        let sut = CircuitSimulatorMatrix(qubitCount: fourQubitCount,
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
        ("testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException",
         testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException),
        ("testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix",
         testSameQubitCountThatOtherBaseMatrixAndSingleInputAsExpectedByBaseMatrix_expandedRawMatrix_returnExpectedMatrix),
        ("testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_expandedRawMatrix_returnExpectedMatrix",
         testSameQubitCountThatBaseMatrixAndInputsInReverseOrder_expandedRawMatrix_returnExpectedMatrix),
        ("testNonContiguousInputs_expandedRawMatrix_returnExpectedMatrix",
         testNonContiguousInputs_expandedRawMatrix_returnExpectedMatrix),
        ("testNonContiguousInputs_subscriptRow_returnExpectedValues",
         testNonContiguousInputs_subscriptRow_returnExpectedValues),
        ("testNonContiguousInputs_subscriptRowColumn_returnExpectedValues",
         testNonContiguousInputs_subscriptRowColumn_returnExpectedValues),
        ("testContiguousInputsButInTheMiddle_expandedRawMatrix_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_expandedRawMatrix_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_subscriptRow_returnExpectedMatrix),
        ("testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix",
         testContiguousInputsButInTheMiddle_subscriptRowColumn_returnExpectedMatrix)
    ]
}
