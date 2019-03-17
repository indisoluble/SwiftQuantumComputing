//
//  MainGeneticUseCaseEvaluatorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/02/2019.
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

class MainGeneticUseCaseEvaluatorTests: XCTestCase {

    // MARK: - Properties

    let qubitCount = 2
    let useCase = GeneticUseCase(emptyTruthTableQubitCount: 0, circuitOutput: "11")
    let factory = CircuitFactoryTestDouble()
    let oracleFactory = OracleCircuitFactoryTestDouble()
    let oracleCircuit: OracleCircuitFactory.OracleCircuit = ([], 0)
    let geneticCircuit: [GeneticGate] = []
    let circuit = CircuitTestDouble()
    let measures = [0.0, 0.0, 0.0, 1.0]

    // MARK: - Tests

    func testOracleFactoryThatReturnNil_evaluateCircuit_returnNil() {
        // Given
        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: useCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 0)
        XCTAssertEqual(circuit.measureCount, 0)
        XCTAssertNil(prob)
    }

    func testFactoryThatReturnNil_evaluateCircuit_returnNil() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit

        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: useCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 0)
        XCTAssertNil(prob)
    }

    func testCircuitThatReturnNilMeasure_evaluateCircuit_returnNil() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit

        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: useCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertNil(prob)
    }

    func testUseCaseWithNonSensicalOutput_evaluateCircuit_returnNil() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.measureResult = measures

        let nonSensicalUseCase = GeneticUseCase(emptyTruthTableQubitCount: 0,
                                                circuitOutput: "qwerty")

        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: nonSensicalUseCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertNil(prob)
    }

    func testUseCaseWithOutputOutOfRange_evaluateCircuit_returnNil() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.measureResult = measures

        let circuitOutput = String(repeating: "1", count: qubitCount + 1)
        let nonSensicalUseCase = GeneticUseCase(emptyTruthTableQubitCount: 0,
                                                circuitOutput: circuitOutput)

        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: nonSensicalUseCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertNil(prob)
    }

    func testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.measureResult = measures

        let evaluator = MainGeneticUseCaseEvaluator(qubitCount: qubitCount,
                                                    useCase: useCase,
                                                    factory: factory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(prob, 0.0)
    }
}
