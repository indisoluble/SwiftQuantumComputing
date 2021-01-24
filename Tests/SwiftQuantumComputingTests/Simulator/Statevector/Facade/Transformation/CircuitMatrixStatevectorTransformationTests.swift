//
//  CircuitMatrixStatevectorTransformationTests.swift
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class CircuitMatrixStatevectorTransformationTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()

    // MARK: - Tests

    func testMatrixFactoryReturnsMatrix_applying_returnValue() {
        // Given
        let vectorQubitCount = 1
        var elements = Array(repeating: Complex<Double>.zero, count: Int.pow(2, vectorQubitCount))
        elements[0] = .one

        let vector = try! Vector(elements)
        let adapter = CircuitMatrixStatevectorTransformation(matrixFactory: matrixFactory)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()
        let simulatorGateMatrix = SimulatorGateMatrix.matrix(matrix: gateMatrix)

        let circuitMatrix = SimulatorMatrixTestDouble()
        circuitMatrix.rawMatrixResult = try! Matrix([
            [Complex.zero, Complex.one], [Complex.one, Complex.zero]
        ])
        matrixFactory.makeCircuitMatrixResult = circuitMatrix

        // When
        let result = adapter.apply(components: (simulatorGateMatrix, gateInputs),
                                   toStatevector: vector)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, vectorQubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixBaseMatrix?.rawMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixInputs, gateInputs)
        XCTAssertEqual(circuitMatrix.rawMatrixCount, 1)

        let expectedVector = try! Vector([Complex.zero, Complex.one])
        XCTAssertEqual(result, expectedVector)
    }

    func testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2
        var elements = Array(repeating: Complex<Double>.zero, count: Int.pow(2, qubitCount))
        elements[0] = .one

        let vector = try! Vector(elements)
        let adapter = CircuitMatrixStatevectorTransformation(matrixFactory: matrixFactory)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()

        let circuitMatrix = SimulatorCircuitMatrixFactoryAdapter().makeCircuitMatrix(qubitCount: qubitCount,
                                                                                     baseMatrix: gateMatrix,
                                                                                     inputs: gateInputs)
        matrixFactory.makeCircuitMatrixResult = circuitMatrix

        // When
        let result = adapter.apply(components: (.matrix(matrix: gateMatrix), gateInputs),
                                   toStatevector: vector)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, qubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixBaseMatrix?.rawMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixInputs, gateInputs)

        let expectedVector = try! Vector([Complex.zero, Complex.one, Complex.zero, Complex.zero])
        XCTAssertEqual(result, expectedVector)
    }

    static var allTests = [
        ("testMatrixFactoryReturnsMatrix_applying_returnValue",
         testMatrixFactoryReturnsMatrix_applying_returnValue),
        ("testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne)
    ]
}
