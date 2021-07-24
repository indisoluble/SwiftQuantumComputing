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
    let initialCircuitDensityMatrix = CircuitDensityMatrixTestDouble()
    let qubitCount = 2
    let gates = [Gate.hadamard(target: 0), Gate.not(target: 0)]
    let unitarySimulator = UnitarySimulatorTestDouble()
    let statevectorSimulator = StatevectorSimulatorTestDouble()
    let densityMatrixSimulator = DensityMatrixSimulatorTestDouble()

    // MARK: - Tests

    func testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)

        let expectedResult = CircuitStatevectorTestDouble()
        statevectorSimulator.applyStateResult = expectedResult

        // When
        let result = try? facade.statevector(withInitialState: initialCircuitStatevector).get()

        // Then
        let lastApplyInitialStatevector = statevectorSimulator.lastApplyStateInitialState
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
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)
        statevectorSimulator.applyStateError = .resultingStatevectorAdditionOfSquareModulusIsNotEqualToOne

        // When
        var error: StatevectorError?
        if case .failure(let e) = facade.statevector(withInitialState: initialCircuitStatevector) {
            error = e
        }

        // Then
        let lastApplyInitialStatevector = statevectorSimulator.lastApplyStateInitialState
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
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)

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
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)
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

    func testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)

        let expectedResult = CircuitDensityMatrixTestDouble()
        densityMatrixSimulator.applyStateResult = expectedResult

        // When
        let result = try? facade.densityMatrix(withInitialState: initialCircuitDensityMatrix).get()

        // Then
        let lastApplyInitialDensityMatrix = densityMatrixSimulator.lastApplyStateInitialState
        let lastDensityMatrixGates = densityMatrixSimulator.lastApplyStateCircuit

        XCTAssertEqual(densityMatrixSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialDensityMatrix as AnyObject? === initialCircuitDensityMatrix)
        XCTAssertEqual(lastDensityMatrixGates, gates)
        XCTAssertTrue(result as AnyObject? === expectedResult)
    }

    func testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError() {
        // Given
        let facade = CircuitFacade(gates: gates,
                                   unitarySimulator: unitarySimulator,
                                   statevectorSimulator: statevectorSimulator,
                                   densityMatrixSimulator: densityMatrixSimulator)
        densityMatrixSimulator.applyStateError = .resultingDensityMatrixEigenvaluesDoesNotAddUpToOne

        // When
        var error: DensityMatrixError?
        if case .failure(let e) = facade.densityMatrix(withInitialState: initialCircuitDensityMatrix) {
            error = e
        }

        // Then
        let lastApplyInitialDensityMatrix = densityMatrixSimulator.lastApplyStateInitialState
        let lastDensityMatrixGates = densityMatrixSimulator.lastApplyStateCircuit

        XCTAssertEqual(densityMatrixSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialDensityMatrix as AnyObject? === initialCircuitDensityMatrix)
        XCTAssertEqual(lastDensityMatrixGates, gates)
        XCTAssertEqual(error, .resultingDensityMatrixEigenvaluesDoesNotAddUpToOne)
    }

    static var allTests = [
        ("testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator",
         testAnyCircuit_circuitStatevector_forwardCallToStatevectorSimulator),
        ("testAnyCircuitAndStatevectorSimulatorThatThrowsError_circuitStatevector_forwardCallToStatevectorSimulatorAndReturnError",
         testAnyCircuitAndStatevectorSimulatorThatThrowsError_circuitStatevector_forwardCallToStatevectorSimulatorAndReturnError),
        ("testAnyCircuit_unitary_forwardCallToUnitarySimulator",
         testAnyCircuit_unitary_forwardCallToUnitarySimulator),
        ("testAnyCircuitAndUnitarySimulatorThatThrowsError_unitary_forwardCallToUnitarySimulatorAndReturnError",
         testAnyCircuitAndUnitarySimulatorThatThrowsError_unitary_forwardCallToUnitarySimulatorAndReturnError),
        ("testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator",
         testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator),
        ("testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError",
         testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError)
    ]
}
