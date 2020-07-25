//
//  CircuitMatrixRowStatevectorTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/05/2020.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class CircuitMatrixRowStatevectorTransformationTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_init_throwError() {
        // Then
        XCTAssertThrowsError(try CircuitMatrixRowStatevectorTransformation(matrixFactory: matrixFactory,
                                                                           maxConcurrency: 0))
    }

    func testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2
        var elements = Array(repeating: Complex<Double>.zero, count: Int.pow(2, qubitCount))
        elements[0] = .one

        let vector = try! Vector(elements)
        let adapter = try! CircuitMatrixRowStatevectorTransformation(matrixFactory: matrixFactory,
                                                                     maxConcurrency: 1)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()

        let circuitRow = SimulatorCircuitMatrixFactoryAdapter().makeCircuitMatrixRow(qubitCount: qubitCount,
                                                                                     baseMatrix: gateMatrix,
                                                                                     inputs: gateInputs)
        matrixFactory.makeCircuitMatrixRowResult = circuitRow

        // When
        let result = adapter.apply(gateMatrix: gateMatrix,
                                   toStatevector: vector,
                                   atInputs: gateInputs)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixRowCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixRowQubitCount, qubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixRowBaseMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixRowInputs, gateInputs)

        let expectedVector = try! Vector([.zero, .one, .zero, .zero])
        XCTAssertEqual(result, expectedVector)
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_init_throwError",
         testMaxConcurrencyEqualToZero_init_throwError),
        ("testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne)
    ]
}
