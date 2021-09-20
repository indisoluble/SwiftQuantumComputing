//
//  NoiseCircuitFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/09/2021.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class NoiseCircuitFacadeTests: XCTestCase {

    // MARK: - Properties

    let initialCircuitDensityMatrix = CircuitDensityMatrixTestDouble()
    let quantumOperators = [Gate.hadamard(target: 0).quantumOperator,
                            Gate.not(target: 0).quantumOperator]
    let densityMatrixSimulator = DensityMatrixSimulatorTestDouble()
    
    // MARK: - Tests

    func testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator() {
        // Given
        let facade = NoiseCircuitFacade(quantumOperators: quantumOperators,
                                        densityMatrixSimulator: densityMatrixSimulator)

        let expectedResult = CircuitDensityMatrixTestDouble()
        densityMatrixSimulator.applyStateResult = expectedResult

        // When
        let result = try? facade.densityMatrix(withInitialState: initialCircuitDensityMatrix).get()

        // Then
        let lastApplyInitialDensityMatrix = densityMatrixSimulator.lastApplyStateInitialState
        let lastDensityMatrixQuantumOperators = densityMatrixSimulator.lastApplyStateCircuit

        XCTAssertEqual(densityMatrixSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialDensityMatrix as AnyObject? === initialCircuitDensityMatrix)
        XCTAssertEqual(lastDensityMatrixQuantumOperators, quantumOperators)
        XCTAssertTrue(result as AnyObject? === expectedResult)
    }

    func testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError() {
        // Given
        let facade = NoiseCircuitFacade(quantumOperators: quantumOperators,
                                        densityMatrixSimulator: densityMatrixSimulator)
        densityMatrixSimulator.applyStateError = .resultingDensityMatrixEigenvaluesDoesNotAddUpToOne

        // When
        var error: DensityMatrixError?
        if case .failure(let e) = facade.densityMatrix(withInitialState: initialCircuitDensityMatrix) {
            error = e
        }

        // Then
        let lastApplyInitialDensityMatrix = densityMatrixSimulator.lastApplyStateInitialState
        let lastDensityMatrixQuantumOperators = densityMatrixSimulator.lastApplyStateCircuit

        XCTAssertEqual(densityMatrixSimulator.applyStateCount, 1)
        XCTAssertTrue(lastApplyInitialDensityMatrix as AnyObject? === initialCircuitDensityMatrix)
        XCTAssertEqual(lastDensityMatrixQuantumOperators, quantumOperators)
        XCTAssertEqual(error, .resultingDensityMatrixEigenvaluesDoesNotAddUpToOne)
    }


    static var allTests = [
        ("testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator",
         testAnyCircuit_densityMatrix_forwardCallToDensityMatrixSimulator),
        ("testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError",
         testAnyCircuitAndStatevectorSimulatorThatThrowsError_densityMatrix_forwardCallToDensityMatrixSimulatorAndReturnError)
    ]
}
