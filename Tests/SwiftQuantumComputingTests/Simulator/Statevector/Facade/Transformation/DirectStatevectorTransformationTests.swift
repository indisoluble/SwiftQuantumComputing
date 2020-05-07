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

    let transformation = StatevectorTransformationTestDouble()
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

    func testThreeQubitMatrix_applying_forwardToTransformation() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        let gateInputs = [2, 1, 0]
        let gateMatrix = try! Matrix.makeOracle(truthTable: ["00"], controlCount: 2)

        transformation.applyResult = threeQubitFourVector

        // When
        let result = adapter.apply(gateMatrix: gateMatrix,
                                   toStatevector: threeQubitZeroVector,
                                   atInputs: gateInputs)

        // Then
        XCTAssertEqual(transformation.applyCount, 1)
        XCTAssertEqual(transformation.lastApplyMatrix, gateMatrix)
        XCTAssertEqual(transformation.lastApplyVector, threeQubitZeroVector)
        XCTAssertEqual(transformation.lastApplyInputs, gateInputs)
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testNotMatrixAndOneQubitVector_applying_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeNot(),
                                   toStatevector: oneQubitZeroVector,
                                   atInputs: [0])

        // Then
        XCTAssertEqual(result, oneQubitOneVector)
    }

    func testNotMatrixAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeNot(),
                                   toStatevector: threeQubitZeroVector,
                                   atInputs: [2])

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testTwoNotMatricesAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        var adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        var result = adapter.apply(gateMatrix: Matrix.makeNot(),
                                   toStatevector: threeQubitZeroVector,
                                   atInputs: [2])
        adapter = DirectStatevectorTransformation(transformation: transformation)
        result = adapter.apply(gateMatrix: Matrix.makeNot(),
                               toStatevector: result,
                               atInputs: [0])

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    static var allTests = [
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
