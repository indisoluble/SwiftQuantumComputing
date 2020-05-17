//
//  CircuitMatrixElementStatevectorTransformationTests.swift
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class CircuitMatrixElementStatevectorTransformationTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()

    // MARK: - Tests

    func testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2
        var elements = Array(repeating: Complex.zero, count: Int.pow(2, qubitCount))
        elements[0] = Complex.one

        let vector = try! Vector(elements)
        let adapter = CircuitMatrixElementStatevectorTransformation(matrixFactory: matrixFactory)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()

        let circuitElement = SimulatorCircuitMatrixFactoryAdapter().makeCircuitMatrixElement(qubitCount: qubitCount,
                                                                                             baseMatrix: gateMatrix,
                                                                                             inputs: gateInputs)
        matrixFactory.makeCircuitMatrixElementResult = circuitElement

        // When
        let result = adapter.apply(gateMatrix: gateMatrix,
                                   toStatevector: vector,
                                   atInputs: gateInputs)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixElementCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixElementQubitCount, qubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixElementBaseMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixElementInputs, gateInputs)

        let expectedVector = try! Vector([Complex.zero, Complex.one, Complex.zero, Complex.zero])
        XCTAssertEqual(result, expectedVector)
    }

    static var allTests = [
        ("testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedToZeroAndNotMatrix_applyNotMatrixToLeastSignificantQubit_oneHasProbabilityOne)
    ]

}
