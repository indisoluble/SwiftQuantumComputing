//
//  UnitaryGateFactoryAdapterTests.swift
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

class UnitaryGateFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let matrixFactory = SimulatorCircuitMatrixFactoryTestDouble()
    let qubitCount = 1
    let simulatorGate = SimulatorGateTestDouble()

    // MARK: - Tests

    func testGateThatThrowsError_applying_throwError() {
        // Given
        let adapter = UnitaryGateFactoryAdapter(matrixFactory: matrixFactory)

        // Then
        XCTAssertThrowsError(try adapter.makeGate(qubitCount: qubitCount,
                                                  simulatorGate: simulatorGate))

        XCTAssertEqual(simulatorGate.extractCount, 1)
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 0)
    }

    func testGateReturnsComponents_applying_returnValue() {
        // Given
        let adapter = UnitaryGateFactoryAdapter(matrixFactory: matrixFactory)

        let gateInputs = [0]
        let gateMatrix = Matrix.makeNot()
        simulatorGate.extractInputsResult = gateInputs
        simulatorGate.extractMatrixResult = gateMatrix

        let circuitMatrix = Matrix.makeHadamard()
        matrixFactory.makeCircuitMatrixResult = circuitMatrix

        // When
        let result = try? adapter.makeGate(qubitCount: qubitCount, simulatorGate: simulatorGate)

        // Then
        XCTAssertEqual(simulatorGate.extractCount, 1)
        XCTAssertEqual(matrixFactory.makeCircuitMatrixCount, 1)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixQubitCount, qubitCount)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixBaseMatrix, gateMatrix)
        XCTAssertEqual(matrixFactory.lastMakeCircuitMatrixInputs, gateInputs)
        XCTAssertEqual(try? result?.unitary(), circuitMatrix)
    }

    static var allTests = [
        ("testGateThatThrowsError_applying_throwError",
         testGateThatThrowsError_applying_throwError),
        ("testGateReturnsComponents_applying_returnValue",
         testGateReturnsComponents_applying_returnValue)
    ]
}
