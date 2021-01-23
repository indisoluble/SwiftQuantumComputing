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

    let adapter = try! DirectStatevectorTransformation(indexingFactory: DirectStatevectorIndexingFactoryAdapter(),
                                                       maxConcurrency: 1)

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
    let fourQubitElevenVector = try! Vector([
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .one, .zero, .zero, .zero, .zero
    ])
    let fourQubitFifteenVector = try! Vector([
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .one
    ])
    let simulatorGateNotMatrix = SimulatorGateMatrix.singleQubitMatrix(matrix: Matrix.makeNot())
    let simulatorGateControlledNotMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: Matrix.makeNot(),
                                                                                                controlCount: 1)
    let simulatorGateMultiqubitMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                                                                                controlledMatrix: Matrix.makeNot()))

    // MARK: - Tests

    func testNotMatrixAndOneQubitVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateNotMatrix, [0]),
                                   toStatevector: oneQubitZeroVector)

        // Then
        XCTAssertEqual(result, oneQubitOneVector)
    }

    func testNotMatrixAndThreeQubitVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateNotMatrix, [2]),
                                   toStatevector: threeQubitZeroVector)

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testTwoNotMatricesAndThreeQubitVector_apply_returnExpectedVector() {
        // When
        var result = adapter.apply(components: (simulatorGateNotMatrix, [2]),
                                   toStatevector: threeQubitZeroVector)
        result = adapter.apply(components: (simulatorGateNotMatrix, [0]),
                               toStatevector: result)

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndThreeQubitZeroVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [0, 1]),
                                   toStatevector: threeQubitZeroVector)

        // Then
        XCTAssertEqual(result, threeQubitZeroVector)
    }

    func testControlledNotMatrixAndThreeQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [0, 1]),
                                   toStatevector: threeQubitOneVector)

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledNotMatrixAndThreeQubitTwoVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [0, 1]),
                                   toStatevector: threeQubitTwoVector)

        // Then
        XCTAssertEqual(result, threeQubitTwoVector)
    }

    func testControlledNotMatrixAndThreeQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [0, 1]),
                                   toStatevector: threeQubitThreeVector)

        // Then
        XCTAssertEqual(result, threeQubitOneVector)
    }

    func testControlledNotMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [1, 2]),
                                   toStatevector: threeQubitThreeVector)

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testControlledNotMatrixFourQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [2, 0]),
                                   toStatevector: threeQubitFourVector)

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndFiveQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [2, 0]),
                                   toStatevector: threeQubitFiveVector)

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testControlledNotMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [2, 0]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitSixVector)
    }

    func testControlledNotMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateControlledNotMatrix, [1, 2]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])
        let simulatorGateMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: matrix,
                                                                                       controlCount: 1)

        // When
        let result = adapter.apply(components: (simulatorGateMatrix, [2, 0]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testThreeQubitControlledNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector() {
        // Given
        let simulatorGateMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: Matrix.makeNot(),
                                                                                       controlCount: 2)

        // When
        let result = adapter.apply(components: (simulatorGateMatrix, [3, 0, 2]),
                                   toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(result, fourQubitFifteenVector)
    }

    func testMultiqubitMatrixAndThreeQubitZeroVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [0, 1]),
                                   toStatevector: threeQubitZeroVector)

        // Then
        XCTAssertEqual(result, threeQubitZeroVector)
    }

    func testMultiqubitMatrixAndThreeQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [0, 1]),
                                   toStatevector: threeQubitOneVector)

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testMultiqubitMatrixAndThreeQubitTwoVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [0, 1]),
                                   toStatevector: threeQubitTwoVector)

        // Then
        XCTAssertEqual(result, threeQubitTwoVector)
    }

    func testMultiqubitMatrixAndThreeQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [0, 1]),
                                   toStatevector: threeQubitThreeVector)

        // Then
        XCTAssertEqual(result, threeQubitOneVector)
    }

    func testMultiqubitMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [1, 2]),
                                   toStatevector: threeQubitThreeVector)

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testMultiqubitMatrixFourQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [2, 0]),
                                   toStatevector: threeQubitFourVector)

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testMultiqubitMatrixAndFiveQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [2, 0]),
                                   toStatevector: threeQubitFiveVector)

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [2, 0]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitSixVector)
    }

    func testMultiqubitMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = adapter.apply(components: (simulatorGateMultiqubitMatrix, [1, 2]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testOtherMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])
        let simulatorGateMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                                                                          controlledMatrix: matrix))

        // When
        let result = adapter.apply(components: (simulatorGateMatrix, [2, 0]),
                                   toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testThreeQubitMultiqubitMatrixAndElevenQubitFourVector_apply_returnExpectedVector() {
        // Given
        let simulatorGateMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 2,
                                                                                                          controlledMatrix: Matrix.makeNot()))

        // When
        let result = adapter.apply(components: (simulatorGateMatrix, [3, 0, 2]),
                                   toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(result, fourQubitFifteenVector)
    }

    func testDirectAndSCMTransformationAndOneQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let simulatorMatrix = SimulatorGateMatrix.singleQubitMatrix(matrix: Matrix.makeHadamard())
        let components: SimulatorGate.Components = (simulatorMatrix, [1])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndTwoQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let simulatorMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: Matrix.makeHadamard(),
                                                                                   controlCount: 1)
        let components: SimulatorGate.Components = (simulatorMatrix, [0, 2])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndThreeQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let simulatorMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: Matrix.makeHadamard(),
                                                                                   controlCount: 2)
        let components: SimulatorGate.Components = (simulatorMatrix, [0, 3, 1])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndFourQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let simulatorMatrix = SimulatorGateMatrix.fullyControlledSingleQubitMatrix(controlledMatrix: Matrix.makeHadamard(),
                                                                                   controlCount: 3)
        let components: SimulatorGate.Components = (simulatorMatrix, [3, 1, 0, 2])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndTwoQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let rawMatrix = Matrix.makeRotation(axis: .y, radians: 0.1)
        let simulatorMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                                                                      controlledMatrix: rawMatrix))
        let components: SimulatorGate.Components = (simulatorMatrix, [2, 0])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndThreeQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let rawMatrix = Matrix.makeRotation(axis: .x, radians: 0.1)
        let simulatorMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 2,
                                                                                                      controlledMatrix: rawMatrix))
        let components: SimulatorGate.Components = (simulatorMatrix, [0, 3, 2])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndFourQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CircuitMatrixStatevectorTransformation(matrixFactory: SimulatorCircuitMatrixFactoryAdapter())

        let rawMatrix = Matrix.makeRotation(axis: .x, radians: 0.1)
        let simulatorMatrix = SimulatorGateMatrix.otherMultiQubitMatrix(matrix: OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 3,
                                                                                                      controlledMatrix: rawMatrix))
        let components: SimulatorGate.Components = (simulatorMatrix, [2, 0, 1, 3])

        // When
        let scmVector = scmAdapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(components: components,
                                         toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    static var allTests = [
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
        ("testThreeQubitControlledNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector",
         testThreeQubitControlledNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndThreeQubitZeroVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndThreeQubitZeroVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndThreeQubitOneVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndThreeQubitOneVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndThreeQubitTwoVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndThreeQubitTwoVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndThreeQubitThreeVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndThreeQubitThreeVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector",
         testMultiqubitMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector),
        ("testMultiqubitMatrixFourQubitOneVector_apply_returnExpectedVector",
         testMultiqubitMatrixFourQubitOneVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndFiveQubitThreeVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndFiveQubitThreeVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector",
         testMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector),
        ("testMultiqubitMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector",
         testMultiqubitMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector),
        ("testOtherMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector",
         testOtherMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector),
        ("testThreeQubitMultiqubitMatrixAndElevenQubitFourVector_apply_returnExpectedVector",
         testThreeQubitMultiqubitMatrixAndElevenQubitFourVector_apply_returnExpectedVector),
        ("testDirectAndSCMTransformationAndOneQubitMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndOneQubitMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndTwoQubitControlledMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndTwoQubitControlledMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndThreeQubitControlledMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndThreeQubitControlledMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndFourQubitControlledMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndFourQubitControlledMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndTwoQubitMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndTwoQubitMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndThreeQubitMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndThreeQubitMatrix_apply_returnSameVector),
        ("testDirectAndSCMTransformationAndFourQubitMatrix_apply_returnSameVector",
         testDirectAndSCMTransformationAndFourQubitMatrix_apply_returnSameVector)
    ]
}
