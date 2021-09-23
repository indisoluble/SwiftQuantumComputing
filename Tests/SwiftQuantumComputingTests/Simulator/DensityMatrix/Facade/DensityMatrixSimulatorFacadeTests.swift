//
//  DensityMatrixSimulatorFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/07/2021.
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

class DensityMatrixSimulatorFacadeTests: XCTestCase {

    // MARK: - Properties

    let evolutionFactory = DensityMatrixTimeEvolutionFactoryTestDouble()
    let densityMatrixFactory = CircuitDensityMatrixFactoryTestDouble()
    let initialCircuitDensityMatrix = CircuitDensityMatrixTestDouble()
    let evolution = DensityMatrixTimeEvolutionTestDouble()
    let firstOperator = Gate.hadamard(target: 0).quantumOperator
    let firstEvolution = DensityMatrixTimeEvolutionTestDouble()
    let secondOperator = Gate.phaseShift(radians: 0, target: 0).quantumOperator
    let secondEvolution = DensityMatrixTimeEvolutionTestDouble()
    let thirdOperator = Gate.not(target: 0).quantumOperator
    let thirdEvolution = DensityMatrixTimeEvolutionTestDouble()
    let densityMatrix = Matrix.makeNot()
    let finalDensityMatrix = CircuitDensityMatrixTestDouble()

    // MARK: - Tests

    func testEvolutionFactoryReturnsEvolutionAndEmptyCircuit_applyState_applyDensityMatrixOnInitialRegister() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution
        evolution.stateResult = densityMatrix

        densityMatrixFactory.makeDensityMatrixResult = finalDensityMatrix

        // When
        let result = try? simulator.apply(circuit: [], to: initialCircuitDensityMatrix).get()

        // Then
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 0)
        XCTAssertEqual(evolution.stateCount, 1)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 1)
        XCTAssertEqual(densityMatrixFactory.lastMakeDensityMatrixMatrix, densityMatrix)
        XCTAssertTrue(result as AnyObject? === finalDensityMatrix)
    }

    func testEvolutionFactoryReturnsEvolutionAndEvolutionThrowsError_applyState_throwError() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution

        // Then
        var error: DensityMatrixError?
        if case .failure(let e) = simulator.apply(circuit: [firstOperator],
                                                  to: initialCircuitDensityMatrix) {
            error = e
        }
        XCTAssertEqual(error,
                       .operatorThrowedError(operator: firstOperator,
                                             error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 1)
        XCTAssertTrue(evolution.lastApplyingQuantumOperator == firstOperator)
        XCTAssertEqual(evolution.stateCount, 0)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 0)
    }

    func testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolution_applyState_applyDensityMatrixOnExpectedEvolution() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution
        evolution.applyingResult = firstEvolution
        firstEvolution.stateResult = densityMatrix

        densityMatrixFactory.makeDensityMatrixResult = finalDensityMatrix

        // When
        let result = try? simulator.apply(circuit: [firstOperator],
                                          to: initialCircuitDensityMatrix).get()

        // Then
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 1)
        XCTAssertTrue(evolution.lastApplyingQuantumOperator == firstOperator)
        XCTAssertEqual(firstEvolution.applyingCount, 0)
        XCTAssertEqual(firstEvolution.stateCount, 1)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 1)
        XCTAssertEqual(densityMatrixFactory.lastMakeDensityMatrixMatrix, densityMatrix)
        XCTAssertTrue(result as AnyObject? === finalDensityMatrix)
    }

    func testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolutionAndDensityMatrixFactoryThrowsError_applyState_throwError() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution
        evolution.applyingResult = firstEvolution
        firstEvolution.stateResult = densityMatrix

        densityMatrixFactory.makeDensityMatrixError = .matrixEigenvaluesDoesNotAddUpToOne

        // Then
        var error: DensityMatrixError?
        if case .failure(let e) = simulator.apply(circuit: [firstOperator],
                                                  to: initialCircuitDensityMatrix) {
            error = e
        }
        XCTAssertEqual(error, .resultingDensityMatrixEigenvaluesDoesNotAddUpToOne)
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 1)
        XCTAssertTrue(evolution.lastApplyingQuantumOperator == firstOperator)
        XCTAssertEqual(firstEvolution.applyingCount, 0)
        XCTAssertEqual(firstEvolution.stateCount, 1)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 1)
        XCTAssertEqual(densityMatrixFactory.lastMakeDensityMatrixMatrix, densityMatrix)
    }

    func testEvolutionFactoryReturnsEvolutionEvolutionReturnsSecondEvolutionButSecondThrowsError_applyState_throwError() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution
        evolution.applyingResult = firstEvolution
        firstEvolution.applyingResult = secondEvolution

        // Then
        var error: DensityMatrixError?
        if case .failure(let e) = simulator.apply(circuit: [firstOperator,
                                                            secondOperator,
                                                            thirdOperator],
                                                  to: initialCircuitDensityMatrix) {
            error = e
        }
        XCTAssertEqual(error,
                       .operatorThrowedError(operator: thirdOperator,
                                             error: .circuitQubitCountHasToBeBiggerThanZero))
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 1)
        XCTAssertTrue(evolution.lastApplyingQuantumOperator == firstOperator)
        XCTAssertEqual(firstEvolution.applyingCount, 1)
        XCTAssertTrue(firstEvolution.lastApplyingQuantumOperator == secondOperator)
        XCTAssertEqual(secondEvolution.applyingCount, 1)
        XCTAssertTrue(secondEvolution.lastApplyingQuantumOperator == thirdOperator)
        XCTAssertEqual(evolution.stateCount, 0)
        XCTAssertEqual(firstEvolution.stateCount, 0)
        XCTAssertEqual(secondEvolution.stateCount, 0)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 0)
    }

    func testEvolutionFactoryReturnsEvolutionAndEvolutionsDoTheSame_applyState_applyDensityMatrixOnExpectedEvolution() {
        // Given
        let simulator = DensityMatrixSimulatorFacade(timeEvolutionFactory: evolutionFactory,
                                                     densityMatrixFactory: densityMatrixFactory)

        evolutionFactory.makeTimeEvolutionResult = evolution
        evolution.applyingResult = firstEvolution
        firstEvolution.applyingResult = secondEvolution
        secondEvolution.applyingResult = thirdEvolution
        thirdEvolution.stateResult = densityMatrix

        densityMatrixFactory.makeDensityMatrixResult = finalDensityMatrix

        // When
        let result = try? simulator.apply(circuit: [firstOperator,
                                                    secondOperator,
                                                    thirdOperator],
                                          to: initialCircuitDensityMatrix).get()

        // Then
        XCTAssertEqual(evolutionFactory.makeTimeEvolutionCount, 1)
        XCTAssertEqual(evolution.applyingCount, 1)
        XCTAssertTrue(evolution.lastApplyingQuantumOperator == firstOperator)
        XCTAssertEqual(firstEvolution.applyingCount, 1)
        XCTAssertTrue(firstEvolution.lastApplyingQuantumOperator == secondOperator)
        XCTAssertEqual(secondEvolution.applyingCount, 1)
        XCTAssertTrue(secondEvolution.lastApplyingQuantumOperator == thirdOperator)
        XCTAssertEqual(evolution.stateCount, 0)
        XCTAssertEqual(firstEvolution.stateCount, 0)
        XCTAssertEqual(secondEvolution.stateCount, 0)
        XCTAssertEqual(thirdEvolution.stateCount, 1)
        XCTAssertEqual(densityMatrixFactory.makeDensityMatrixCount, 1)
        XCTAssertEqual(densityMatrixFactory.lastMakeDensityMatrixMatrix, densityMatrix)
        XCTAssertTrue(result as AnyObject? === finalDensityMatrix)
    }

    static var allTests = [
        ("testEvolutionFactoryReturnsEvolutionAndEmptyCircuit_applyState_applyDensityMatrixOnInitialRegister",
         testEvolutionFactoryReturnsEvolutionAndEmptyCircuit_applyState_applyDensityMatrixOnInitialRegister),
        ("testEvolutionFactoryReturnsEvolutionAndEvolutionThrowsError_applyState_throwError",
         testEvolutionFactoryReturnsEvolutionAndEvolutionThrowsError_applyState_throwError),
        ("testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolution_applyState_applyDensityMatrixOnExpectedEvolution",
         testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolution_applyState_applyDensityMatrixOnExpectedEvolution),
        ("testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolutionAndDensityMatrixFactoryThrowsError_applyState_throwError",
         testEvolutionFactoryReturnsEvolutionAndEvolutionReturnsAnotherEvolutionAndDensityMatrixFactoryThrowsError_applyState_throwError),
        ("testEvolutionFactoryReturnsEvolutionEvolutionReturnsSecondEvolutionButSecondThrowsError_applyState_throwError",
         testEvolutionFactoryReturnsEvolutionEvolutionReturnsSecondEvolutionButSecondThrowsError_applyState_throwError),
        ("testEvolutionFactoryReturnsEvolutionAndEvolutionsDoTheSame_applyState_applyDensityMatrixOnExpectedEvolution",
         testEvolutionFactoryReturnsEvolutionAndEvolutionsDoTheSame_applyState_applyDensityMatrixOnExpectedEvolution)
    ]

}
