//
//  FixedControlledGateTests.swift
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

class FixedControlledGateTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalGates_equal_returnTrue() {
        // Given
        let gate = FixedControlledGate(gate: FixedNotGate(target: 0), controls: [1])

        // Then
        XCTAssertTrue(gate == gate)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_equal_returnTrue() {
        // Given

        let gate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 0),
                                                                 controls: [1]),
                                       controls: [2])

        // Then
        XCTAssertTrue(gate == gate)
    }

    func testTwoGatesWithSameControlledGateButDifferentTargets_equal_returnFalse() {
        // Given
        let controlledGate = FixedNotGate(target: 0)
        let oneGate = FixedControlledGate(gate: controlledGate, controls: [1])
        let anotherGate = FixedControlledGate(gate: controlledGate, controls: [2])

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoGatesWithDifferentControlledGate_equal_returnFalse() {
        // Given
        let oneGate = FixedControlledGate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0),
                                          controls: [2])
        let anotherGate = FixedControlledGate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0),
                                              controls: [2])

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_equal_returnFalse() {
        // Given
        let oneGate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 0),
                                                                    controls: [2]),
                                          controls: [3])
        let anotherGate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 1),
                                                                        controls: [2]),
                                              controls: [3])

        // Then
        XCTAssertFalse(oneGate == anotherGate)
    }

    func testTwoIdenticalGates_set_setCountIsOne() {
        // Given
        let gate = FixedControlledGate(gate: FixedNotGate(target: 0), controls: [1])

        // When
        let result = Set([gate, gate])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne() {
        // Given

        let gate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 0),
                                                                 controls: [1]),
                                       controls: [2])

        // When
        let result = Set([gate, gate])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoGatesWithSameControlledGateButDifferentTargets_set_setCountIsTwo() {
        // Given
        let controlledGate = FixedNotGate(target: 0)
        let oneGate = FixedControlledGate(gate: controlledGate, controls: [1])
        let anotherGate = FixedControlledGate(gate: controlledGate, controls: [2])

        // When
        let result = Set([oneGate, anotherGate])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoGatesWithDifferentControlledGate_set_setCountIsTwo() {
        // Given
        let oneGate = FixedControlledGate(gate: FixedRotationGate(axis: .x, radians: 0.5, target: 0),
                                          controls: [2])
        let anotherGate = FixedControlledGate(gate: FixedPhaseShiftGate(radians: 0.5, target: 0),
                                              controls: [2])

        // When
        let result = Set([oneGate, anotherGate])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_set_setCountIsTwo() {
        // Given
        let oneGate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 0),
                                                                    controls: [2]),
                                          controls: [3])
        let anotherGate = FixedControlledGate(gate: FixedControlledGate(gate: FixedNotGate(target: 1),
                                                                        controls: [2]),
                                              controls: [3])

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
        ("testTwoGatesWithSameControlledGateButDifferentTargets_equal_returnFalse",
         testTwoGatesWithSameControlledGateButDifferentTargets_equal_returnFalse),
        ("testTwoGatesWithDifferentControlledGate_equal_returnFalse",
         testTwoGatesWithDifferentControlledGate_equal_returnFalse),
        ("testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_equal_returnFalse",
         testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_equal_returnFalse),
        ("testTwoIdenticalGates_set_setCountIsOne",
         testTwoIdenticalGates_set_setCountIsOne),
        ("testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne",
         testTwoIdenticalGatesWithEmbeddedGates_set_setCountIsOne),
        ("testTwoGatesWithSameControlledGateButDifferentTargets_set_setCountIsTwo",
         testTwoGatesWithSameControlledGateButDifferentTargets_set_setCountIsTwo),
        ("testTwoGatesWithDifferentControlledGate_set_setCountIsTwo",
         testTwoGatesWithDifferentControlledGate_set_setCountIsTwo),
        ("testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_set_setCountIsTwo",
         testTwoGatesWithAlmostIdenticalEmbeddedControlledGates_set_setCountIsTwo)
    ]
}
