//
//  MainGeneticGatesRandomizerFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 06/06/2020.
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

class MainGeneticGatesRandomizerFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = MainGeneticGatesRandomizerFactory()
    let gates = [ConfigurableGateTestDouble()]

    // MARK: - Tests

    func testQubitCountEqualToZero_makeRandomizer_throwException() {
        // Then
        switch factory.makeRandomizer(qubitCount: 0, gates: gates) {
        case .failure(.useCaseCircuitQubitCountHasToBeBiggerThanZero):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    func testQubitCountBiggerThanZero_makeRandomizer_returnValue() {
        // Then
        switch factory.makeRandomizer(qubitCount: 1, gates: gates) {
        case .success:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testQubitCountEqualToZero_makeRandomizer_throwException",
         testQubitCountEqualToZero_makeRandomizer_throwException),
        ("testQubitCountBiggerThanZero_makeRandomizer_returnValue",
         testQubitCountBiggerThanZero_makeRandomizer_returnValue)
    ]
}
