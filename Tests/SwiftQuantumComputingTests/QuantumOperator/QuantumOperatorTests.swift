//
//  QuantumOperatorTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/09/2021.
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

class QuantumOperatorTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalNoises_equal_returnTrue() {
        // Given
        let op = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator

        // Then
        XCTAssertTrue(op == op)
    }

    func testTwoNoisesWithDifferentFixedNoises_equal_returnFalse() {
        // Given
        let oneOp = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator
        let anotherOp = Noise(noise: FixedMatricesNoise(matrices: [.makeNot()], inputs: [1])).quantumOperator

        // Then
        XCTAssertFalse(oneOp == anotherOp)
    }

    func testTwoIdenticalNoises_set_setCountIsOne() {
        // Given
        let op = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator

        // When
        let result = Set([op, op])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoGatesWithDifferentFixedGates_set_setCountIsTwo() {
        // Given
        let oneOp = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator
        let anotherOp = Noise(noise: FixedMatricesNoise(matrices: [.makeNot()],
                                                        inputs: [1])).quantumOperator

        // When
        let result = Set([oneOp, anotherOp])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoIdenticalGates_equal_returnTrue() {
        // Given
        let op = Gate(gate: FixedNotGate(target: 0)).quantumOperator

        // Then
        XCTAssertTrue(op == op)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue() {
        // Given
        let op = Gate(gate: Gate(gate: FixedNotGate(target: 0))).quantumOperator

        // Then
        XCTAssertTrue(op == op)
    }

    func testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse() {
        // Given
        let oneOp = Gate(gate: FixedNotGate(target: 0)).quantumOperator
        let anotherOp = Gate(gate: FixedNotGate(target: 1)).quantumOperator

        // Then
        XCTAssertFalse(oneOp == anotherOp)
    }

    func testTwoIdenticalGates_set_setCountIsOne() {
        // Given
        let op = Gate(gate: FixedNotGate(target: 0)).quantumOperator

        // When
        let result = Set([op, op])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne() {
        // Given
        let op = Gate(gate: Gate(gate: FixedNotGate(target: 0))).quantumOperator

        // When
        let result = Set([op, op])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo() {
        // Given
        let oneOp = Gate(gate: FixedNotGate(target: 0)).quantumOperator
        let anotherOp = Gate(gate: FixedNotGate(target: 1)).quantumOperator

        // When
        let result = Set([oneOp, anotherOp])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testOneNoiseAndOneGate_equal_returnFalse() {
        // Given
        let oneOp = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator
        let anotherOp = Gate(gate: FixedNotGate(target: 1)).quantumOperator

        // When
        let result = Set([oneOp, anotherOp])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testOneNoiseAndOneGate_set_setCountIsTwo() {
        // Given
        let oneOp = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1)).quantumOperator
        let anotherOp = Gate(gate: FixedNotGate(target: 1)).quantumOperator

        // Then
        XCTAssertFalse(oneOp == anotherOp)
    }

    static var allTests = [
        ("testTwoIdenticalNoises_equal_returnTrue",
         testTwoIdenticalNoises_equal_returnTrue),
        ("testTwoNoisesWithDifferentFixedNoises_equal_returnFalse",
         testTwoNoisesWithDifferentFixedNoises_equal_returnFalse),
        ("testTwoIdenticalNoises_set_setCountIsOne",
         testTwoIdenticalNoises_set_setCountIsOne),
        ("testTwoIdenticalGates_equal_returnTrue",
         testTwoIdenticalGates_equal_returnTrue),
        ("testTwoIdenticalGates_equal_returnTrue",
         testTwoIdenticalGates_equal_returnTrue),
        ("testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue",
         testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue),
        ("testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse",
         testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse),
        ("testTwoIdenticalGates_set_setCountIsOne",
         testTwoIdenticalGates_set_setCountIsOne),
        ("testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne",
         testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne),
        ("testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo",
         testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo),
        ("testOneNoiseAndOneGate_equal_returnFalse",
         testOneNoiseAndOneGate_equal_returnFalse),
        ("testOneNoiseAndOneGate_set_setCountIsTwo",
         testOneNoiseAndOneGate_set_setCountIsTwo)
    ]
}
