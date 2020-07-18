//
//  ControlledMatrixGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 07/03/2020.
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

class ControlledMatrixGateTests: XCTestCase {

    // MARK: - Properties

    let matrix = try! Matrix([[.zero, .one, .zero, .zero],
                              [.one, .zero, .zero, .zero],
                              [.zero, .zero, .one, .zero],
                              [.zero, .zero, .zero, .one]])
    let oneRow = try! Matrix([[.zero, .one, .zero, .zero]])

    // MARK: - Tests

    func testMatrixWithOneRow_init_throwException() {
        // Then
        XCTAssertThrowsError(try ControlledMatrixGate(matrix: oneRow))
    }

    func testEmptyInputs_makeFixed_throwException() {
        // Given
        let factory = try! ControlledMatrixGate(matrix: matrix)

        // Then
        switch factory.makeFixed(inputs: []) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testFactoryWithTwoQubitsMatrixAndFourInputs_makeFixed_returnExpectedGate() {
        // Given
        let factory = try! ControlledMatrixGate(matrix: matrix)
        let inputs = [0, 1, 2, 3]

        // Then
        switch factory.makeFixed(inputs: inputs) {
        case .success(.controlledMatrix(let matrixMatrix, let matrixInputs, let matrixControl)):
            XCTAssertEqual(matrixMatrix, matrix)
            XCTAssertEqual(matrixInputs, Array(inputs[0..<2]))
            XCTAssertEqual(matrixControl, 2)
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testMatrixWithOneRow_init_throwException",
         testMatrixWithOneRow_init_throwException),
        ("testEmptyInputs_makeFixed_throwException",
         testEmptyInputs_makeFixed_throwException),
        ("testFactoryWithTwoQubitsMatrixAndFourInputs_makeFixed_returnExpectedGate",
         testFactoryWithTwoQubitsMatrixAndFourInputs_makeFixed_returnExpectedGate)
    ]
}
