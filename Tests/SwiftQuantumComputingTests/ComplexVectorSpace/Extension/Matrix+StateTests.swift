//
//  Matrix+StateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/08/2021.
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

class Matrix_StateTests: XCTestCase {

    // MARK: - Tests

    func testQubitCountEqualToZero_makeState_throwException() {
        // Then
        var error: Matrix.MakeStateError?
        if case .failure(let e) = Matrix.makeState(value: 1, qubitCount: 0) {
            error = e
        }
        XCTAssertEqual(error, .qubitCountHasToBeBiggerThanZero)
    }

    func testValueOutOfRange_makeState_throwException() {
        // Then
        var error: Matrix.MakeStateError?
        if case .failure(let e) = Matrix.makeState(value: 10, qubitCount: 2) {
            error = e
        }
        XCTAssertEqual(error, .valueHasToBeContainedInQubits)
    }

    func testValidValueAndQubitCount_makeState_returnExpectedMatrix() {
        // When
        let result = try? Matrix.makeState(value: 3, qubitCount: 3).get()

        // Then
        let expectedResult = try! Matrix([
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
        ])
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testQubitCountEqualToZero_makeState_throwException",
         testQubitCountEqualToZero_makeState_throwException),
        ("testValueOutOfRange_makeState_throwException",
         testValueOutOfRange_makeState_throwException),
        ("testValidValueAndQubitCount_makeState_returnExpectedMatrix",
         testValidValueAndQubitCount_makeState_returnExpectedMatrix)
    ]
}
