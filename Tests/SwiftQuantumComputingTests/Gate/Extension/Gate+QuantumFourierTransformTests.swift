//
//  Gate+QuantumFourierTransformTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/03/2020.
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

class Gate_QuantumFourierTransformTests: XCTestCase {

    // MARK: - Tests

    func testEmptyInputs_makeQuantumFourierTransform_throwError() {
        // Then
        var error: Gate.MakeQuantumFourierTransformError?
        if case .failure(let e) = Gate.makeQuantumFourierTransform(inputs: []) {
            error = e
        }
        XCTAssertEqual(error, .inputsCanNotBeAnEmptyList)
    }

    func testTwoInputs_makeQuantumFourierTransform_returnExpectedGate() {
        // Given
        let inputs = [0, 1]

        // When
        let gate = try? Gate.makeQuantumFourierTransform(inputs: inputs).get()

        // Then
        let val = 1.0 / 2.0
        let expectedMatrix = try! Matrix([
            [Complex(val), Complex(val), Complex(val), Complex(val)],
            [Complex(val), Complex(real: 0, imag: val), Complex(-val), Complex(real: 0, imag: -val)],
            [Complex(val), Complex(-val), Complex(val), Complex(-val)],
            [Complex(val), Complex(real: 0, imag: -val), Complex(-val), Complex(real: 0, imag: val)]
        ])

        if case .matrix(let gateMatrix, let gateInputs) = gate {
            XCTAssertTrue(gateMatrix.isEqual(expectedMatrix, accuracy: 0.00001))
            XCTAssertEqual(gateInputs, inputs)
        } else {
            XCTAssert(false)
        }
    }

    func testTwoInputs_makeInverseQuantumFourierTransform_returnExpectedGate() {
        // Given
        let inputs = [0, 1]

        // When
        let gate = try? Gate.makeQuantumFourierTransform(inputs: inputs, inverse: true).get()

        // Then
        let val = 1.0 / 2.0
        let expectedMatrix = try! Matrix([
            [Complex(val), Complex(val), Complex(val), Complex(val)],
            [Complex(val), Complex(real: 0, imag: -val), Complex(-val), Complex(real: 0, imag: val)],
            [Complex(val), Complex(-val), Complex(val), Complex(-val)],
            [Complex(val), Complex(real: 0, imag: val), Complex(-val), Complex(real: 0, imag: -val)]
        ])

        if case .matrix(let gateMatrix, let gateInputs) = gate {
            XCTAssertTrue(gateMatrix.isEqual(expectedMatrix, accuracy: 0.00001))
            XCTAssertEqual(gateInputs, inputs)
        } else {
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testEmptyInputs_makeQuantumFourierTransform_throwError",
         testEmptyInputs_makeQuantumFourierTransform_throwError),
        ("testTwoInputs_makeQuantumFourierTransform_returnExpectedGate",
         testTwoInputs_makeQuantumFourierTransform_returnExpectedGate),
        ("testTwoInputs_makeInverseQuantumFourierTransform_returnExpectedGate",
         testTwoInputs_makeInverseQuantumFourierTransform_returnExpectedGate)
    ]
}
