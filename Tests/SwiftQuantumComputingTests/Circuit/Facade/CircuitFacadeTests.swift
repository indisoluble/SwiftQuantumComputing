//
//  CircuitFacadeTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 23/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class CircuitFacadeTests: XCTestCase {

    // MARK: - Properties

    let bits = "01"
    let qubitCount = 2
    let gates = [FixedGate.hadamard(target: 0), FixedGate.not(target: 0)]
    let unitarySimulator = UnitarySimulatorTestDouble()
    let statevectorSimulator = StatevectorSimulatorTestDouble()

    // MARK: - Tests

    func testAnyCircuit_statevector_forwardCallToStatevectorSimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)

        let expectedResult = [Complex(0), Complex(1)]
        statevectorSimulator.statevectorResult = try! Vector(expectedResult)

        // When
        let result = try? facade.statevector(afterInputting: bits)

        // Then
        let lastStatevectorBits = statevectorSimulator.lastStatevectorBits
        let lastStatevectorGates = statevectorSimulator.lastStatevectorCircuit as? [FixedGate]

        XCTAssertEqual(statevectorSimulator.statevectorCount, 1)
        XCTAssertEqual(lastStatevectorBits, bits)
        XCTAssertEqual(lastStatevectorGates, gates)
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyCircuit_unitary_forwardCallToUnitarySimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)

        let expectedResult = [[Complex(0), Complex(1)], [Complex(1), Complex(0)]]
        unitarySimulator.unitaryResult = try! Matrix(expectedResult)

        // When
        let result = try? facade.unitary(usingQubitCount: qubitCount)

        // Then
        let lastUnitaryQubitCount = unitarySimulator.lastUnitaryQubitCount
        let lastUnitaryGates = unitarySimulator.lastUnitaryCircuit as? [FixedGate]

        XCTAssertEqual(unitarySimulator.unitaryCount, 1)
        XCTAssertEqual(lastUnitaryQubitCount, qubitCount)
        XCTAssertEqual(lastUnitaryGates, gates)
        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testAnyCircuit_statevector_forwardCallToStatevectorSimulator",
         testAnyCircuit_statevector_forwardCallToStatevectorSimulator),
        ("testAnyCircuit_unitary_forwardCallToUnitarySimulator",
         testAnyCircuit_unitary_forwardCallToUnitarySimulator)
    ]
}
