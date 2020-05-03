//
//  DirectStatevectorTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/04/2020.
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

class DirectStatevectorTransformationTests: XCTestCase {

    // MARK: - Properties

    let factory = StatevectorRegisterFactoryTestDouble()
    let transformation = StatevectorRegisterTestDouble()
    let threeQubitZeroVector = try! Vector([
        Complex.one, Complex.zero, Complex.zero, Complex.zero,
        Complex.zero, Complex.zero, Complex.zero, Complex.zero
    ])
    let threeQubitFourVector = try! Vector([
        Complex.zero, Complex.zero, Complex.zero, Complex.zero,
        Complex.one, Complex.zero, Complex.zero, Complex.zero
    ])
    let threeQubitFiveVector = try! Vector([
        Complex.zero, Complex.zero, Complex.zero, Complex.zero,
        Complex.zero, Complex.one, Complex.zero, Complex.zero
    ])
    let oneQubitZeroVector = try! Vector([Complex.one, Complex.zero])
    let oneQubitOneVector = try! Vector([Complex.zero, Complex.one])

    // MARK: - Tests

    func testFactoryThatThrowsException_init_throwException() {
        // Given
        factory.makeTransformationResult = nil
        factory.makeTransformationError = MakeTransformationError.stateCountHasToBeAPowerOfTwo

        // Then
        XCTAssertThrowsError(try DirectStatevectorTransformation(vector: oneQubitZeroVector,
                                                                 factory: factory))
        XCTAssertEqual(factory.makeTransformationCount, 1)
    }

    func testThreeQubitMatrix_applying_forwardToTransformation() {
        // Given
        factory.makeTransformationResult = transformation
        let adapter = try! DirectStatevectorTransformation(vector: threeQubitZeroVector,
                                                           factory: factory)

        let gateInputs = [2, 1, 0]
        let gateMatrix = try! Matrix.makeOracle(truthTable: ["00"], controlCount: 2)

        transformation.statevectorApplyingResult = threeQubitFourVector

        // When
        let result = adapter.applying(gateMatrix: gateMatrix, toInputs: gateInputs)

        // Then
        XCTAssertEqual(transformation.statevectorApplyingCount, 1)
        XCTAssertEqual(transformation.lastStatevectorApplyingMatrix, gateMatrix)
        XCTAssertEqual(transformation.lastStatevectorApplyingInputs, gateInputs)
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testNotMatrixAndOneQubitVector_applying_returnExpectedVector() {
        // Given
        factory.makeTransformationResult = transformation
        let adapter = try! DirectStatevectorTransformation(vector: oneQubitZeroVector,
                                                           factory: factory)

        // When
        let result = adapter.applying(gateMatrix: Matrix.makeNot(), toInputs: [0])

        // Then
        XCTAssertEqual(result, oneQubitOneVector)
    }

    func testNotMatrixAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        factory.makeTransformationResult = transformation
        let adapter = try! DirectStatevectorTransformation(vector: threeQubitZeroVector,
                                                           factory: factory)

        // When
        let result = adapter.applying(gateMatrix: Matrix.makeNot(), toInputs: [2])

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testTwoNotMatricesAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        factory.makeTransformationResult = transformation
        var adapter = try! DirectStatevectorTransformation(vector: threeQubitZeroVector,
                                                           factory: factory)

        // When
        var result = adapter.applying(gateMatrix: Matrix.makeNot(), toInputs: [2])
        adapter = try! DirectStatevectorTransformation(vector: result,
                                                       factory: factory)
        result = adapter.applying(gateMatrix: Matrix.makeNot(), toInputs: [0])

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    static var allTests = [
        ("testFactoryThatThrowsException_init_throwException",
         testFactoryThatThrowsException_init_throwException),
        ("testThreeQubitMatrix_applying_forwardToTransformation",
         testThreeQubitMatrix_applying_forwardToTransformation),
        ("testNotMatrixAndOneQubitVector_applying_returnExpectedVector",
         testNotMatrixAndOneQubitVector_applying_returnExpectedVector),
        ("testNotMatrixAndThreeQubitVector_applying_returnExpectedVector",
         testNotMatrixAndThreeQubitVector_applying_returnExpectedVector),
        ("testTwoNotMatricesAndThreeQubitVector_applying_returnExpectedVector",
         testTwoNotMatricesAndThreeQubitVector_applying_returnExpectedVector)
    ]
}
