//
//  UnitaryGateAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/10/2019.
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

class UnitaryGateAdapterTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()
    let simulatorGate = SimulatorGateTestDouble()
    let matrix = Matrix.makeHadamard()
    let matrixQubitCount = 1

    // MARK: - Tests

    func testNonSquareMatrix_init_throwError() {
        // Given
        let nonSquareMatrix = try! Matrix([[Complex(0), Complex(1)]])

        // Then
        XCTAssertThrowsError(try UnitaryGateAdapter(matrix: nonSquareMatrix,
                                                    matrixFactory: matrixFactory))
    }

    func testSquareMatrixWithNotPowerOfTwoRowCount_init_throwError() {
        // Given
        let notPowerOfTwoMatrix = try! Matrix([[Complex(0), Complex(1), Complex(1)],
                                               [Complex(0), Complex(1), Complex(1)],
                                               [Complex(0), Complex(1), Complex(1)]])

        // Then
        XCTAssertThrowsError(try UnitaryGateAdapter(matrix: notPowerOfTwoMatrix,
                                                    matrixFactory: matrixFactory))
    }

    func testValidMatrix_init_returnValue() {
        // When
        let result = try? UnitaryGateAdapter(matrix: matrix, matrixFactory: matrixFactory)

        // Then
        XCTAssertNotNil(result)
    }

    func testNonUnitaryMatrix_unitary_throwError() {
        // Given
        let nonUnitaryMatrix = try! Matrix([[Complex(0), Complex(1)],
                                            [Complex(0), Complex(0)]])
        let adapter = try! UnitaryGateAdapter(matrix: nonUnitaryMatrix,
                                              matrixFactory: matrixFactory)

        // Then
        XCTAssertThrowsError(try adapter.unitary())
    }

    func testValidMatrix_unitary_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: matrix, matrixFactory: matrixFactory)

        // When
        let result = try? adapter.unitary()

        // Then
        XCTAssertEqual(result, matrix)
    }

    func testMatrixFactoryThatThrowsError_applying_throwError() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: matrix, matrixFactory: matrixFactory)

        // Then
        XCTAssertThrowsError(try adapter.applying(simulatorGate))
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, matrixQubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === simulatorGate)
        } else {
            XCTAssert(false)
        }
    }

    func testMatrixFactoryReturnsMatrix_applying_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: matrix, matrixFactory: matrixFactory)

        matrixFactory.makeCircuitMatrixResult = Matrix.makeNot()

        // When
        let result = try? adapter.applying(simulatorGate)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, matrixQubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === simulatorGate)
        } else {
            XCTAssert(false)
        }

        let expectedUnitary = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex(1), Complex(-1)],
                                                                    [Complex(1), Complex(1)]])))
        XCTAssertEqual(try? result?.unitary(), expectedUnitary)
    }

    func testMatrixFactoryReturnsOtherMatrix_applying_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: Matrix.makeNot(), matrixFactory: matrixFactory)

        matrixFactory.makeCircuitMatrixResult = matrix

        // When
        let result = try? adapter.applying(simulatorGate)

        // Then
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, matrixQubitCount)
        if let appliedGate = matrixFactory.lastMakeCircuitMatrixGate as? SimulatorGateTestDouble {
            XCTAssertTrue(appliedGate === simulatorGate)
        } else {
            XCTAssert(false)
        }

        let expectedUnitary = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex(1), Complex(1)],
                                                                    [Complex(-1), Complex(1)]])))
        XCTAssertEqual(try? result?.unitary(), expectedUnitary)
    }

    static var allTests = [
        ("testNonSquareMatrix_init_throwError",
         testNonSquareMatrix_init_throwError),
        ("testSquareMatrixWithNotPowerOfTwoRowCount_init_throwError",
         testSquareMatrixWithNotPowerOfTwoRowCount_init_throwError),
        ("testValidMatrix_init_returnValue",
         testValidMatrix_init_returnValue),
        ("testNonUnitaryMatrix_unitary_throwError",
         testNonUnitaryMatrix_unitary_throwError),
        ("testValidMatrix_unitary_returnValue",
         testValidMatrix_unitary_returnValue),
        ("testMatrixFactoryThatThrowsError_applying_throwError",
         testMatrixFactoryThatThrowsError_applying_throwError),
        ("testMatrixFactoryReturnsMatrix_applying_returnValue",
         testMatrixFactoryReturnsMatrix_applying_returnValue),
        ("testMatrixFactoryReturnsOtherMatrix_applying_returnValue",
         testMatrixFactoryReturnsOtherMatrix_applying_returnValue)
    ]
}
