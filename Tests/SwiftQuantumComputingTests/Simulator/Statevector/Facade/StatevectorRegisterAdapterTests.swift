//
//  StatevectorRegisterAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

class StatevectorRegisterAdapterTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()
    let gate = SimulatorGateTestDouble()

    // MARK: - Tests

    func testVectorWhichLengthIsNotPowerOfTwo_init_throwException() {
        // Given
        let noPowerOfTwoVector = try! Vector([Complex.one, Complex.zero, Complex.zero])

        // Then
        XCTAssertThrowsError(try StatevectorRegisterAdapter(vector: noPowerOfTwoVector,
                                                            matrixFactory: matrixFactory))
    }

    func testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException() {
        // Given
        let addSquareModulusNotEqualToOneVector = try! Vector([Complex.one, Complex.one])
        let adapter = try! StatevectorRegisterAdapter(vector: addSquareModulusNotEqualToOneVector,
                                                      matrixFactory: matrixFactory)

        // Then
        XCTAssertThrowsError(try adapter.statevector())
    }

    func testValidVector_statevector_returnValue() {
        // Given
        let vector = try! Vector([Complex.one, Complex.zero])
        let adapter = try! StatevectorRegisterAdapter(vector: vector, matrixFactory: matrixFactory)

        // When
        let result = try! adapter.statevector()

        // Then
        XCTAssertEqual(result, vector)
    }

    func testMatrixFactoryThatThrowsError_applying_throwError() {
        // Given
        let vector = try! Vector([Complex.one, Complex.zero])
        let vectorQubitCount = 1
        let adapter = try! StatevectorRegisterAdapter(vector: vector, matrixFactory: matrixFactory)

        // Then
        XCTAssertThrowsError(try adapter.applying(gate))
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, vectorQubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === gate)
        } else {
            XCTAssert(false)
        }
    }

    func testMatrixFactoryReturnsMatrix_applying_returnValue() {
        // Given
        let vectorQubitCount = 1
        var elements = Array(repeating: Complex.zero, count: Int.pow(2, vectorQubitCount))
        elements[0] = Complex.one

        let vector = try! Vector(elements)
        let adapter = try! StatevectorRegisterAdapter(vector: vector, matrixFactory: matrixFactory)

        let matrix = try! Matrix([[Complex.zero, Complex.one], [Complex.one, Complex.zero]])
        matrixFactory.makeCircuitMatrixResult = matrix

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, vectorQubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === gate)
        } else {
            XCTAssert(false)
        }

        let expectedVector = try! Vector([Complex.zero, Complex.one])
        XCTAssertEqual(try? result?.statevector(), expectedVector)
    }

    func testTwoQubitsRegisterInitializedToZeroAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2
        var elements = Array(repeating: Complex.zero, count: Int.pow(2, qubitCount))
        elements[0] = Complex.one

        let vector = try! Vector(elements)
        let adapter = try! StatevectorRegisterAdapter(vector: vector, matrixFactory: matrixFactory)

        let matrix = try! SimulatorCircuitMatrixFactoryAdapter().makeCircuitMatrix(qubitCount: qubitCount,
                                                                                   gate: Gate.not(target: 0))
        matrixFactory.makeCircuitMatrixResult = matrix

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, qubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === gate)
        } else {
            XCTAssert(false)
        }

        let expectedVector = try! Vector([Complex.zero, Complex.one, Complex.zero, Complex.zero])
        XCTAssertEqual(try? result?.statevector(), expectedVector)
    }

    static var allTests = [
        ("testVectorWhichLengthIsNotPowerOfTwo_init_throwException",
         testVectorWhichLengthIsNotPowerOfTwo_init_throwException),
        ("testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException",
         testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException),
        ("testValidVector_statevector_returnValue",
         testValidVector_statevector_returnValue),
        ("testMatrixFactoryThatThrowsError_applying_throwError",
         testMatrixFactoryThatThrowsError_applying_throwError),
        ("testMatrixFactoryReturnsMatrix_applying_returnValue",
         testMatrixFactoryReturnsMatrix_applying_returnValue),
        ("testTwoQubitsRegisterInitializedToZeroAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedToZeroAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne)
    ]
}
