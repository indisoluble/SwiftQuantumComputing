//
//  SimulatorMatrixComponentsExtractorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/02/2021.
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

class SimulatorMatrixComponentsExtractorTests: XCTestCase {

    // MARK: - Properties

    let nonPowerOfTwoSizeMatrix = try! Matrix([
        [.zero, .zero, .zero],
        [.zero, .zero, .zero],
        [.zero, .zero, .zero]
    ])
    let nonUnitaryMatrix = try! Matrix([
        [.zero, .one],
        [.one, .one]
    ])
    let validMatrix = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero],
        [.zero, .zero, .zero, .one],
        [.zero, .zero, .one, .zero]
    ])
    let oracleValidMatrix = try! Matrix([
        [.zero, .one, .zero, .zero],
        [.one, .zero, .zero, .zero],
        [.zero, .zero, .one, .zero],
        [.zero, .zero, .zero, .one]
    ])
    let oracleExtendedValidMatrix = try! Matrix([
        [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
        [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
        [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
    ])
    let validQubitCount = 3
    let extendedValidQubitCount = 6
    let validInputs = [2, 1]
    let extendedValidInputs = [5, 2, 1]

    // MARK: - Tests

    func testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [1, 1])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputsAreNotUnique)
    }

    func testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0]),
                                   controls: [1])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateMatrixRowCountHasToBeAPowerOfTwo))
    }

    func testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonPowerOfTwoSizeMatrix, inputs: [0])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateMatrixRowCountHasToBeAPowerOfTwo))
    }

    func testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.controlled(gate: .matrix(matrix: nonUnitaryMatrix, inputs: [0]),
                                   controls: [1])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateMatrixIsNotUnitary))
    }

    func testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: nonUnitaryMatrix, inputs: [0])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateMatrixIsNotUnitary))
    }

    func testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [2, 1, 0])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputCountDoesNotMatchOperatorMatrixQubitCount)
    }

    func testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputCountDoesNotMatchOperatorMatrixQubitCount)
    }

    func testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException() {
        // Given
        let qubitCount = 0
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .circuitQubitCountHasToBeBiggerThanZero)
    }

    func testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException() {
        // Given
        let qubitCount = 1
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: qubitCount) {
            error = e
        }
        XCTAssertEqual(error, .operatorHandlesMoreQubitsThanCircuitActuallyHas)
    }

    func testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: [0, validQubitCount])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .operatorInputsAreNotInBound)
    }

    func testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.matrix(matrix: validMatrix, inputs: validInputs)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), validMatrix)
        XCTAssertEqual(inputs, validInputs)
    }

    func testGateMatrixWithSingleQubitMatrixAndValidInputs_extractComponents_returnExpectedValues() {
        // Given
        let singleQubitMatrix = Matrix.makeHadamard()
        let target = 0
        let gate = Gate.matrix(matrix: singleQubitMatrix, inputs: [0])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), singleQubitMatrix)
        XCTAssertEqual(inputs, [target])
    }

    func testGateHadamardAndValidInput_extractComponents_returnExpectedValues() {
        // Given
        let target = 0
        let gate = Gate.hadamard(target: target)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), .makeHadamard())
        XCTAssertEqual(inputs, [target])
    }

    func testGatePhaseShiftAndValidInput_extractComponents_returnExpectedValues() {
        // Given
        let radians = 0.1
        let target = 0
        let gate = Gate.phaseShift(radians: radians, target: target)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(),
                       .makePhaseShift(radians: radians))
        XCTAssertEqual(inputs, [target])
    }

    func testGateRotationAndValidInput_extractComponents_returnExpectedValues() {
        // Given
        let axis = Gate.Axis.x
        let radians = 0.1
        let target = 0
        let gate = Gate.rotation(axis: axis, radians: radians, target: target)
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(),
                       .makeRotation(axis: axis, radians: radians))
        XCTAssertEqual(inputs, [target])
    }

    func testGateOracleWithGateThatThrowException_extractComponents_throwException() {
        // Given
        let gate = Gate.oracle(truthTable: [],
                               controls: [1],
                               gate: .matrix(matrix: nonUnitaryMatrix, inputs: [0]))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateMatrixIsNotUnitary))
    }

    func testGateOracleWithEmptyControls_extractComponents_throwException() {
        // Given
        let gate = Gate.oracle(truthTable: [],
                               controls: [],
                               gate: .matrix(matrix: validMatrix, inputs: validInputs))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // Then
        var error: QuantumOperatorError?
        if case .failure(let e) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            error = e
        }
        XCTAssertEqual(error, .gateError(error: .gateControlsCanNotBeAnEmptyList))
    }

    func testGateOracleWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"], controls: [2], gate: .not(target: 1))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: validQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), oracleValidMatrix)
        XCTAssertEqual(inputs, validInputs)
    }

    func testGateOracleWithNotGateAndTwoControls_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.oracle(truthTable: ["00", "11"], controls: [5, 2], gate: .not(target: 1))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(),
                       oracleExtendedValidMatrix)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    func testGateOracleWithGateControlledWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"],
                               controls: [5],
                               gate: .controlled(gate: .not(target: 1), controls: [2]))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        let expectedMatrix = try! Matrix([
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        ])

        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), expectedMatrix)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    func testGateControlledWithGateOracleWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.controlled(gate: .oracle(truthTable: ["0"],
                                                 controls: [2],
                                                 gate: .not(target: 1)),
                                   controls: [5])
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        let expectedMatrix = try! Matrix([
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        ])

        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), expectedMatrix)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    func testGateOracleWithGateOracleWithNotGate_extractComponents_returnExpectedValues() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"],
                               controls: [5],
                               gate: .oracle(truthTable: ["0"],
                                             controls: [2],
                                             gate: .not(target: 1)))
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        // When
        var matrix: SimulatorMatrix?
        var inputs: [Int]?
        if case .success(let result) = extractor.extractComponents(restrictedToCircuitQubitCount: extendedValidQubitCount) {
            matrix = result.matrix
            inputs = result.inputs
        }

        // Then
        let expectedMatrix = try! Matrix([
            [.zero, .one, .zero, .zero, .zero, .zero, .zero, .zero],
            [.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .one, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one],
        ])

        XCTAssertEqual(try? matrix?.expandedRawMatrix(maxConcurrency: 1).get(), expectedMatrix)
        XCTAssertEqual(inputs, extendedValidInputs)
    }

    static var allTests = [
        ("testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndRepeatedInputs_extractComponents_throwException),
        ("testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException",
         testGateControlledMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException),
        ("testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException",
         testGateMatrixWithNonPowerOfTwoSizeMatrix_extractComponents_throwException),
        ("testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException",
         testGateControlledMatrixWithNonUnitaryMatrix_extractComponents_throwException),
        ("testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException",
         testGateMatrixWithNonUnitaryMatrix_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndMoreInputsThanGateTakes_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndLessInputsThanGateTakes_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndQubitCountEqualToZero_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndSizeBiggerThanQubitCount_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException",
         testGateMatrixWithValidMatrixAndInputsOutOfRange_extractComponents_throwException),
        ("testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues",
         testGateMatrixWithValidMatrixAndValidInputs_extractComponents_returnExpectedValues),
        ("testGateMatrixWithSingleQubitMatrixAndValidInputs_extractComponents_returnExpectedValues",
         testGateMatrixWithSingleQubitMatrixAndValidInputs_extractComponents_returnExpectedValues),
        ("testGateHadamardAndValidInput_extractComponents_returnExpectedValues",
         testGateHadamardAndValidInput_extractComponents_returnExpectedValues),
        ("testGatePhaseShiftAndValidInput_extractComponents_returnExpectedValues",
         testGatePhaseShiftAndValidInput_extractComponents_returnExpectedValues),
        ("testGateRotationAndValidInput_extractComponents_returnExpectedValues",
         testGateRotationAndValidInput_extractComponents_returnExpectedValues),
        ("testGateOracleWithGateThatThrowException_extractComponents_throwException",
         testGateOracleWithGateThatThrowException_extractComponents_throwException),
        ("testGateOracleWithEmptyControls_extractComponents_throwException",
         testGateOracleWithEmptyControls_extractComponents_throwException),
        ("testGateOracleWithNotGate_extractComponents_returnExpectedValues",
         testGateOracleWithNotGate_extractComponents_returnExpectedValues),
        ("testGateOracleWithNotGateAndTwoControls_extractComponents_returnExpectedValues",
         testGateOracleWithNotGateAndTwoControls_extractComponents_returnExpectedValues),
        ("testGateOracleWithGateControlledWithNotGate_extractComponents_returnExpectedValues",
         testGateOracleWithGateControlledWithNotGate_extractComponents_returnExpectedValues),
        ("testGateControlledWithGateOracleWithNotGate_extractComponents_returnExpectedValues",
         testGateControlledWithGateOracleWithNotGate_extractComponents_returnExpectedValues),
        ("testGateOracleWithGateOracleWithNotGate_extractComponents_returnExpectedValues",
         testGateOracleWithGateOracleWithNotGate_extractComponents_returnExpectedValues)
    ]
}
