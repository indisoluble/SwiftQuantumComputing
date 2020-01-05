//
//  XorEquationSystemPreSimplificationSolverTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/01/2020.
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

class XorEquationSystemPreSimplificationSolverTests: XCTestCase {

    // MARK: - Properties

    let secondarySolver = XorEquationSystemSimpleSolverTestDouble()

    // MARK: - Tests

    func testNoEquations_findSolutions_returnNoSolutions() {
        // Given
        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findSolutions(for: []), [])
        XCTAssertEqual(secondarySolver.findSolutionsCount, 0)
    }

    func testAllEquationsWithMoreThanOneVariable_findSolutions_returnSolutionFoundBySecondarySolver() {
        // Given
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: 0), .variable(id: 1)],
            [.variable(id: 1), .variable(id: 2)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        let expectedSolutions = [[0, 1, 2], []]
        secondarySolver.findSolutionsResult = expectedSolutions

        // Then
        XCTAssertEqual(sut.findSolutions(for: equations), expectedSolutions)
        XCTAssertEqual(secondarySolver.findSolutionsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindSolutionsEquations, equations)
    }

    func testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findSolutions_returnOneSolution() {
        // Given
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: 0), .variable(id: 0), .variable(id: 0), .constant(activated: true)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        let expectedSolutions = [[0]]
        secondarySolver.findSolutionsResult = expectedSolutions

        // Then
        XCTAssertEqual(sut.findSolutions(for: equations), expectedSolutions)
        XCTAssertEqual(secondarySolver.findSolutionsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindSolutionsEquations, equations)
    }

    func testEquationWithOneVar_findSolutions_returnEmptySolution() {
        // Given
        let equations: [XorEquationSystemSimpleSolver.Equation] = [[.variable(id: 0)]]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findSolutions(for: equations), [[]])
        XCTAssertEqual(secondarySolver.findSolutionsCount, 0)
    }

    func testEquationWithOneVarAndTwoActivatedCte_findSolutions_returnEmptySolution() {
        // Given
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: 0), .constant(activated: true), .constant(activated: true)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findSolutions(for: equations), [[]])
        XCTAssertEqual(secondarySolver.findSolutionsCount, 0)
    }

    func testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findSolutions_returnOneSolution() {
        // Given
        let varId = 0
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: varId), .constant(activated: true), .constant(activated: false)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findSolutions(for: equations), [[varId]])
        XCTAssertEqual(secondarySolver.findSolutionsCount, 0)
    }

    func testTwoSimplifiableEquations_findSolutions_returnExpectedSolution() {
        // Given
        let firstVarId = 0
        let secondVarId = 1
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: firstVarId), .constant(activated: true), .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId), .constant(activated: false)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(Set(sut.findSolutions(for: equations).map { Set($0) }),
                       Set([Set([firstVarId, secondVarId])]))
        XCTAssertEqual(secondarySolver.findSolutionsCount, 0)
    }

    func testTwoSimplifiableEquationsAndOneThatIsNot_findSolutions_returnExpectedSolution() {
        // Given
        let firstVarId = 0
        let secondVarId = 1
        let thirdVarId = 2
        let forthVarId = 3
        let equations: [XorEquationSystemSimpleSolver.Equation] = [
            [.variable(id: firstVarId),
             .constant(activated: true), .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId),
             .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId),
             .variable(id: thirdVarId), .variable(id: forthVarId)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        secondarySolver.findSolutionsResult = [[thirdVarId, forthVarId], []]

        // Then
        let expectedSecondaryEquations: [XorEquationSystemSimpleSolver.Equation] = [
            [
                .constant(activated: true), .constant(activated: true),
                .variable(id: thirdVarId), .variable(id: forthVarId)
            ]
        ]

        XCTAssertEqual(Set(sut.findSolutions(for: equations).map { Set($0) }),
                       Set([Set([thirdVarId, forthVarId, firstVarId, secondVarId]),
                            Set([firstVarId, secondVarId])]))
        XCTAssertEqual(secondarySolver.findSolutionsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindSolutionsEquations, expectedSecondaryEquations)
    }

    static var allTests = [
        ("testNoEquations_findSolutions_returnNoSolutions",
         testNoEquations_findSolutions_returnNoSolutions),
        ("testAllEquationsWithMoreThanOneVariable_findSolutions_returnSolutionFoundBySecondarySolver",
         testAllEquationsWithMoreThanOneVariable_findSolutions_returnSolutionFoundBySecondarySolver),
        ("testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findSolutions_returnOneSolution",
         testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findSolutions_returnOneSolution),
        ("testEquationWithOneVar_findSolutions_returnEmptySolution",
         testEquationWithOneVar_findSolutions_returnEmptySolution),
        ("testEquationWithOneVarAndTwoActivatedCte_findSolutions_returnEmptySolution",
         testEquationWithOneVarAndTwoActivatedCte_findSolutions_returnEmptySolution),
        ("testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findSolutions_returnOneSolution",
         testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findSolutions_returnOneSolution),
        ("testTwoSimplifiableEquations_findSolutions_returnExpectedSolution",
         testTwoSimplifiableEquations_findSolutions_returnExpectedSolution),
        ("testTwoSimplifiableEquationsAndOneThatIsNot_findSolutions_returnExpectedSolution",
         testTwoSimplifiableEquationsAndOneThatIsNot_findSolutions_returnExpectedSolution)
    ]
}
