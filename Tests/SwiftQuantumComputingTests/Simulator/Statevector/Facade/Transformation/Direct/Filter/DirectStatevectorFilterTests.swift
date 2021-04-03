//
//  DirectStatevectorFilterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/04/2021.
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

class DirectStatevectorFilterTests: XCTestCase {

    // MARK: - Tests

    func testNoControlsAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorFilter(gateControls: [])

        // Then
        XCTAssertTrue(Array(0..<8).allSatisfy { sut.shouldCalculateStatevectorValueAtPosition($0) })
    }

    func testControl2AndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorFilter(gateControls: [2])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    func testControl2AndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorFilter(gateControls: [2])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(3))
    }

    func testControl2And0AndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue() {
        // Given
        let sut = DirectStatevectorFilter(gateControls: [2, 0])

        // Then
        XCTAssertTrue(sut.shouldCalculateStatevectorValueAtPosition(5))
    }

    func testControl2And0AndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse() {
        // Given
        let sut = DirectStatevectorFilter(gateControls: [2, 0])

        // Then
        XCTAssertFalse(sut.shouldCalculateStatevectorValueAtPosition(4))
    }

    static var allTests = [
        ("testNoControlsAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testNoControlsAndAnyPosition_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2AndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2AndPosition4_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2AndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2AndPosition3_shouldCalculateStatevectorValueAtPosition_returnFalse),
        ("testControl2And0AndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue",
         testControl2And0AndPosition5_shouldCalculateStatevectorValueAtPosition_returnTrue),
        ("testControl2And0AndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse",
         testControl2And0AndPosition4_shouldCalculateStatevectorValueAtPosition_returnFalse)
    ]
}
