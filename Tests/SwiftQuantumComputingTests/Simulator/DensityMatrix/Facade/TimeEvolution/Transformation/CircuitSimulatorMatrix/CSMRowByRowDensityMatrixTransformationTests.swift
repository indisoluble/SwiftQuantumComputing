//
//  CSMRowByRowDensityMatrixTransformationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/08/2021.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class CSMRowByRowDensityMatrixTransformationTests: XCTestCase {

    // MARK: - Tests

    func testMaxCalculationConcurrencyEqualToZero_init_throwException() {
        // Then
        XCTAssertThrowsError(try CSMRowByRowDensityMatrixTransformation(calculationConcurrency: 0,
                                                                        expansionConcurrency: 1))
    }

    func testMaxExpansionConcurrencyEqualToZero_init_throwException() {
        // Then
        XCTAssertThrowsError(try CSMRowByRowDensityMatrixTransformation(calculationConcurrency: 1,
                                                                        expansionConcurrency: 0))
    }

    func testMatrixFactoryReturnsMatrix_applying_returnValue() {
        // Given
        let adapter = try! CSMRowByRowDensityMatrixTransformation(calculationConcurrency: 1,
                                                                  expansionConcurrency: 1)

        let cases = [
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[.one, .zero],
                     [.zero, .zero]]
                ),
                try! Matrix(
                    [[.zero, .zero],
                     [.zero, .one]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[.zero, .zero],
                     [.zero, .one]]
                ),
                try! Matrix(
                    [[.one, .zero],
                     [.zero, .zero]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[Complex(1.0 / 2.0), Complex(1.0 / 2.0)],
                     [Complex(1.0 / 2.0), Complex(1.0 / 2.0)]]
                ),
                try! Matrix(
                    [[Complex(1.0 / 2.0), Complex(1.0 / 2.0)],
                     [Complex(1.0 / 2.0), Complex(1.0 / 2.0)]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[.i, .zero],
                     [.zero, .zero]]
                ),
                try! Matrix(
                    [[.zero, .zero],
                     [.zero, .i]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeHadamard(),
                                       inputs: [0]),
                try! Matrix(
                    [[.one, .zero],
                     [.zero, .zero]]
                ),
                try! Matrix(
                    [[Complex(1.0 / 2.0), Complex(1.0 / 2.0)],
                     [Complex(1.0 / 2.0), Complex(1.0 / 2.0)]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 1,
                                       baseMatrix: Matrix.makeHadamard(),
                                       inputs: [0]),
                try! Matrix(
                    [[.i, .zero],
                     [.zero, .zero]]
                ),
                try! Matrix(
                    [[Complex(1.0 / 2.0) * .i, Complex(1.0 / 2.0) * .i],
                     [Complex(1.0 / 2.0) * .i, Complex(1.0 / 2.0) * .i]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 2,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[.one, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero]]
                ),
                try! Matrix(
                    [[.zero, .zero, .zero, .zero],
                     [.zero, .one, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 2,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [1]),
                try! Matrix(
                    [[.one, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero]]
                ),
                try! Matrix(
                    [[.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .one, .zero],
                     [.zero, .zero, .zero, .zero]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 2,
                                       baseMatrix: Matrix.makeNot(),
                                       inputs: [0]),
                try! Matrix(
                    [[Complex(1.0 / 2.0), .zero, .zero, Complex(1.0 / 2.0)],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [Complex(1.0 / 2.0), .zero, .zero, Complex(1.0 / 2.0)]]
                ),
                try! Matrix(
                    [[.zero, .zero, .zero, .zero],
                     [.zero, Complex(1.0 / 2.0), Complex(1.0 / 2.0), .zero],
                     [.zero, Complex(1.0 / 2.0), Complex(1.0 / 2.0), .zero],
                     [.zero, .zero, .zero, .zero]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 2,
                                       baseMatrix: Matrix.makeHadamard(),
                                       inputs: [1]),
                try! Matrix(
                    [[.one, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero]]
                ),
                try! Matrix(
                    [[Complex(1.0 / 2.0), .zero, Complex(1.0 / 2.0), .zero],
                     [.zero, .zero, .zero, .zero],
                     [Complex(1.0 / 2.0), .zero, Complex(1.0 / 2.0), .zero],
                     [.zero, .zero, .zero, .zero]]
                )
            ),
            (
                CircuitSimulatorMatrix(qubitCount: 2,
                                       baseMatrix: Matrix.makeHadamard(),
                                       inputs: [0]),
                try! Matrix(
                    [[.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, .i, .zero],
                     [.zero, .zero, .zero, .zero]]
                ),
                try! Matrix(
                    [[.zero, .zero, .zero, .zero],
                     [.zero, .zero, .zero, .zero],
                     [.zero, .zero, Complex(1.0 / 2.0) * .i, Complex(1.0 / 2.0) * .i],
                     [.zero, .zero, Complex(1.0 / 2.0) * .i, Complex(1.0 / 2.0) * .i]]
                )
            )
        ]

        for (circuitMatrix, matrix, expectedMatrix) in cases {
            // When
            let result = adapter.apply(matrix: circuitMatrix, toDensityMatrix: matrix)

            // Then
            XCTAssertTrue(result.isApproximatelyEqual(to: expectedMatrix,
                                                      absoluteTolerance: SharedConstants.tolerance))
        }
    }

    static var allTests = [
        ("testMaxCalculationConcurrencyEqualToZero_init_throwException",
         testMaxCalculationConcurrencyEqualToZero_init_throwException),
        ("testMaxExpansionConcurrencyEqualToZero_init_throwException",
         testMaxExpansionConcurrencyEqualToZero_init_throwException),
        ("testMatrixFactoryReturnsMatrix_applying_returnValue",
         testMatrixFactoryReturnsMatrix_applying_returnValue)
    ]
}
