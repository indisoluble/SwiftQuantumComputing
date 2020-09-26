//
//  Matrix+PermutationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/09/2020.
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

class Matrix_PermutationTests: XCTestCase {

    // MARK: - Tests

    func testEmptyList_makePermutation_throwError() {
        // Then
        var error: Matrix.MakePermutationError?
        if case .failure(let e) = Matrix.makePermutation(permutation: []) {
            error = e
        }
        XCTAssertEqual(error, .doNotPassAnEmptyPermutation)
    }

    func testRepeatedIndexes_makePermutation_throwError() {
        // Then
        var error: Matrix.MakePermutationError?
        if case .failure(let e) = Matrix.makePermutation(permutation: [0, 1, 1]) {
            error = e
        }
        XCTAssertEqual(error, .doNotRepeatIndexesInPermutation)
    }

    func testNegativeIndexes_makePermutation_throwError() {
        // Then
        var error: Matrix.MakePermutationError?
        if case .failure(let e) = Matrix.makePermutation(permutation: [0, 1, -2]) {
            error = e
        }
        XCTAssertEqual(error, .doNotUseNegativeIndexesInPermutation)
    }

    func testValidIndexes_makePermutation_returnExpectedMatrix() {
        // When
        let result = try! Matrix.makePermutation(permutation: [0, 3, 1, 4, 2]).get()

        // Then
        let expectedResult = try! Matrix([
            [.one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero],
            [.zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one],
            [.zero, .zero, .one, .zero, .zero]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testEmptyList_makePermutation_throwError",
         testEmptyList_makePermutation_throwError),
        ("testRepeatedIndexes_makePermutation_throwError",
         testRepeatedIndexes_makePermutation_throwError),
        ("testNegativeIndexes_makePermutation_throwError",
         testNegativeIndexes_makePermutation_throwError),
        ("testValidIndexes_makePermutation_returnExpectedMatrix",
         testValidIndexes_makePermutation_returnExpectedMatrix)
    ]
}
