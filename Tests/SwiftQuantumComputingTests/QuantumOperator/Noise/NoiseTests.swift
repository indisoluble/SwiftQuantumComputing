//
//  NoiseTests.swift
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

class NoiseTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalNoises_equal_returnTrue() {
        // Given
        let noise = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1))

        // Then
        XCTAssertTrue(noise == noise)
    }

    func testTwoNoisesWithDifferentFixedNoises_equal_returnFalse() {
        // Given
        let oneNoise = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1))
        let anotherNoise = Noise(noise: FixedMatricesNoise(matrices: [.makeNot()], inputs: [1]))

        // Then
        XCTAssertFalse(oneNoise == anotherNoise)
    }

    func testTwoIdenticalNoises_set_setCountIsOne() {
        // Given
        let noise = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1))

        // When
        let result = Set([noise, noise])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoNoisesWithDifferentFixedNoises_set_setCountIsTwo() {
        // Given
        let oneNoise = Noise(noise: FixedBitFlipNoise(probability: 0.1, target: 1))
        let anotherNoise = Noise(noise: FixedMatricesNoise(matrices: [.makeNot()], inputs: [1]))

        // When
        let result = Set([oneNoise, anotherNoise])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testAnyNoise_simplifiedNoise_returnExpectedSimplifiedNoise() {
        // Given
        let noises: [(Noise, SimplifiedNoise)] = [
            (.bitFlip(probability: 0.1, target: 1),
             .bitFlip(probability: 0.1, target: 1)),
            (.matrices(matrices: [.makeHadamard()], inputs: [2, 3]),
             .matrices(matrices: [.makeHadamard()], inputs: [2, 3]))
        ]

        // Then
        for (noise, simplified) in noises {
            XCTAssertEqual(noise.simplifiedNoise, simplified)
        }
    }

    static var allTests = [
        ("testTwoIdenticalNoises_equal_returnTrue",
         testTwoIdenticalNoises_equal_returnTrue),
        ("testTwoNoisesWithDifferentFixedNoises_equal_returnFalse",
         testTwoNoisesWithDifferentFixedNoises_equal_returnFalse),
        ("testTwoIdenticalNoises_set_setCountIsOne",
         testTwoIdenticalNoises_set_setCountIsOne),
        ("testTwoNoisesWithDifferentFixedNoises_set_setCountIsTwo",
         testTwoNoisesWithDifferentFixedNoises_set_setCountIsTwo),
        ("testAnyNoise_simplifiedNoise_returnExpectedSimplifiedNoise",
         testAnyNoise_simplifiedNoise_returnExpectedSimplifiedNoise)
    ]
}
