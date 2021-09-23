//
//  FixedPhaseDampingNoiseTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 23/09/2021.
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

class FixedPhaseDampingNoiseTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalNoises_equal_returnTrue() {
        // Given
        let noise = FixedPhaseDampingNoise(probability: 0.1, target: 1)

        // Then
        XCTAssertTrue(noise == noise)
    }

    func testTwoNoisesWithSameProbabilitiesButDifferentTargets_equal_returnFalse() {
        // Given
        let oneNoise = FixedPhaseDampingNoise(probability: 0.1, target: 1)
        let anotherNoise = FixedPhaseDampingNoise(probability: 0.1, target: 2)

        // Then
        XCTAssertFalse(oneNoise == anotherNoise)
    }

    func testTwoIdenticalNoises_set_setCountIsOne() {
        // Given
        let noise = FixedPhaseDampingNoise(probability: 0.1, target: 1)

        // When
        let result = Set([noise, noise])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoNoisesWithSameProbabilitiesButDifferentTargets_set_setCountIsTwo() {
        // Given
        let oneNoise = FixedPhaseDampingNoise(probability: 0.1, target: 1)
        let anotherNoise = FixedPhaseDampingNoise(probability: 0.1, target: 2)

        // When
        let result = Set([oneNoise, anotherNoise])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    static var allTests = [
        ("testTwoIdenticalNoises_equal_returnTrue",
         testTwoIdenticalNoises_equal_returnTrue),
        ("testTwoNoisesWithSameProbabilitiesButDifferentTargets_equal_returnFalse",
         testTwoNoisesWithSameProbabilitiesButDifferentTargets_equal_returnFalse),
        ("testTwoIdenticalNoises_set_setCountIsOne",
         testTwoIdenticalNoises_set_setCountIsOne),
        ("testTwoNoisesWithSameProbabilitiesButDifferentTargets_set_setCountIsTwo",
         testTwoNoisesWithSameProbabilitiesButDifferentTargets_set_setCountIsTwo)
    ]
}
