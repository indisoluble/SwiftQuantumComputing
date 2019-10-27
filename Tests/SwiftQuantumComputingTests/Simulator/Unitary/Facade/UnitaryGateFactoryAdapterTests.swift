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

    let gateFactory = SimulatorQuantumGateFactoryTestDouble()
    let qubitCount = 1
    let simulatorGate = SimulatorGateTestDouble()
    let matrix = Matrix.makeNot()
    let inputs = [0]

    // MARK: - Tests

    func testSimulatorGateThatThrowsError_applying_throwError() {
        // Given
        let adapter = UnitaryGateFactoryAdapter(gateFactory: gateFactory)

        // Then
        XCTAssertThrowsError(try adapter.makeGate(qubitCount: qubitCount,
                                                  simulatorGate: simulatorGate))
        XCTAssertEqual(simulatorGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
    }

    func testGateFactoryThatThrowsError_applying_throwError() {
        // Given
        let adapter = UnitaryGateFactoryAdapter(gateFactory: gateFactory)

        simulatorGate.extractInputsResult = inputs
        simulatorGate.extractMatrixResult = matrix

        // Then
        XCTAssertThrowsError(try adapter.makeGate(qubitCount: qubitCount,
                                                  simulatorGate: simulatorGate))

        XCTAssertEqual(simulatorGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
    }

    func testGateFactoryReturnsGate_applying_returnValue() {
        // Given
        let adapter = UnitaryGateFactoryAdapter(gateFactory: gateFactory)

        simulatorGate.extractInputsResult = inputs
        simulatorGate.extractMatrixResult = matrix

        gateFactory.makeGateResult = try! QuantumGate(matrix: Matrix.makeNot())

        // When
        let result = try? adapter.makeGate(qubitCount: qubitCount, simulatorGate: simulatorGate)

        // Then
        XCTAssertEqual(simulatorGate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, qubitCount)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertEqual(result?.unitary, Matrix.makeNot())
    }

    static var allTests = [
        ("testSimulatorGateThatThrowsError_applying_throwError",
         testSimulatorGateThatThrowsError_applying_throwError),
        ("testGateFactoryThatThrowsError_applying_throwError",
         testGateFactoryThatThrowsError_applying_throwError),
        ("testGateFactoryReturnsGate_applying_returnValue",
         testGateFactoryReturnsGate_applying_returnValue)
    ]
}
