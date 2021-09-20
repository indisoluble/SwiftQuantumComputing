//
//  DensityMatrixTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/09/2021.
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

class DensityMatrixTransformationTests: XCTestCase {

    // MARK: - Properties

    let sut = try! CSMFullMatrixDensityMatrixTransformation(expansionConcurrency: 1)

    let threeQubitZeroMatrix = try! Matrix([
        [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitOneMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitTwoMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitThreeMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitFourMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitFiveMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitSixMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero]
    ])
    let threeQubitSevenMatrix = try! Matrix([
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one]
    ])
    let oneQubitZeroMatrix = try! Matrix([[.one, .zero], [.zero, .zero]])
    let oneQubitOneMatrix = try! Matrix([[.zero, .zero], [.zero, .one]])
    let simulatorGateMultiqubitMatrix = try! OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                                   controlledMatrix: Matrix.makeNot()).expandedRawMatrix(maxConcurrency: 1).get()

    // MARK: - Tests

    func testInvalidGate_apply_throwError() {
        // Given
        let quantumOperator = Gate.controlledNot(target: 0, control: 0).quantumOperator

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = sut.apply(quantumOperator: quantumOperator,
                                            toDensityMatrix: oneQubitZeroMatrix) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputsAreNotUnique)
    }

    func testNotMatrixAndOneQubitMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.not(target: 0).quantumOperator,
                                    toDensityMatrix: oneQubitZeroMatrix).get()

        // Then
        XCTAssertEqual(result, oneQubitOneMatrix)
    }

    func testNotMatrixAndThreeQubitMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.not(target: 2).quantumOperator,
                                    toDensityMatrix: threeQubitZeroMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitFourMatrix)
    }

    func testTwoNotMatricesAndThreeQubitMatrix_apply_returnExpectedMatrix() {
        // When
        var result = try! sut.apply(quantumOperator: Gate.not(target: 2).quantumOperator,
                                    toDensityMatrix: threeQubitZeroMatrix).get()
        result = try! sut.apply(quantumOperator: Gate.not(target: 0).quantumOperator,
                                toDensityMatrix: result).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveMatrix)
    }

    func testControlledNotMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 1,
                                                                        control: 0).quantumOperator,
                                    toDensityMatrix: threeQubitZeroMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitZeroMatrix)
    }

    func testControlledNotMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 1,
                                                                        control: 0).quantumOperator,
                                    toDensityMatrix: threeQubitOneMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeMatrix)
    }

    func testControlledNotMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 1,
                                                                        control: 0).quantumOperator,
                                    toDensityMatrix: threeQubitTwoMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitTwoMatrix)
    }

    func testControlledNotMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 1,
                                                                        control: 0).quantumOperator,
                                    toDensityMatrix: threeQubitThreeMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitOneMatrix)
    }

    func testControlledNotMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 2,
                                                                        control: 1).quantumOperator,
                                    toDensityMatrix: threeQubitThreeMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenMatrix)
    }

    func testControlledNotMatrixFourQubitOneMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 0,
                                                                        control: 2).quantumOperator,
                                    toDensityMatrix: threeQubitFourMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveMatrix)
    }

    func testControlledNotMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 0,
                                                                        control: 2).quantumOperator,
                                    toDensityMatrix: threeQubitFiveMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitFourMatrix)
    }

    func testControlledNotMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 0,
                                                                        control: 2).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSixMatrix)
    }

    func testControlledNotMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.controlledNot(target: 2,
                                                                        control: 1).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeMatrix)
    }

    func testControlledMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])

        // When
        let result = try! sut.apply(quantumOperator: Gate.controlled(gate: .matrix(matrix: matrix,
                                                                                   inputs: [0]),
                                                                     controls: [2]).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenMatrix)
    }

    func testMultiqubitMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [0, 1]).quantumOperator,
                                    toDensityMatrix: threeQubitZeroMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitZeroMatrix)
    }

    func testMultiqubitMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [0, 1]).quantumOperator,
                                    toDensityMatrix: threeQubitOneMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeMatrix)
    }

    func testMultiqubitMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [0, 1]).quantumOperator,
                                    toDensityMatrix: threeQubitTwoMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitTwoMatrix)
    }

    func testMultiqubitMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [0, 1]).quantumOperator,
                                    toDensityMatrix: threeQubitThreeMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitOneMatrix)
    }

    func testMultiqubitMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [1, 2]).quantumOperator,
                                    toDensityMatrix: threeQubitThreeMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenMatrix)
    }

    func testMultiqubitMatrixFourQubitOneMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [2, 0]).quantumOperator,
                                    toDensityMatrix: threeQubitFourMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitFiveMatrix)
    }

    func testMultiqubitMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [2, 0]).quantumOperator,
                                    toDensityMatrix: threeQubitFiveMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitFourMatrix)
    }

    func testMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [2, 0]).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSixMatrix)
    }

    func testMultiqubitMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix() {
        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMultiqubitMatrix,
                                                                 inputs: [1, 2]).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitThreeMatrix)
    }

    func testOtherMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix() {
        // Given
        let matrix = try! Matrix([[.one, .zero], [.zero, .one]])
        let simulatorGateMatrix = try! OracleSimulatorMatrix(equivalentToControlledGateWithControlCount: 1,
                                                             controlledMatrix: matrix).expandedRawMatrix(maxConcurrency: 1).get()

        // When
        let result = try! sut.apply(quantumOperator: Gate.matrix(matrix: simulatorGateMatrix,
                                                                 inputs: [2, 0]).quantumOperator,
                                    toDensityMatrix: threeQubitSevenMatrix).get()

        // Then
        XCTAssertEqual(result, threeQubitSevenMatrix)
    }

    static var allTests = [
        ("testInvalidGate_apply_throwError",
         testInvalidGate_apply_throwError),
        ("testNotMatrixAndOneQubitMatrix_apply_returnExpectedMatrix",
         testNotMatrixAndOneQubitMatrix_apply_returnExpectedMatrix),
        ("testNotMatrixAndThreeQubitMatrix_apply_returnExpectedMatrix",
         testNotMatrixAndThreeQubitMatrix_apply_returnExpectedMatrix),
        ("testTwoNotMatricesAndThreeQubitMatrix_apply_returnExpectedMatrix",
         testTwoNotMatricesAndThreeQubitMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix",
         testControlledNotMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix),
        ("testControlledNotMatrixFourQubitOneMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixFourQubitOneMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix",
         testControlledNotMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testControlledNotMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix",
         testControlledNotMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix),
        ("testControlledMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix",
         testControlledMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndThreeQubitZeroMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndThreeQubitOneMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndThreeQubitTwoMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndThreeQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix",
         testMultiqubitMatrixThreeQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixFourQubitOneMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixFourQubitOneMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndFiveQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix",
         testMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix),
        ("testMultiqubitMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix",
         testMultiqubitMatrixSevenQubitThreeMatrixAndOtherInputs_apply_returnExpectedMatrix),
        ("testOtherMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix",
         testOtherMultiqubitMatrixAndSevenQubitThreeMatrix_apply_returnExpectedMatrix)
    ]
}
