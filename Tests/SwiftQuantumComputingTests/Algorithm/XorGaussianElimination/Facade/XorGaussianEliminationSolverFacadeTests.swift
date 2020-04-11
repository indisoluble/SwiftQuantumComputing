//
//  XorGaussianEliminationSolverFacadeTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 05/01/2020.
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

class XorGaussianEliminationSolverFacadeTests: XCTestCase {

    // MARK: - Properties

    let secondarySolver = XorEquationSystemSimpleSolverTestDouble()

    // MARK: - Tests

    func testNoEquations_findActivatedVariablesInEquations_passEmptyListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations([]), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, [])
    }

    func testOneEmptyEquation_findActivatedVariablesInEquations_passEmptyListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        XCTAssertEqual(sut.findActivatedVariablesInEquations([[]]), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations, [])
    }

    func testEquationWithOneVar_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let varId = 1
        let equations: Set<Set<Int>> = [[varId]]
        let expectedSecondaryEquations = [[XorEquationComponent.variable(id: varId)]]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)
        XCTAssertEqual(secondarySolver.lastFindActivatedVariablesInEquationsEquations,
                       expectedSecondaryEquations)
    }

    func testEquationWithTwoVars_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let lowVarId = 1
        let highVarId = 2
        let equations: Set<Set<Int>> = [[highVarId, lowVarId]]
        let expectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: highVarId), .variable(id: lowVarId)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)

        let secondaryEquations = secondarySolver.lastFindActivatedVariablesInEquationsEquations ?? []
        XCTAssertEqual(Set(secondaryEquations.map { Set($0) }), expectedSecondaryEquations)
    }

    func testTwoEquationsOneWithHigherIdThanTheOther_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let lowVarId = 1
        let highVarId = 2
        let equations: Set<Set<Int>> = [[highVarId, lowVarId], [lowVarId]]
        let expectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: highVarId), .variable(id: lowVarId)],
            [.variable(id: lowVarId)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)

        let secondaryEquations = secondarySolver.lastFindActivatedVariablesInEquationsEquations ?? []
        XCTAssertEqual(Set(secondaryEquations.map { Set($0) }), expectedSecondaryEquations)
    }

    func testTwoEquationsBothWithSameHighId_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let lowVarId = 1
        let highVarId = 2
        let equations: Set<Set<Int>> = [[highVarId, lowVarId], [highVarId]]
        let oneExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: highVarId), .variable(id: lowVarId)],
            [.variable(id: lowVarId)]
        ]
        let otherExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: highVarId)],
            [.variable(id: lowVarId)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)

        let secondaryEquations = secondarySolver.lastFindActivatedVariablesInEquationsEquations ?? []
        let secondaryEquationSet = Set(secondaryEquations.map { Set($0) })
        XCTAssertTrue((secondaryEquationSet == oneExpectedSecondaryEquations) ||
            (secondaryEquationSet == otherExpectedSecondaryEquations))
    }

    func testThreeEquationsWhereOneIsCancelled_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let lowVarId = 1
        let highVarId = 2
        let higherVardId = 3
        let equations: Set<Set<Int>> = [
            [highVarId],
            [higherVardId, lowVarId],
            [higherVardId, highVarId, lowVarId]
        ]
        let oneExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: higherVardId), .variable(id: highVarId), .variable(id: lowVarId)],
            [.variable(id: highVarId)]
        ]
        let otherExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: higherVardId), .variable(id: lowVarId)],
            [.variable(id: highVarId)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)

        let secondaryEquations = secondarySolver.lastFindActivatedVariablesInEquationsEquations ?? []
        let secondaryEquationSet = Set(secondaryEquations.map { Set($0) })
        XCTAssertTrue((secondaryEquationSet == oneExpectedSecondaryEquations) ||
            (secondaryEquationSet == otherExpectedSecondaryEquations))
    }

    func testThreeEquationsWhereOneIsCancelledAndOneIndependentEquation_findActivatedVariablesInEquations_passExpectedListToSecondary() {
        // Given
        let sut = XorGaussianEliminationSolverFacade(solver: secondarySolver)

        let expectedResult = [[1]]
        secondarySolver.findActivatedVariablesInEquationsResult = expectedResult

        // Then
        let lowerVarId = 0
        let lowVarId = 1
        let highVarId = 2
        let higherVardId = 3
        let equations: Set<Set<Int>> = [
            [highVarId],
            [higherVardId, lowVarId],
            [higherVardId, highVarId, lowVarId],
            [lowerVarId]
        ]
        let oneExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: higherVardId), .variable(id: highVarId), .variable(id: lowVarId)],
            [.variable(id: highVarId)],
            [.variable(id: lowerVarId)]
        ]
        let otherExpectedSecondaryEquations: Set<Set<XorEquationComponent>> = [
            [.variable(id: higherVardId), .variable(id: lowVarId)],
            [.variable(id: highVarId)],
            [.variable(id: lowerVarId)]
        ]

        XCTAssertEqual(sut.findActivatedVariablesInEquations(equations), expectedResult)
        XCTAssertEqual(secondarySolver.findActivatedVariablesInEquationsCount, 1)

        let secondaryEquations = secondarySolver.lastFindActivatedVariablesInEquationsEquations ?? []
        let secondaryEquationSet = Set(secondaryEquations.map { Set($0) })
        XCTAssertTrue((secondaryEquationSet == oneExpectedSecondaryEquations) ||
            (secondaryEquationSet == otherExpectedSecondaryEquations))
    }

    static var allTests = [
        ("testNoEquations_findActivatedVariablesInEquations_passEmptyListToSecondary",
         testNoEquations_findActivatedVariablesInEquations_passEmptyListToSecondary),
        ("testOneEmptyEquation_findActivatedVariablesInEquations_passEmptyListToSecondary",
         testOneEmptyEquation_findActivatedVariablesInEquations_passEmptyListToSecondary),
        ("testEquationWithOneVar_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testEquationWithOneVar_findActivatedVariablesInEquations_passExpectedListToSecondary),
        ("testEquationWithTwoVars_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testEquationWithTwoVars_findActivatedVariablesInEquations_passExpectedListToSecondary),
        ("testTwoEquationsOneWithHigherIdThanTheOther_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testTwoEquationsOneWithHigherIdThanTheOther_findActivatedVariablesInEquations_passExpectedListToSecondary),
        ("testTwoEquationsBothWithSameHighId_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testTwoEquationsBothWithSameHighId_findActivatedVariablesInEquations_passExpectedListToSecondary),
        ("testThreeEquationsWhereOneIsCancelled_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testThreeEquationsWhereOneIsCancelled_findActivatedVariablesInEquations_passExpectedListToSecondary),
        ("testThreeEquationsWhereOneIsCancelledAndOneIndependentEquation_findActivatedVariablesInEquations_passExpectedListToSecondary",
         testThreeEquationsWhereOneIsCancelledAndOneIndependentEquation_findActivatedVariablesInEquations_passExpectedListToSecondary)
    ]
}
