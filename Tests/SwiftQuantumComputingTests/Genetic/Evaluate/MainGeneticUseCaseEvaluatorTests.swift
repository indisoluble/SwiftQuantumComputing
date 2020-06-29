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

    let circuitFactory = CircuitFactoryTestDouble()
    let statevectorFactory = CircuitStatevectorFactoryTestDouble()
    let oracleFactory = OracleCircuitFactoryTestDouble()
    let oracleCircuit: OracleCircuitFactory.OracleCircuit = ([], 0)
    let geneticCircuit: [GeneticGate] = []
    let circuit = CircuitTestDouble()
    let statevector = CircuitStatevectorTestDouble()
    let useCase = try! GeneticUseCase(emptyTruthTableQubitCount: 1,
                                      circuitInput: "01",
                                      circuitOutput: "11")
    let statevectorInput = try! Vector([Complex.zero, Complex.one, Complex.zero, Complex.zero])
    let statevectorOutput = try! Vector([Complex.zero, Complex.zero, Complex.zero, Complex.one])

    // MARK: - Tests

    func testOracleFactoryThatThrowException_evaluateCircuit_throwException() {
        // Given
        let evaluator = MainGeneticUseCaseEvaluator(useCase: useCase,
                                                    circuitFactory: circuitFactory,
                                                    statevectorFactory: statevectorFactory,
                                                    oracleFactory: oracleFactory)

        // Then
        switch evaluator.evaluateCircuit(geneticCircuit) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
            XCTAssertEqual(circuitFactory.makeCircuitCount, 0)
            XCTAssertEqual(statevectorFactory.makeStatevectorCount, 0)
            XCTAssertEqual(circuit.circuitStatevectorCount, 0)
            XCTAssertEqual(statevector.statevectorCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testCircuitThatThrowException_evaluateCircuit_throwException() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        circuitFactory.makeCircuitResult = circuit
        statevectorFactory.makeStatevectorResult = statevector

        let evaluator = MainGeneticUseCaseEvaluator(useCase: useCase,
                                                    circuitFactory: circuitFactory,
                                                    statevectorFactory: statevectorFactory,
                                                    oracleFactory: oracleFactory)

        // Then
        switch evaluator.evaluateCircuit(geneticCircuit) {
        case .failure(.useCaseMeasurementThrowedError):
            XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
            XCTAssertEqual(circuitFactory.makeCircuitCount, 1)
            XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
            XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevectorInput)
            XCTAssertEqual(circuit.circuitStatevectorCount, 1)
            XCTAssertEqual(statevector.statevectorCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability() {
        // Given
        oracleFactory.makeOracleCircuitResult = oracleCircuit
        circuitFactory.makeCircuitResult = circuit
        statevectorFactory.makeStatevectorResult = statevector
        circuit.circuitStatevectorResult = statevector
        statevector.statevectorResult = statevectorOutput

        let evaluator = MainGeneticUseCaseEvaluator(useCase: useCase,
                                                    circuitFactory: circuitFactory,
                                                    statevectorFactory: statevectorFactory,
                                                    oracleFactory: oracleFactory)

        // When
        let prob = try? evaluator.evaluateCircuit(geneticCircuit).get()

        // Then
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertEqual(circuitFactory.makeCircuitCount, 1)
        XCTAssertEqual(statevectorFactory.makeStatevectorCount, 1)
        XCTAssertEqual(statevectorFactory.lastMakeStatevectorVector, statevectorInput)
        XCTAssertEqual(circuit.circuitStatevectorCount, 1)
        XCTAssertEqual(statevector.statevectorCount, 1)
        XCTAssertEqual(prob, 0.0)
    }

    static var allTests = [
        ("testOracleFactoryThatThrowException_evaluateCircuit_throwException",
         testOracleFactoryThatThrowException_evaluateCircuit_throwException),
        ("testCircuitThatThrowException_evaluateCircuit_throwException",
         testCircuitThatThrowException_evaluateCircuit_throwException),
        ("testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability",
         testEvaluatorWithAllParamsValid_evaluateCircuit_returnExpectedErrorProbability)
    ]
}
