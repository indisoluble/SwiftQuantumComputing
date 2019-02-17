//
//  GeneticCircuitEvaluatorTests.swift
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

class GeneticCircuitEvaluatorTests: XCTestCase {

    // MARK: - Properties

    let threshold = 0.4
    let firstUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let secondUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let thirdUseCaseEvaluator = GeneticUseCaseEvaluatorTestDouble()
    let geneticCircuit: [GeneticGate] = []

    // MARK: - Tests

    func testOneCaseReturnErrorProbabilityToNil_evaluateCircuit_returnNil() {
        // Given
        firstUseCaseEvaluator.evaluateCircuitResult = 0.0
        thirdUseCaseEvaluator.evaluateCircuitResult = 0.0

        let evaluator = GeneticCircuitEvaluator(threshold: threshold,
                                                evaluators: [firstUseCaseEvaluator,
                                                             secondUseCaseEvaluator,
                                                             thirdUseCaseEvaluator])

        // When
        let eval = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(firstUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(secondUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(thirdUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertNil(eval)
    }

    func testBothCasesReturnErrorProbability_evaluateCircuit_returnExpectedValue() {
        // Given
        let maxErrorProbability = threshold + 0.2
        let errorProbabilityBiggerThanThreshold = threshold + 0.1

        firstUseCaseEvaluator.evaluateCircuitResult = threshold
        secondUseCaseEvaluator.evaluateCircuitResult = maxErrorProbability
        thirdUseCaseEvaluator.evaluateCircuitResult = errorProbabilityBiggerThanThreshold

        let evaluator = GeneticCircuitEvaluator(threshold: threshold,
                                                evaluators: [firstUseCaseEvaluator,
                                                             secondUseCaseEvaluator,
                                                             thirdUseCaseEvaluator])

        // When
        let eval = evaluator.evaluateCircuit(geneticCircuit)

        // Then
        XCTAssertEqual(firstUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(secondUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(thirdUseCaseEvaluator.evaluateCircuitCount, 1)
        XCTAssertEqual(eval?.misses, 2)
        XCTAssertEqual(eval?.maxProbability, maxErrorProbability)
    }
}
