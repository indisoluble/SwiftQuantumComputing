//
//  GeneticConfigurationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre (dev) on 07/06/2020.
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

class GeneticConfigurationTests: XCTestCase {

    func testEmptyDepth_init_throwException() {
        // Then
        XCTAssertThrowsError(try GeneticConfiguration(depth: (0..<0),
                                                      generationCount: 10,
                                                      populationSize: (0..<100),
                                                      tournamentSize: 0,
                                                      mutationProbability: 0.0,
                                                      threshold: 0.0,
                                                      errorProbability: 0.0))
    }

    func testAnyRandomizerAndNegativeDepth_init_throwException() {
        // Then
        XCTAssertThrowsError(try GeneticConfiguration(depth: (-1..<0),
                                                      generationCount: 10,
                                                      populationSize: (0..<100),
                                                      tournamentSize: 0,
                                                      mutationProbability: 0.0,
                                                      threshold: 0.0,
                                                      errorProbability: 0.0))
    }

    static var allTests = [
        ("testEmptyDepth_init_throwException", testEmptyDepth_init_throwException)
    ]
}
