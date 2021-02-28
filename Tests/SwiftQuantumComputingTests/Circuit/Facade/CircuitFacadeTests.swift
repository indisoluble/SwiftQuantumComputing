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

    let initialCircuitStatevector = CircuitStatevectorTestDouble()
    let qubitCount = 2
    let gates = [Gate.hadamard(target: 0), Gate.not(target: 0)]
    let unitarySimulator = UnitarySimulatorTestDouble()
    let statevectorSimulator = StatevectorSimulatorTestDouble()

    // MARK: - Tests

    func testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)

        let expectedResult = CircuitStatevectorTestDouble()
        statevectorSimulator.applyStateResult = expectedResult

        // When
        let result = try? facade.statevector(withInitialStatevector: initialCircuitStatevector).get()

        // Then
        let lastApplyInitialStatevector = statevectorSimulator.lastApplyStateInitialStatevector
        let lastStatevectorGates = statevectorSimulator.lastApplyStateCircuit

        XCTAssertEqual(statevectorSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialStatevector as AnyObject? === initialCircuitStatevector)
        XCTAssertEqual(lastStatevectorGates, gates)
        XCTAssertTrue(result as AnyObject? === expectedResult)
    }

    func testAnyCircuitAndStatevectorSimulatorThatThrowsError_circuitStatevector_forwardCallToStatevectorSimulatorAndReturnError() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)
        statevectorSimulator.applyStateError = .resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne

        // When
        var error: StatevectorError?
        if case .failure(let e) = facade.statevector(withInitialStatevector: initialCircuitStatevector) {
            error = e
        }

        // Then
        let lastApplyInitialStatevector = statevectorSimulator.lastApplyStateInitialStatevector
        let lastStatevectorGates = statevectorSimulator.lastApplyStateCircuit

        XCTAssertEqual(statevectorSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialStatevector as AnyObject? === initialCircuitStatevector)
        XCTAssertEqual(lastStatevectorGates, gates)
        XCTAssertEqual(error, .resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne)
    }

    func testAnyCircuit_unitary_forwardCallToUnitarySimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)

        let expectedResult = try! Matrix([[.zero, .one], [.one, .zero]])
        unitarySimulator.unitaryResult = expectedResult

        // When
        let result = try? facade.unitary(withQubitCount: qubitCount).get()

        // Then
        let lastUnitaryQubitCount = unitarySimulator.lastUnitaryQubitCount
        let lastUnitaryGates = unitarySimulator.lastUnitaryCircuit

        XCTAssertEqual(unitarySimulator.unitaryCount, 1)
        XCTAssertEqual(lastUnitaryQubitCount, qubitCount)
        XCTAssertEqual(lastUnitaryGates, gates)
        XCTAssertEqual(result, expectedResult)
    }

    func testAnyCircuitAndUnitarySimulatorThatThrowsError_unitary_forwardCallToUnitarySimulatorAndReturnError() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator)
        unitarySimulator.unitaryError = .resultingMatrixIsNotUnitary

        // When
        var error: UnitaryError?
        if case .failure(let e) = facade.unitary(withQubitCount: qubitCount) {
            error = e
        }

        // Then
        let lastUnitaryQubitCount = unitarySimulator.lastUnitaryQubitCount
        let lastUnitaryGates = unitarySimulator.lastUnitaryCircuit

        XCTAssertEqual(unitarySimulator.unitaryCount, 1)
        XCTAssertEqual(lastUnitaryQubitCount, qubitCount)
        XCTAssertEqual(lastUnitaryGates, gates)
        XCTAssertEqual(error, .resultingMatrixIsNotUnitary)
    }

    static var allTests = [
        ("testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator",
         testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator),
        ("testAnyCircuitAndStatevectorSimulatorThatThrowsError_circuitStatevector_forwardCallToStatevectorSimulatorAndReturnError",
         testAnyCircuitAndStatevectorSimulatorThatThrowsError_circuitStatevector_forwardCallToStatevectorSimulatorAndReturnError),
        ("testAnyCircuit_unitary_forwardCallToUnitarySimulator",
         testAnyCircuit_unitary_forwardCallToUnitarySimulator),
        ("testAnyCircuitAndUnitarySimulatorThatThrowsError_unitary_forwardCallToUnitarySimulatorAndReturnError",
         testAnyCircuitAndUnitarySimulatorThatThrowsError_unitary_forwardCallToUnitarySimulatorAndReturnError)
    ]
}
