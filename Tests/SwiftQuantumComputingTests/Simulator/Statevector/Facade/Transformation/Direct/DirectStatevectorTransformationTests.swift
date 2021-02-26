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
    let fourQubitFourteenVector = try! Vector([
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .one, .zero
    ])
    let fourQubitFifteenVector = try! Vector([
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .one
    ])
    let simulatorGateMultiqubitMatrix = OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                              controlledCountableMatrix: Matrix.makeNot()).expandedRawMatrix()

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_init_throwError() {
        // Then
        XCTAssertThrowsError(try DirectStatevectorTransformation(indexingFactory: DirectStatevectorIndexingFactoryAdapter(),
                                                                 maxConcurrency: 0))
    }

    func testInvalidGate_apply_throwError() {
        // Given
        let factory = DirectStatevectorIndexingFactoryTestDouble()

        let sut = try! DirectStatevectorTransformation(indexingFactory: factory, maxConcurrency: 1)

        let gate = Gate.controlledNot(target: 0, control: 0)

        // Then
        var error: GateError?
        if case .failure(let e) = sut.apply(gate: gate, toStatevector: oneQubitZeroVector) {
            error = e
        }
        XCTAssertEqual(error, .gateInputsAreNotUnique)
    }

    func testNotMatrixAndOneQubitVector_apply_returnExpectedVector() {
        // Given
        let target = 0
        let factory = DirectStatevectorIndexingFactoryTestDouble()

        let sut = try! DirectStatevectorTransformation(indexingFactory: factory, maxConcurrency: 1)

        // When
        let result = try! sut.apply(gate: .not(target: target),
                                    toStatevector: oneQubitZeroVector).get()

        // Then
        XCTAssertEqual(result, oneQubitOneVector)
        XCTAssertEqual(factory.makeSingleQubitGateIndexerCount, 1)
        XCTAssertEqual(factory.lastMakeSingleQubitGateIndexerGateInput, target)
        XCTAssertEqual(factory.makeMultiQubitGateIndexerCount, 0)
    }

    func testNotMatrixAndThreeQubitVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .not(target: 2),
                                        toStatevector: threeQubitZeroVector).get()

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testTwoNotMatricesAndThreeQubitVector_apply_returnExpectedVector() {
        // When
        var result = try! adapter.apply(gate: .not(target: 2),
                                        toStatevector: threeQubitZeroVector).get()
        result = try! adapter.apply(gate: .not(target: 0),
                                    toStatevector: result).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndThreeQubitZeroVector_apply_returnExpectedVector() {
        // Given
        let target = 1
        let factory = DirectStatevectorIndexingFactoryTestDouble()

        let sut = try! DirectStatevectorTransformation(indexingFactory: factory, maxConcurrency: 1)

        // When
        let result = try! sut.apply(gate: .controlledNot(target: target, control: 0),
                                    toStatevector: threeQubitZeroVector).get()

        // Then
        XCTAssertEqual(result, threeQubitZeroVector)
        XCTAssertEqual(factory.makeSingleQubitGateIndexerCount, 1)
        XCTAssertEqual(factory.lastMakeSingleQubitGateIndexerGateInput, target)
        XCTAssertEqual(factory.makeMultiQubitGateIndexerCount, 0)
    }

    func testControlledNotMatrixAndThreeQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 1, control: 0),
                                        toStatevector: threeQubitOneVector).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledNotMatrixAndThreeQubitTwoVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 1, control: 0),
                                        toStatevector: threeQubitTwoVector).get()

        // Then
        XCTAssertEqual(result, threeQubitTwoVector)
    }

    func testControlledNotMatrixAndThreeQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 1, control: 0),
                                        toStatevector: threeQubitThreeVector).get()

        // Then
        XCTAssertEqual(result, threeQubitOneVector)
    }

    func testControlledNotMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 2, control: 1),
                                        toStatevector: threeQubitThreeVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testControlledNotMatrixFourQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 0, control: 2),
                                        toStatevector: threeQubitFourVector).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testControlledNotMatrixAndFiveQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 0, control: 2),
                                        toStatevector: threeQubitFiveVector).get()

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testControlledNotMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 0, control: 2),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSixVector)
    }

    func testControlledNotMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlledNot(target: 2, control: 1),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testControlledMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])

        // When
        let result = try! adapter.apply(gate: .controlled(gate: .matrix(matrix: matrix, inputs: [0]), controls: [2]),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testThreeQubitControlledNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .controlled(gate: .not(target: 2), controls: [3, 0]),
                                        toStatevector: fourQubitElevenVector).get()

        // Then
        XCTAssertEqual(result, fourQubitFifteenVector)
    }

    func testThreeQubitControlledNotNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector() {
        // Given
        let matrix = Matrix.tensorProduct(Matrix.makeNot(), Matrix.makeNot())

        // When
        let result = try! adapter.apply(gate: .controlled(gate: .matrix(matrix: matrix, inputs: [0, 2]), controls: [3]),
                                        toStatevector: fourQubitElevenVector).get()

        // Then
        XCTAssertEqual(result, fourQubitFourteenVector)
    }

    func testMultiqubitMatrixAndThreeQubitZeroVector_apply_returnExpectedVector() {
        // Given
        let inputs = [0, 1]
        let factory = DirectStatevectorIndexingFactoryTestDouble()

        let sut = try! DirectStatevectorTransformation(indexingFactory: factory, maxConcurrency: 1)

        // When
        let result = try! sut.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: inputs),
                                    toStatevector: threeQubitZeroVector).get()

        // Then
        XCTAssertEqual(result, threeQubitZeroVector)
        XCTAssertEqual(factory.makeSingleQubitGateIndexerCount, 0)
        XCTAssertEqual(factory.makeMultiQubitGateIndexerCount, 1)
        XCTAssertEqual(factory.lastMakeMultiQubitGateIndexerGateInputs, inputs)
    }

    func testMultiqubitMatrixAndThreeQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [0, 1]),
                                        toStatevector: threeQubitOneVector).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testMultiqubitMatrixAndThreeQubitTwoVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [0, 1]),
                                        toStatevector: threeQubitTwoVector).get()

        // Then
        XCTAssertEqual(result, threeQubitTwoVector)
    }

    func testMultiqubitMatrixAndThreeQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [0, 1]),
                                        toStatevector: threeQubitThreeVector).get()

        // Then
        XCTAssertEqual(result, threeQubitOneVector)
    }

    func testMultiqubitMatrixThreeQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [1, 2]),
                                        toStatevector: threeQubitThreeVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testMultiqubitMatrixFourQubitOneVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [2, 0]),
                                        toStatevector: threeQubitFourVector).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveVector)
    }

    func testMultiqubitMatrixAndFiveQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [2, 0]),
                                        toStatevector: threeQubitFiveVector).get()

        // Then
        XCTAssertEqual(result, threeQubitFourVector)
    }

    func testMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [2, 0]),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSixVector)
    }

    func testMultiqubitMatrixSevenQubitThreeVectorAndOtherInputs_apply_returnExpectedVector() {
        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMultiqubitMatrix, inputs: [1, 2]),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeVector)
    }

    func testOtherMultiqubitMatrixAndSevenQubitThreeVector_apply_returnExpectedVector() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])
        let simulatorGateMatrix = OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                        controlledCountableMatrix: matrix).expandedRawMatrix()

        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMatrix, inputs: [2, 0]),
                                        toStatevector: threeQubitSevenVector).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenVector)
    }

    func testThreeQubitMultiqubitMatrixAndElevenQubitFourVector_apply_returnExpectedVector() {
        // Given
        let simulatorGateMatrix = OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 2,
                                                        controlledCountableMatrix: Matrix.makeNot()).expandedRawMatrix()

        // When
        let result = try! adapter.apply(gate: .matrix(matrix: simulatorGateMatrix, inputs: [3, 0, 2]),
                                        toStatevector: fourQubitElevenVector).get()

        // Then
        XCTAssertEqual(result, fourQubitFifteenVector)
    }

    func testDirectAndSCMTransformationAndOneQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.hadamard(target: 1)

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndTwoQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .hadamard(target: 2), controls: [0])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndThreeQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .hadamard(target: 1), controls: [0, 3])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndFourQubitControlledMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .hadamard(target: 2), controls: [3, 1, 0])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndTwoQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .rotation(axis: .y, radians: 0.1, target: 0),
                                   controls: [2])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: threeQubitSevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: threeQubitSevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndThreeQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .rotation(axis: .x, radians: 0.1, target: 2),
                                   controls: [0, 3])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    func testDirectAndSCMTransformationAndFourQubitMatrix_apply_returnSameVector() {
        // Given
        let scmAdapter = CSMFullMatrixStatevectorTransformation()

        let gate = Gate.controlled(gate: .rotation(axis: .x, radians: 0.1, target: 3),
                                   controls: [2, 0, 1])

        // When
        let scmVector = scmAdapter.apply(gate: gate, toStatevector: fourQubitElevenVector)
        let directVector = adapter.apply(gate: gate, toStatevector: fourQubitElevenVector)

        // Then
        XCTAssertEqual(scmVector, directVector)
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_init_throwError",
         testMaxConcurrencyEqualToZero_init_throwError),
        ("testInvalidGate_apply_throwError",
         testInvalidGate_apply_throwError),
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
        ("testThreeQubitControlledNotNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector",
         testThreeQubitControlledNotNotMatrixAndElevenQubitFourVector_apply_returnExpectedVector),
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
