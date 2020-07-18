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
    let threeQubitZeroVector = try! Vector([.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero])
    let threeQubitOneVector = try! Vector([.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero])
    let threeQubitTwoVector = try! Vector([.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero])
    let threeQubitThreeVector = try! Vector([.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero])
    let threeQubitFourVector = try! Vector([.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero])
    let threeQubitFiveVector = try! Vector([.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero])
    let threeQubitSixVector = try! Vector([.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero])
    let threeQubitSevenVector = try! Vector([.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one])
    let oneQubitZeroVector = try! Vector([.one, .zero])
    let oneQubitOneVector = try! Vector([.zero, .one])

    // MARK: - Tests

    func testThreeQubitMatrix_apply_forwardToTransformation() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        let gateInputs = [2, 1, 0]
        let gateMatrix = try! Matrix.makeOracle(truthTable: ["00"], controlCount: 2).get()

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

    func testTwoQubitNotControlledMatrix_apply_forwardToTransformation() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        let gateInputs = [2, 0]
        let gateMatrix = try! Matrix.makeOracle(truthTable: ["0", "1"], controlCount: 1).get()

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

    func testNotMatrixAndOneQubitVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeNot(),
                                   toStatevector: oneQubitZeroVector,
                                   atInputs: [0])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, oneQubitOneVector)
    }

    func testNotMatrixAndThreeQubitVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeNot(),
                                   toStatevector: threeQubitZeroVector,
                                   atInputs: [2])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testTwoNotMatricesAndThreeQubitVector_apply_returnExpectedVector() {
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
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndThreeQubitZeroVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitZeroVector,
                                   atInputs: [0, 1])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitZeroVector)
    }

    func testControlledNotMatrixAndThreeQubitOneVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitOneVector,
                                   atInputs: [0, 1])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledNotMatrixAndThreeQubitTwoVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitTwoVector,
                                   atInputs: [0, 1])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitTwoVector)
    }

    func testControlledNotMatrixAndThreeQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitThreeVector,
                                   atInputs: [0, 1])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitOneVector)
    }

    func testControlledNotMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitThreeVector,
                                   atInputs: [1, 2])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testControlledNotMatrixFourQubitOneVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitFourVector,
                                   atInputs: [2, 0])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndFiveQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitFiveVector,
                                   atInputs: [2, 0])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testControlledNotMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitSevenVector,
                                   atInputs: [2, 0])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitSixVector)
    }

    func testControlledNotMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        // When
        let result = adapter.apply(gateMatrix: Matrix.makeControlledNot(),
                                   toStatevector: threeQubitSevenVector,
                                   atInputs: [1, 2])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let adapter = DirectStatevectorTransformation(transformation: transformation)

        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])
        let gateMatrix = Matrix.makeControlledMatrix(matrix: matrix)

        // When
        let result = adapter.apply(gateMatrix: gateMatrix,
                                   toStatevector: threeQubitSevenVector,
                                   atInputs: [2, 0])

        // Then
        XCTAssertEqual(transformation.applyCount, 0)
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testDirectAndSCMTransformation_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())
        let directAdapter = DirectStatevectorTransformation(transformation: scmAdapter)

        let matrix = Matrix.makeHadamard()

        // When
        let scmVector = scmAdapter.apply(gateMatrix: matrix,
                                         toStatevector: threeQubitSevenVector,
                                         atInputs: [1])
        let directVector = directAdapter.apply(gateMatrix: matrix,
                                               toStatevector: threeQubitSevenVector,
                                               atInputs: [1])

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    static var allTests = [
        ("testThreeQubitMatrix_apply_forwardToTransformation",
         testThreeQubitMatrix_apply_forwardToTransformation),
        ("testTwoQubitNotControlledMatrix_apply_forwardToTransformation",
         testTwoQubitNotControlledMatrix_apply_forwardToTransformation),
        ("testNotMatrixAndOneQubitVector_apply_returnExpectedVector",
         testNotMatrixAndOneQubitVector_apply_returnExpectedVector),
        ("testNotMatrixAndThreeQubitVector_apply_returnExpectedVector",
         testNotMatrixAndThreeQubitVector_apply_returnExpectedVector),
        ("testTwoNotMatricesAndThreeQubitVector_apply_returnExpectedVector",
         testTwoNotMatricesAndThreeQubitVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndThreeQubitZeroVector_apply_returnExpectedVector",
         testControlledNotMatrixAndThreeQubitZeroVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndThreeQubitOneVector_apply_returnExpectedVector",
         testControlledNotMatrixAndThreeQubitOneVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndThreeQubitTwoVector_apply_returnExpectedVector",
         testControlledNotMatrixAndThreeQubitTwoVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndThreeQubitThreeVector_apply_returnExpectedVector",
         testControlledNotMatrixAndThreeQubitThreeVector_apply_returnExpectedVector),
        ("testControlledNotMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector",
         testControlledNotMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector),
        ("testControlledNotMatrixFourQubitOneVector_apply_returnExpectedVector",
         testControlledNotMatrixFourQubitOneVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndFiveQubitThreeVector_apply_returnExpectedVector",
         testControlledNotMatrixAndFiveQubitThreeVector_apply_returnExpectedVector),
        ("testControlledNotMatrixAndSevenQubitThreeVector_apply_returnExpectedVector",
         testControlledNotMatrixAndSevenQubitThreeVector_apply_returnExpectedVector),
        ("testControlledNotMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector",
         testControlledNotMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector),
        ("testControlledMatrixAndSevenQubitThreeVector_apply_returnExpectedVector",
         testControlledMatrixAndSevenQubitThreeVector_apply_returnExpectedVector),
        ("testDirectAndSCMTransformation_apply_returnSameVector",
         testDirectAndSCMTransformation_apply_returnSameVector)
    ]
}
