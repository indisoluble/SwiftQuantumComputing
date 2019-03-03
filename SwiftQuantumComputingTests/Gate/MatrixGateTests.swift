//
//  MatrixGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 21/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class MatrixGateTests: XCTestCase {

    // MARK: - Properties

    let matrix = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                         [Complex(1), Complex(0), Complex(0), Complex(0)],
                         [Complex(0), Complex(0), Complex(1), Complex(0)],
                         [Complex(0), Complex(0), Complex(0), Complex(1)]])!
    let oneRow = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)]])!

    // MARK: - Tests

    func testFactoryWithTwoQubitsMatrixAndOneInput_makeFixed_returnNil() {
        // Given
        let factory = MatrixGate(matrix: matrix)

        // Then
        XCTAssertNil(factory.makeFixed(inputs: [0]))
    }

    func testFactoryWithTwoQubitsMatrixAndFourInputs_makeFixed_returnExpectedGate() {
        // Given
        let factory = MatrixGate(matrix: matrix)
        let inputs = [0, 1, 2, 3]

        // When
        guard let result = factory.makeFixed(inputs: inputs) else {
            XCTAssert(false)

            return
        }

        // Then
        switch result {
        case let .matrix(matrixMatrix, matrixInputs):
            XCTAssertEqual(matrixMatrix, matrix)
            XCTAssertEqual(matrixInputs, Array(inputs[0..<2]))
        default:
            XCTAssert(false)
        }
    }

    func testMatrixWithOneRow_init_returnGate() {
        // Then
        XCTAssertNotNil(MatrixGate(matrix: oneRow))
    }

    func testFactoryWithOneRowMatrix_makeFixed_returnNil() {
        // Given
        let factory = MatrixGate(matrix: oneRow)
        let inputs: [Int] = []

        // Then
        XCTAssertNil(factory.makeFixed(inputs: inputs))
    }
}
