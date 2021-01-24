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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class UnitaryGateAdapterTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()
    let simulatorGate = SimulatorGateTestDouble()
    let gateInputs = [0]
    let gateMatrix = Matrix.makeHadamard()
    let simulatorMatrix = Matrix.makeHadamard()
    let otherSimulatorMatrix = Matrix.makeNot()
    let matrixQubitCount = 1

    // MARK: - Tests

    func testNonSquareMatrix_init_throwError() {
        // Given
        let nonSquareMatrix = try! Matrix([[.zero, .one]])

        // Then
        XCTAssertThrowsError(try UnitaryGateAdapter(matrix: nonSquareMatrix,
                                                    matrixFactory: matrixFactory))
    }

    func testSquareMatrixWithNotPowerOfTwoRowCount_init_throwError() {
        // Given
        let notPowerOfTwoMatrix = try! Matrix([[.zero, .one, .one],
                                               [.zero, .one, .one],
                                               [.zero, .one, .one]])

        // Then
        XCTAssertThrowsError(try UnitaryGateAdapter(matrix: notPowerOfTwoMatrix,
                                                    matrixFactory: matrixFactory))
    }

    func testValidMatrix_init_returnValue() {
        // When
        let result = try? UnitaryGateAdapter(matrix: simulatorMatrix, matrixFactory: matrixFactory)

        // Then
        XCTAssertNotNil(result)
    }

    func testNonUnitaryMatrix_unitary_throwError() {
        // Given
        let nonUnitaryMatrix = try! Matrix([[.zero, .one], [.zero, .zero]])
        let adapter = try! UnitaryGateAdapter(matrix: nonUnitaryMatrix,
                                              matrixFactory: matrixFactory)

        // Then
        var error: UnitaryMatrixError?
        if case .failure(let e) = adapter.unitary() {
            error = e
        }
        XCTAssertEqual(error, .matrixIsNotUnitary)
    }

    func testValidMatrix_unitary_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: simulatorMatrix, matrixFactory: matrixFactory)

        // When
        let result = try? adapter.unitary().get()

        // Then
        XCTAssertEqual(result, simulatorMatrix)
    }

    func testGateThatThrowsError_applying_throwError() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: simulatorMatrix, matrixFactory: matrixFactory)

        // Then
        var error: GateError?
        if case .failure(let e) = adapter.applying(simulatorGate) {
            error = e
        }
        XCTAssertEqual(error, .gateControlsCanNotBeAnEmptyList)
        XCTAssertEqual(simulatorGate.extractComponentsCount, 1)
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 0)
    }

    func testMatrixFactoryReturnsMatrix_applying_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: Matrix.makeNot(),
                                              matrixFactory: matrixFactory)

        simulatorGate.extractComponentsInputsResult = gateInputs
        simulatorGate.extractComponentsMatrixResult = .matrix(matrix: gateMatrix)

        let circuitMatrix = SimulatorMatrixTestDouble()
        circuitMatrix.rawMatrixResult = simulatorMatrix

        matrixFactory.makeCircuitMatrixResult = circuitMatrix

        // When
        let result = try? adapter.applying(simulatorGate).get()

        // Then
        XCTAssertEqual(simulatorGate.extractComponentsCount, 1)
        XCTAssertEqual(simulatorGate.lastExtractComponentsQubitCount, matrixQubitCount)
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, matrixQubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixBaseMatrix?.rawMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixInputs, gateInputs)
        XCTAssertEqual(circuitMatrix.rawMatrixCount, 1)

        let expectedUnitary = (Complex(1 / sqrt(2)) * (try! Matrix([[.one, .one],
                                                                    [Complex(-1), .one]])))
        XCTAssertEqual(try? result?.unitary().get(), expectedUnitary)
    }

    func testMatrixFactoryReturnsOtherMatrix_applying_returnValue() {
        // Given
        let adapter = try! UnitaryGateAdapter(matrix: simulatorMatrix, matrixFactory: matrixFactory)

        simulatorGate.extractComponentsInputsResult = gateInputs
        simulatorGate.extractComponentsMatrixResult = .matrix(matrix: gateMatrix)

        let otherCircuitMatrix = SimulatorMatrixTestDouble()
        otherCircuitMatrix.rawMatrixResult = otherSimulatorMatrix

        matrixFactory.makeCircuitMatrixResult = otherCircuitMatrix

        // When
        let result = try? adapter.applying(simulatorGate).get()

        // Then
        XCTAssertEqual(simulatorGate.extractComponentsCount, 1)
        XCTAssertEqual(simulatorGate.lastExtractComponentsQubitCount, matrixQubitCount)
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, matrixQubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixBaseMatrix?.rawMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixInputs, gateInputs)
        XCTAssertEqual(otherCircuitMatrix.rawMatrixCount, 1)

        let expectedUnitary = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex.one, Complex(-1)],
                                                                    [Complex.one, Complex.one]])))
        XCTAssertEqual(try? result?.unitary().get(), expectedUnitary)
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
        ("testGateThatThrowsError_applying_throwError",
         testGateThatThrowsError_applying_throwError),
        ("testMatrixFactoryReturnsMatrix_applying_returnValue",
         testMatrixFactoryReturnsMatrix_applying_returnValue),
        ("testMatrixFactoryReturnsOtherMatrix_applying_returnValue",
         testMatrixFactoryReturnsOtherMatrix_applying_returnValue)
    ]
}
