//
//  GateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/11/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

class GateTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalGates_equal_returnTrue() {
        // Given
        let gate = Gate(gate: FixedNotGate(target: 0))

        // Then
        XCTAssertTrue(gate == gate)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue() {
        // Given
        let gate = Gate(gate: Gate(gate: FixedNotGate(target: 0)))

        // Then
        XCTAssertTrue(gate == gate)
    }

    func testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse() {
        // Given
        let oneGate = Gate(gate: FixedNotGate(target: 0))
        let anotherGate = Gate(gate: FixedNotGate(target: 1))

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoGatesWithDifferentFixedGates_equal_returnFalse() {
        // Given
        let oneGate = Gate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0))
        let anotherGate = Gate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0))

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoGatesWithDifferentEmbeddedGates_equal_returnFalse() {
        // Given
        let oneGate = Gate(gate: Gate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0)))
        let anotherGate = Gate(gate: Gate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0)))

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoIdenticalGates_set_setCountIsOne() {
        // Given
        let gate = Gate(gate: FixedNotGate(target: 0))

        // When
        let result = Set([gate, gate])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne() {
        // Given
        let gate = Gate(gate: Gate(gate: FixedNotGate(target: 0)))

        // When
        let result = Set([gate, gate])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo() {
        // Given
        let oneGate = Gate(gate: FixedNotGate(target: 0))
        let anotherGate = Gate(gate: FixedNotGate(target: 1))

        // When
        let result = Set([oneGate, anotherGate])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoGatesWithDifferentFixedGates_set_setCountIsTwo() {
        // Given
        let oneGate = Gate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0))
        let anotherGate = Gate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0))

        // When
        let result = Set([oneGate, anotherGate])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoGatesWithDifferentEmbeddedGates_set_setCountIsTwo() {
        // Given
        let oneGate = Gate(gate: Gate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0)))
        let anotherGate = Gate(gate: Gate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0)))

        // When
        let result = Set([oneGate, anotherGate])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    static var allTests = [
        ("testTwoIdenticalGates_equal_returnTrue",
         testTwoIdenticalGates_equal_returnTrue),
        ("testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue",
         testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue),
        ("testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse",
         testTwoGatesWithAlmostIdenticalFixedGates_equal_returnFalse),
        ("testTwoGatesWithDifferentFixedGates_equal_returnFalse",
         testTwoGatesWithDifferentFixedGates_equal_returnFalse),
        ("testTwoGatesWithDifferentEmbeddedGates_equal_returnFalse",
         testTwoGatesWithDifferentEmbeddedGates_equal_returnFalse),
        ("testTwoIdenticalGates_set_setCountIsOne",
         testTwoIdenticalGates_set_setCountIsOne),
        ("testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne",
         testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne),
        ("testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo",
         testTwoGatesWithAlmostIdenticalFixedGates_set_setCountIsTwo),
        ("testTwoGatesWithDifferentFixedGates_set_setCountIsTwo",
         testTwoGatesWithDifferentFixedGates_set_setCountIsTwo),
        ("testTwoGatesWithDifferentEmbeddedGates_set_setCountIsTwo",
         testTwoGatesWithDifferentEmbeddedGates_set_setCountIsTwo)
    ]
}
