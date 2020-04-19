//
//  SimulatorGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/04/2020.
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

class SimulatorGateTests: XCTestCase {

    // MARK: - Properties

    let validQubitCount = 3
    let validMatrix = try! Matrix([[Complex.one, Complex.zero, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.one, Complex.zero, Complex.zero],
                                   [Complex.zero, Complex.zero, Complex.zero, Complex.one],
                                   [Complex.zero, Complex.zero, Complex.one, Complex.zero]])
    let validInputs = [1, 0]

    // MARK: - Tests

    func testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException() {
        // Given
        let qubitCount = 0
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: qubitCount))
    }

    func testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException() {
        // Given
        let qubitCount = 1
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: qubitCount))
    }

    func testInputsOutOfRange_makeCircuitMatrix_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, validQubitCount])

        // Then
        XCTAssertThrowsError(try gate.extract(restrictedToCircuitQubitCount: validQubitCount))
    }

    static var allTests = [
        ("testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException",
         testUnitaryMatrixAndQubitCountEqualToZero_makeCircuitMatrix_throwException),
        ("testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException",
         testUnitaryMatrixWithSizePowerOfTwoButBiggerThanQubitCount_makeCircuitMatrix_throwException),
        ("testInputsOutOfRange_makeCircuitMatrix_throwException",
         testInputsOutOfRange_makeCircuitMatrix_throwException)
    ]
}
