//
//  XorGaussianEliminationSolver+ActivatedBitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/01/2020.
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

class XorGaussianEliminationSolver_ActivatedBitsTests: XCTestCase {

    // MARK: - Properties

    let solver = XorGaussianEliminationSolverTestDouble()

    // MARK: - Tests

    func testAnyEquations_findActivatedVariablesInEquations_returnExpectedStrings() {
        // Given
        let equations = ["0", "101", "10"]

        solver.findActivatedVariablesInEquationsResult = [[], [2], [1, 0]]

        // When
        let result = solver.findActivatedVariablesInEquations(equations)

        // Then
        XCTAssertEqual(solver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(solver.lastFindActivatedVariablesInEquationsEquations, [[], [1], [2, 0]])
        XCTAssertEqual(Set(result), Set(["011", "100", "000"]))
    }

    static var allTests = [
        ("testAnyEquations_findActivatedVariablesInEquations_returnExpectedStrings",
         testAnyEquations_findActivatedVariablesInEquations_returnExpectedStrings)
    ]
}
