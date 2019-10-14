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

    let register = try! Register(bits: "0")
    let gateFactory = StatevectorRegisterGateFactoryTestDouble()
    let gate = SimulatorGateTestDouble()
    let matrix = Matrix.makeNot()
    let inputs = [0]
    let registerGate = try! RegisterGate(matrix: Matrix.makeNot())

    // MARK: - Tests

    func testGateThatThrowsError_applying_throwError() {
        // Given
        let adapter = StatevectorRegisterAdapter(register: register, gateFactory: gateFactory)

        // Then
        XCTAssertThrowsError(try adapter.applying(gate))
        XCTAssertEqual(gate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 0)
    }

    func testGateFactoryThatThrowsError_applying_throwError() {
        // Given
        let adapter = StatevectorRegisterAdapter(register: register, gateFactory: gateFactory)

        gate.extractInputsResult = inputs
        gate.extractMatrixResult = matrix

        // Then
        XCTAssertThrowsError(try adapter.applying(gate))
        XCTAssertEqual(gate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, register.qubitCount)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
    }

    func testGateFactoryReturnsGate_applying_returnValue() {
        // Given
        let adapter = StatevectorRegisterAdapter(register: register, gateFactory: gateFactory)

        gate.extractInputsResult = inputs
        gate.extractMatrixResult = matrix

        gateFactory.makeGateResult = registerGate

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(gate.extractCount, 1)
        XCTAssertEqual(gateFactory.makeGateCount, 1)
        XCTAssertEqual(gateFactory.lastMakeGateQubitCount, register.qubitCount)
        XCTAssertEqual(gateFactory.lastMakeGateMatrix, matrix)
        XCTAssertEqual(gateFactory.lastMakeGateInputs, inputs)
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testGateThatThrowsError_applying_throwError",
         testGateThatThrowsError_applying_throwError),
        ("testGateFactoryThatThrowsError_applying_throwError",
         testGateFactoryThatThrowsError_applying_throwError),
        ("testGateFactoryReturnsGate_applying_returnValue",
         testGateFactoryReturnsGate_applying_returnValue)
    ]
}
