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

    let useCase = try! GeneticUseCase(truthTable: [], circuitInput: "01", circuitOutput: "11")
    let factory = CircuitFactoryTestDouble()
    let oracleFactory = OracleCircuitFactoryTestDouble()
    let oracleCircuit: OracleCircuitFactory.OracleCircuit = ([], 0)
    let geneticCircuit: [GeneticGate] = []
    let circuit = CircuitTestDouble()
    let measures = [0.0, 0.0, 0.0, 1.0]

    // MARK: - Tests

    func testOracleFactoryThatThrowException_evaluateCircuit_throwException() {
        // Given
        let evaluator = try! MainGeneticUseCaseEvaluator(useCase: useCase,
                                                         factory: factory,
                                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try evaluator.evaluateCircuit(geneticCircuit))
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 0)
        XCTAssertEqual(circuit.measureCount, 0)
    }

    func testCircuitThatThrowException_evaluateCircuit_throwException() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.gatesResult = [FixedGate.not(target: 0)]

        let evaluator = try! MainGeneticUseCaseEvaluator(useCase: useCase,
                                                         factory: factory,
                                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try evaluator.evaluateCircuit(geneticCircuit))
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureBits, useCase.circuit.input)
    }

    func testUseCaseWithNonSensicalOutput_evaluateCircuit_throwException() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.measureResult = measures

        let nonSensicalUseCase = try! GeneticUseCase(emptyTruthTableQubitCount: 0,
                                                     circuitOutput: "qwerty")

        let evaluator = try! MainGeneticUseCaseEvaluator(useCase: nonSensicalUseCase,
                                                         factory: factory,
                                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try evaluator.evaluateCircuit(geneticCircuit))
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureBits, nonSensicalUseCase.circuit.input)
    }

    func testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        factory.makeCircuitResult = circuit
        circuit.measureResult = measures

        let evaluator = try! MainGeneticUseCaseEvaluator(useCase: useCase,
                                                         factory: factory,
                                                         oracleFactory: oracleFactory)

        // When
        let prob = try? evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(factory.makeCircuitCount, 1)
        XCTAssertEqual(circuit.measureCount, 1)
        XCTAssertEqual(circuit.lastMeasureBits, useCase.circuit.input)
        XCTAssertEqual(prob, 0.0)
    }

    static var allTests = [
        ("testOracleFactoryThatThrowException_evaluateCircuit_throwException",
         testOracleFactoryThatThrowException_evaluateCircuit_throwException),
        ("testCircuitThatThrowException_evaluateCircuit_throwException",
         testCircuitThatThrowException_evaluateCircuit_throwException),
        ("testUseCaseWithNonSensicalOutput_evaluateCircuit_throwException",
         testUseCaseWithNonSensicalOutput_evaluateCircuit_throwException),
        ("testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability",
         testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability)
    ]
}
