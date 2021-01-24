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

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_init_throwError() {
        // Given
        let rowFactory = SimulatorCircuitRowFactoryTestDouble()

        // Then
        XCTAssertThrowsError(try CircuitMatrixRowStatevectorTransformation(rowFactory: rowFactory,
                                                                           maxConcurrency: 0))
    }

    func testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let rowFactory = SimulatorCircuitRowFactoryTestDouble()

        let qubitCount = 2
        var elements = Array(repeating: Complex<Double>.zero, count: Int.pow(2, qubitCount))
        elements[0] = .one

        let vector = try! Vector(elements)
        let adapter = try! CircuitMatrixRowStatevectorTransformation(rowFactory: rowFactory,
                                                                     maxConcurrency: 1)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()

        let circuitRow = SimulatorCircuitRowFactoryAdapter().makeCircuitMatrixRow(qubitCount: qubitCount,
                                                                                  baseMatrix: gateMatrix,
                                                                                  inputs: gateInputs)
        rowFactory.makeCircuitMatrixRowResult = circuitRow

        // When
        let result = adapter.apply(components: (.matrix(matrix: gateMatrix), gateInputs),
                                   toStatevector: vector)

        // Then
        XCTAssertEqual(rowFactory.makeCircuitMatrixRowCount, 1)
        XCTAssertEqual(rowFactory.lastMakeCircuitMatrixRowQubitCount, qubitCount)
        XCTAssertEqual(rowFactory.lastMakeCircuitMatrixRowBaseMatrix?.rawMatrix, gateMatrix)
        XCTAssertEqual(rowFactory.lastMakeCircuitMatrixRowInputs, gateInputs)

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
