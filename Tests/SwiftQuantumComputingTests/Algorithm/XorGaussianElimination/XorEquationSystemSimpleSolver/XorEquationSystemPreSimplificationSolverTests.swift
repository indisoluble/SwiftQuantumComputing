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

    func testNoEquations_findActivatedVariablesInEquations_returnNoSolutions() {
        // Given
        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations([]), [])
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 0)
    }

    func testAllEquationsWithMoreThanOneVariable_findActivatedVariablesInEquations_returnSolutionFoundBySecondarySolver() {
        // Given
        let equations: [[XorEquationComponent]] = [
            [.variable(id: 0), .variable(id: 1)],
            [.variable(id: 1), .variable(id: 2)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        let expectedSolutions = [[0, 1, 2], []]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedSolutions

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedSolutions)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, equations)
    }

    func testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findActivatedVariablesInEquations_returnOneSolution() {
        // Given
        let equations: [[XorEquationComponent]] = [
            [.variable(id: 0), .variable(id: 0), .variable(id: 0), .constant(activated: true)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        let expectedSolutions = [[0]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedSolutions

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedSolutions)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, equations)
    }

    func testEquationWithOneVar_findActivatedVariablesInEquations_returnEmptySolution() {
        // Given
        let equations: [[XorEquationComponent]] = [[.variable(id: 0)]]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), [[]])
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 0)
    }

    func testEquationWithOneVarAndTwoActivatedCte_findActivatedVariablesInEquations_returnEmptySolution() {
        // Given
        let equations: [[XorEquationComponent]] = [
            [.variable(id: 0), .constant(activated: true), .constant(activated: true)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), [[]])
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 0)
    }

    func testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findActivatedVariablesInEquations_returnOneSolution() {
        // Given
        let varId = 0
        let equations: [[XorEquationComponent]] = [
            [.variable(id: varId), .constant(activated: true), .constant(activated: false)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), [[varId]])
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 0)
    }

    func testTwoSimplifiableEquations_findActivatedVariablesInEquations_returnExpectedSolution() {
        // Given
        let firstVarId = 0
        let secondVarId = 1
        let equations: [[XorEquationComponent]] = [
            [.variable(id: firstVarId), .constant(activated: true), .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId), .constant(activated: false)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        // Then
        XCTAssertEqual(Set(sut.findActivatedVariablesInEquations(equations).map { Set($0) }),
                       Set([Set([firstVarId, secondVarId])]))
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 0)
    }

    func testTwoSimplifiableEquationsAndOneThatIsNot_findActivatedVariablesInEquations_returnExpectedSolution() {
        // Given
        let firstVarId = 0
        let secondVarId = 1
        let thirdVarId = 2
        let forthVarId = 3
        let equations: [[XorEquationComponent]] = [
            [.variable(id: firstVarId),
             .constant(activated: true), .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId),
             .constant(activated: false)],
            [.variable(id: firstVarId), .variable(id: secondVarId),
             .variable(id: thirdVarId), .variable(id: forthVarId)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        secondarySolver.findActivatedVariablesInEquationsResult = [[thirdVarId, forthVarId], []]

        // Then
        let expectedSecondaryEquations: [[XorEquationComponent]] = [
            [
                .constant(activated: true), .constant(activated: true),
                .variable(id: thirdVarId), .variable(id: forthVarId)
            ]
        ]

        XCTAssertEqual(Set(sut.findActivatedVariablesInEquations(equations).map { Set($0) }),
                       Set([Set([thirdVarId, forthVarId, firstVarId, secondVarId]),
                            Set([firstVarId, secondVarId])]))
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, expectedSecondaryEquations)
    }

    func testOneSimplifiableEquationAndOneComposeOfConstants_findActivatedVariablesInEquations_returnExpectedSolution() {
        // Given
        let equations: [[XorEquationComponent]] = [
            [.variable(id: 0), .constant(activated: true)],
            [.constant(activated: true), .constant(activated: false)]
        ]

        let sut = XorEquationSystemPreSimplificationSolver(solver: secondarySolver)

        secondarySolver.findActivatedVariablesInEquationsResult = []

        // Then
        let expectedSecondaryEquations: [[XorEquationComponent]] = [
            [.constant(activated: true), .constant(activated: false)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), [])
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, expectedSecondaryEquations)
    }

    static var allTests = [
        ("testNoEquations_findActivatedVariablesInEquations_returnNoSolutions",
         testNoEquations_findActivatedVariablesInEquations_returnNoSolutions),
        ("testAllEquationsWithMoreThanOneVariable_findActivatedVariablesInEquations_returnSolutionFoundBySecondarySolver",
         testAllEquationsWithMoreThanOneVariable_findActivatedVariablesInEquations_returnSolutionFoundBySecondarySolver),
        ("testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findActivatedVariablesInEquations_returnOneSolution",
         testEquationWithOneVarRepeatedThreeTimesAndOneActivatedCte_findActivatedVariablesInEquations_returnOneSolution),
        ("testEquationWithOneVar_findActivatedVariablesInEquations_returnEmptySolution",
         testEquationWithOneVar_findActivatedVariablesInEquations_returnEmptySolution),
        ("testEquationWithOneVarAndTwoActivatedCte_findActivatedVariablesInEquations_returnEmptySolution",
         testEquationWithOneVarAndTwoActivatedCte_findActivatedVariablesInEquations_returnEmptySolution),
        ("testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findActivatedVariablesInEquations_returnOneSolution",
         testEquationWithOneVarOneActivatedCteAndOneDeactivatedCte_findActivatedVariablesInEquations_returnOneSolution),
        ("testTwoSimplifiableEquations_findActivatedVariablesInEquations_returnExpectedSolution",
         testTwoSimplifiableEquations_findActivatedVariablesInEquations_returnExpectedSolution),
        ("testTwoSimplifiableEquationsAndOneThatIsNot_findActivatedVariablesInEquations_returnExpectedSolution",
         testTwoSimplifiableEquationsAndOneThatIsNot_findActivatedVariablesInEquations_returnExpectedSolution),
        ("testOneSimplifiableEquationAndOneComposeOfConstants_findActivatedVariablesInEquations_returnExpectedSolution",
         testOneSimplifiableEquationAndOneComposeOfConstants_findActivatedVariablesInEquations_returnExpectedSolution)
    ]
}
