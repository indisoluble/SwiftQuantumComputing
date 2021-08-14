//
//  CircuitSimulatorMatrix+RowTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/06/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class CircuitSimulatorMatrix_RowTests: XCTestCase {

    // MARK: - Properties

    let sut = CircuitSimulatorMatrix(qubitCount: 2,
                                     baseMatrix: Matrix.makeControlledNot(),
                                     inputs: [1, 0])

    // MARK: - Tests

    func testIndexLessThanZero_row_throwException() {
        // Then
        var error: CircuitSimulatorMatrix.RowError?
        if case .failure(let e) = sut.row(-1, maxConcurrency: 1) {
            error = e
        }
        XCTAssertEqual(error, .indexOutOfRange)
    }

    func testIndexBeyondLimit_row_throwException() {
        // Then
        var error: CircuitSimulatorMatrix.RowError?
        if case .failure(let e) = sut.row(sut.count, maxConcurrency: 1) {
            error = e
        }
        XCTAssertEqual(error, .indexOutOfRange)
    }

    func testMaxConcurrencyEqualToZero_row_throwException() {
        // Then
        var error: CircuitSimulatorMatrix.RowError?
        if case .failure(let e) = sut.row(0, maxConcurrency: 0) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testValidParameters_row_returnExpectedVector() {
        // When
        let row = try? sut.row(0, maxConcurrency: 1).get()

        // Then
        let expectedResult = try! Vector([1, 0, 0, 0])
        XCTAssertEqual(row, expectedResult)
    }

    func testOtherValidParameters_row_returnExpectedVector() {
        // When
        let row = try? sut.row(3, maxConcurrency: 2).get()

        // Then
        let expectedResult = try! Vector([0, 0, 1, 0])
        XCTAssertEqual(row, expectedResult)
    }

    func testOtherValidParametersAndTransform_row_returnExpectedVector() {
        // When
        let row = try? sut.row(3, maxConcurrency: 2, transform: { $0 + .i }).get()

        // Then
        let expectedResult = try! Vector([.i, .i, .one + .i, .i])
        XCTAssertEqual(row, expectedResult)
    }

    static var allTests = [
        ("testIndexLessThanZero_row_throwException",
         testIndexLessThanZero_row_throwException),
        ("testIndexBeyondLimit_row_throwException",
         testIndexBeyondLimit_row_throwException),
        ("testMaxConcurrencyEqualToZero_row_throwException",
         testMaxConcurrencyEqualToZero_row_throwException),
        ("testValidParameters_row_returnExpectedVector",
         testValidParameters_row_returnExpectedVector),
        ("testOtherValidParameters_row_returnExpectedVector",
         testOtherValidParameters_row_returnExpectedVector),
        ("testOtherValidParametersAndTransform_row_returnExpectedVector",
         testOtherValidParametersAndTransform_row_returnExpectedVector)
    ]
}
