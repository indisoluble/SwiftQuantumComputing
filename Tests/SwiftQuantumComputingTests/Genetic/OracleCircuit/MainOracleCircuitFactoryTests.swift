//
//  MainOracleCircuitFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/02/2019.
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

class MainOracleCircuitFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = MainOracleCircuitFactory()
    let useCase = try! GeneticUseCase(emptyTruthTableQubitCount: 0, circuitOutput: "0")

    // MARK: - Tests

    func testEmptyGeneticCircuit_makeOracleCircuit_returnZeroGatesAndOracleIndexToNil() {
        // Given
        let geneticCircuit: [GeneticGate] = []

        // When
        let fixedGates = try? factory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                        useCase: useCase)

        // Then
        XCTAssertNotNil(fixedGates)
        if let fixedGates = fixedGates {
            XCTAssertEqual(fixedGates.circuit, [])
            XCTAssertNil(fixedGates.oracleAt)
        }
    }

    func testGeneticCircuitWithGateThatReturnNil_makeOracleCircuit_returnNil() {
        // Given
        let geneticGate = GeneticGateTestDouble()
        let geneticCircuit = [geneticGate]

        // Then
        XCTAssertThrowsError(try factory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                           useCase: useCase))
        XCTAssertEqual(geneticGate.makeFixedCount, 1)
    }

    func testGeneticCircuitWithTwoOracles_makeOracleCircuit_returnOnlyOneOracle() {
        // Given
        let oracle = FixedGate.oracle(truthTable: [], target: 0, controls: [])

        let firstOracleGate = GeneticGateTestDouble()
        firstOracleGate.makeFixedResult = (oracle, true)

        let secondOracleGate = GeneticGateTestDouble()
        secondOracleGate.makeFixedResult = (oracle, true)

        let geneticCircuit = [firstOracleGate, secondOracleGate]

        // When
        let fixedGates = try? factory.makeOracleCircuit(geneticCircuit: geneticCircuit,
                                                        useCase: useCase)

        // Then
        XCTAssertEqual(firstOracleGate.makeFixedCount, 1)
        XCTAssertEqual(secondOracleGate.makeFixedCount, 1)
        XCTAssertNotNil(fixedGates)
        if let fixedGates = fixedGates {
            XCTAssertEqual(fixedGates.circuit, [oracle])
            XCTAssertEqual(fixedGates.oracleAt, 0)
        }
    }
}
