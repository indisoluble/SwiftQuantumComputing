//
//  Matrix+SimulatorMatrixTests.swift
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

class Matrix_SimulatorMatrixTests: XCTestCase {

    // MARK: - Properties

    let sut = Matrix.makeControlledNot()

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException() {
        // Then
        var error: ExpandedRawMatrixError?
        if case .failure(let e) = sut.expandedRawMatrix(maxConcurrency: 0) {
            error = e
        }
        XCTAssertEqual(error, .passMaxConcurrencyBiggerThanZero)
    }

    func testValidMaxConcurrency_expandedRawMatrix_returnSameMatrix() {
        // Then
        XCTAssertEqual(try? sut.expandedRawMatrix(maxConcurrency: 1).get(), sut)
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException",
         testMaxConcurrencyEqualToZero_expandedRawMatrix_throwException),
        ("testValidMaxConcurrency_expandedRawMatrix_returnSameMatrix",
         testValidMaxConcurrency_expandedRawMatrix_returnSameMatrix)
    ]
}
