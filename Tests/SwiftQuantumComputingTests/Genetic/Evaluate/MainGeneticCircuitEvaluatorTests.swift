//
//  MainGeneticCircuitEvaluatorTests.swift
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

class MainGeneticCircuitEvaluatorTests: XCTestCase {

    // MARK: - Properties

    let threshold = 0.4
    let firstUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let secondUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let thirdUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let geneticCircuit: [GeneticGate] = []

    // MARK: - Tests

    func testOneCaseThrowException_evaluateCircuit_throwException() {
        // Given
        firstUseCaseEvaluator.evaluateCircuitResult = 0.0
        thirdUseCaseEvaluator.evaluateCircuitResult = 0.0

        let evaluator = MainGeneticCircuitEvaluator(threshold: threshold,
                                                    evaluators: [firstUseCaseEvaluator,
                                                                 secondUseCaseEvaluator,
                                                                 thirdUseCaseEvaluator])

        // Then
        switch evaluator.evaluateCircuit(geneticCircuit) {
        case .failure(.useCasesDoNotSpecifySameCircuitQubitCount):
            XCTAssertEqual(firstUseCaseEvaluator.evaluateCircuitCount, 1)
            XCTAssertEqual(secondUseCaseEvaluator.evaluateCircuitCount, 1)
            XCTAssertEqual(thirdUseCaseEvaluator.evaluateCircuitCount, 1)
        default:
            XCTAssert(false)
        }
    }

    func testBothCasesReturnErrorProbability_evaluateCircuit_returnExpectedValue() {
        // Given
        let maxErrorProbability = threshold + 0.2
        let errorProbabilityBiggerThanThreshold = threshold + 0.1

        firstUseCaseEvaluator.evaluateCircuitResult = threshold
        secondUseCaseEvaluator.evaluateCircuitResult = maxErrorProbability
        thirdUseCaseEvaluator.evaluateCircuitResult = errorProbabilityBiggerThanThreshold

        let evaluator = MainGeneticCircuitEvaluator(threshold: threshold,
                                                    evaluators: [firstUseCaseEvaluator,
                                                                 secondUseCaseEvaluator,
                                                                 thirdUseCaseEvaluator])

        // When
        let eval = try? evaluator.evaluateCircuit(geneticCircuit).get()

        // Then
        XCTAssertEqual(firstUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(secondUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(thirdUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(eval?.misses, 2)
        XCTAssertEqual(eval?.maxProbability, maxErrorProbability)
    }

    static var allTests = [
        ("testOneCaseThrowException_evaluateCircuit_throwException",
         testOneCaseThrowException_evaluateCircuit_throwException),
        ("testBothCasesReturnErrorProbability_evaluateCircuit_returnExpectedValue",
         testBothCasesReturnErrorProbability_evaluateCircuit_returnExpectedValue)
    ]
}
