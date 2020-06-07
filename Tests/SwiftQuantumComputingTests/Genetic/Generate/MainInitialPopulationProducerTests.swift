//
//  MainInitialPopulationProducerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/02/2019.
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

class MainInitialPopulationProducerTests: XCTestCase {

    // MARK: - Properties

    let generator = GeneticGatesRandomizerTestDouble()
    let evaluator = GeneticCircuitEvaluatorTestDouble()
    let score = GeneticCircuitScoreTestDouble()
    let circuit = [GeneticGateTestDouble()]
    let evaluation: GeneticCircuitEvaluator.Evaluation = (0, 0)
    let queue = DispatchQueue(label: "MainInitialPopulationProducerTests")

    // MARK: - Tests

    func testSizeEqualToZero_execute_throwException() {
        // Given
        let size = 0
        let depth = (0..<3)

        var randomCount = 0
        let random: MainInitialPopulationProducer.Random = { [queue] _ in
            queue.sync {
                randomCount += 1
            }

            return 0
        }

        let initialPopulation = MainInitialPopulationProducer(generator: generator,
                                                              evaluator: evaluator,
                                                              score: score,
                                                              random: random)

        // Then
        switch initialPopulation.execute(size: size, depth: depth) {
        case .failure(.configurationPopulationSizeHasToBeBiggerThanZero):
            XCTAssertEqual(randomCount, 0)
            XCTAssertEqual(generator.makeCount, 0)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testGeneratorThrowException_execute_throwException() {
        // Given
        let size = 3
        let depth = (0..<3)

        var randomCount = 0
        let random: MainInitialPopulationProducer.Random = { [queue] _ in
            queue.sync {
                randomCount += 1
            }

            return 0
        }

        let initialPopulation = MainInitialPopulationProducer(generator: generator,
                                                              evaluator: evaluator,
                                                              score: score,
                                                              random: random)

        // Then
        switch initialPopulation.execute(size: size, depth: depth) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(randomCount, size)
            XCTAssertEqual(generator.makeCount, size)
            XCTAssertEqual(evaluator.evaluateCircuitCount, 0)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testEvaluatorThrowException_execute_throwException() {
        // Given
        let size = 3
        let depth = (0..<3)

        generator.makeResult = circuit

        var randomCount = 0
        let random: MainInitialPopulationProducer.Random = { [queue] _ in
            queue.sync {
                randomCount += 1
            }

            return 0
        }

        let initialPopulation = MainInitialPopulationProducer(generator: generator,
                                                              evaluator: evaluator,
                                                              score: score,
                                                              random: random)

        // Then
        switch initialPopulation.execute(size: size, depth: depth) {
        case .failure(.gateInputCountIsBiggerThanUseCaseCircuitQubitCount):
            XCTAssertEqual(randomCount, size)
            XCTAssertEqual(generator.makeCount, size)
            XCTAssertEqual(evaluator.evaluateCircuitCount, size)
            XCTAssertEqual(score.calculateCount, 0)
        default:
            XCTAssert(false)
        }
    }

    func testAllDependenciesReturnValue_execute_returnResult() {
        // Given
        let size = 3
        let depth = (0..<3)

        generator.makeResult = circuit
        evaluator.evaluateCircuitResult = evaluation

        var randomCount = 0
        let random: MainInitialPopulationProducer.Random = { [queue] _ in
            queue.sync {
                randomCount += 1
            }

            return 0
        }

        let initialPopulation = MainInitialPopulationProducer(generator: generator,
                                                              evaluator: evaluator,
                                                              score: score,
                                                              random: random)

        // When
        let result = try? initialPopulation.execute(size: size, depth: depth).get()

        // Then
        XCTAssertEqual(randomCount, size)
        XCTAssertEqual(generator.makeCount, size)
        XCTAssertEqual(evaluator.evaluateCircuitCount, size)
        XCTAssertEqual(score.calculateCount, size)
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testSizeEqualToZero_execute_throwException",
         testSizeEqualToZero_execute_throwException),
        ("testGeneratorThrowException_execute_throwException",
         testGeneratorThrowException_execute_throwException),
        ("testEvaluatorThrowException_execute_throwException",
         testEvaluatorThrowException_execute_throwException),
        ("testAllDependenciesReturnValue_execute_returnResult",
         testAllDependenciesReturnValue_execute_returnResult)
    ]
}
