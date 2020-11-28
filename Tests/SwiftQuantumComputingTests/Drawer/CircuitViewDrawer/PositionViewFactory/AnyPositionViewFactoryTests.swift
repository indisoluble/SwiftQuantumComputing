//
//  AnyPositionViewFactoryTests.swift
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

class AnyPositionViewFactoryTests: XCTestCase {

    // MARK: - Tests

    func testTwoIdenticalFactories_equal_returnTrue() {
        // Given
        let factory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 0))

        // When
        XCTAssertTrue(factory == factory)
    }

    func testTwoFactoriesWithAlmostIdenticalPositions_equal_returnFalse() {
        // Given
        let oneFactory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 0))
        let anotherFactory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 1))

        // When
        XCTAssertFalse(oneFactory == anotherFactory)
    }

    func testTwoFactoriesWithDifferentPositions_equal_returnFalse() {
        // Given
        let oneFactory = AnyPositionViewFactory(circuitViewPosition: RotationPositionViewFactory(axis: .x,
                                                                                                 radians: 0.5) )
        let anotherFactory = AnyPositionViewFactory(circuitViewPosition: PhaseShiftPositionViewFactory(radians: 0.5,
                                                                                                       connected: .none))

        // When
        XCTAssertFalse(oneFactory == anotherFactory)
    }

    func testTwoIdenticalFactories_set_setCountIsOne() {
        // Given
        let factory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 0))

        // When
        let result = Set([factory, factory])

        // Then
        XCTAssertTrue(result.count == 1)
    }

    func testTwoFactoriesWithAlmostIdenticalPositions_set_setCountIsTwo() {
        // Given
        let oneFactory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 0))
        let anotherFactory = AnyPositionViewFactory(circuitViewPosition: QubitPositionViewFactory(index: 1))

        // When
        let result = Set([oneFactory, anotherFactory])

        // Then
        XCTAssertTrue(result.count == 2)
    }

    func testTwoFactoriesWithDifferentPositions_set_setCountIsTwo() {
        // Given
        let oneFactory = AnyPositionViewFactory(circuitViewPosition: RotationPositionViewFactory(axis: .x,
                                                                                                 radians: 0.5) )
        let anotherFactory = AnyPositionViewFactory(circuitViewPosition: PhaseShiftPositionViewFactory(radians: 0.5,
                                                                                                       connected: .none))

        // When
        let result = Set([oneFactory, anotherFactory])

        // Then
        XCTAssertTrue(result.count == 2)
    }
}
