//
//  XorEquationSystemAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 29/12/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

class XorEquationSystemAdapterTests: XCTestCase {

    // MARK: - Properties

    let equationWithTwoVarsAndOneActiveCte: [XorEquationComponent] = [
        .variable(id: 0),
        .variable(id: 1),
        .constant(activated: true)
    ]
    let equationWithOneVarAndOneSharedVar: [XorEquationComponent] = [
        .variable(id: 1),
        .variable(id: 2)
    ]
    let equationWithRepeatedVarsAndOneActiveCte: [XorEquationComponent] = [
        .variable(id: 0),
        .variable(id: 1),
        .variable(id: 1),
        .constant(activated: true)
    ]
    let equationWithOnlyRepeatedVarsAndOneActiveCte: [XorEquationComponent] = [
        .variable(id: 0),
        .variable(id: 0),
        .variable(id: 0),
        .constant(activated: true)
    ]
    let equationWithOneActiveCteAndDeactiveCte: [XorEquationComponent] = [
        .constant(activated: true),
        .constant(activated: false)
    ]
    let equationWithTwoActiveCtes: [XorEquationComponent] = [
        .constant(activated: true),
        .constant(activated: true)
    ]

    // MARK: - Tests

    func testOneEquationWithTwoVarsAndOneActiveCteAndEmptyActivationList_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithTwoVarsAndOneActiveCte])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: []))
    }

    func testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingUnknownVars_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithTwoVarsAndOneActiveCte])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: [2, 3]))
    }

    func testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingOne_solves_returnTrue() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithTwoVarsAndOneActiveCte])

        // Then
        XCTAssertTrue(system.solves(activatingVariables: [1]))
    }

    func testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingBoth_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithTwoVarsAndOneActiveCte])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: [0, 1]))
    }

    func testOneEquationWithOnlyTwoVarsAndListActivatingOne_solves_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithOneVarAndOneSharedVar])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: [1]))
    }

    func testTwoEquationsAndListActivationThatMakesOneTrue_solves_returnFalse() {
        // Given
        let equations = [equationWithTwoVarsAndOneActiveCte, equationWithOneVarAndOneSharedVar]
        let system = XorEquationSystemAdapter(equations: equations)

        // Then
        XCTAssertFalse(system.solves(activatingVariables: [1]))
    }

    func testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingBothVars_solves_returnTrue() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithRepeatedVarsAndOneActiveCte])

        // Then
        XCTAssertTrue(system.solves(activatingVariables: [0, 1]))
    }

    func testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingNonRepeatedVar_solves_returnTrue() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithRepeatedVarsAndOneActiveCte])

        // Then
        XCTAssertTrue(system.solves(activatingVariables: [0]))
    }

    func testOneEquationWithOneRepeatedVarAndOneActiveCteAndListActivatingVar_solves_returnTrue() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithOnlyRepeatedVarsAndOneActiveCte])

        // Then
        XCTAssertTrue(system.solves(activatingVariables: [0]))
    }

    func testOneEquationWithOneRepeatedVarAndOneActiveCteAndEmptyActivationList_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithOnlyRepeatedVarsAndOneActiveCte])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: []))
    }

    func testOneEquationWithOneActiveCteAndOneDeactiveCteAndAnyActivationList_solves_returnFalse() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithOneActiveCteAndDeactiveCte])

        // Then
        XCTAssertFalse(system.solves(activatingVariables: []))
    }

    func testOneEquationWithTwoActiveCtesAndAnyActivationList_solves_returnTrue() {
        // Given
        let system = XorEquationSystemAdapter(equations: [equationWithTwoActiveCtes])

        // Then
        XCTAssertTrue(system.solves(activatingVariables: []))
    }

    static var allTests = [
        ("testOneEquationWithTwoVarsAndOneActiveCteAndEmptyActivationList_solves_returnFalse",
         testOneEquationWithTwoVarsAndOneActiveCteAndEmptyActivationList_solves_returnFalse),
        ("testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingUnknownVars_solves_returnFalse",
         testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingUnknownVars_solves_returnFalse),
        ("testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingOne_solves_returnTrue",
         testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingOne_solves_returnTrue),
        ("testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingBoth_solves_returnFalse",
         testOneEquationWithTwoVarsAndOneActiveCteAndListActivatingBoth_solves_returnFalse),
        ("testOneEquationWithOnlyTwoVarsAndListActivatingOne_solves_solves_returnFalse",
         testOneEquationWithOnlyTwoVarsAndListActivatingOne_solves_solves_returnFalse),
        ("testTwoEquationsAndListActivationThatMakesOneTrue_solves_returnFalse",
         testTwoEquationsAndListActivationThatMakesOneTrue_solves_returnFalse),
        ("testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingBothVars_solves_returnTrue",
         testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingBothVars_solves_returnTrue),
        ("testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingNonRepeatedVar_solves_returnTrue",
         testOneEquationWithOneRepeatedVarOneOtherVarAndOneActiveCteAndListActivatingNonRepeatedVar_solves_returnTrue),
        ("testOneEquationWithOneRepeatedVarAndOneActiveCteAndListActivatingVar_solves_returnTrue",
         testOneEquationWithOneRepeatedVarAndOneActiveCteAndListActivatingVar_solves_returnTrue),
        ("testOneEquationWithOneRepeatedVarAndOneActiveCteAndEmptyActivationList_solves_returnFalse",
         testOneEquationWithOneRepeatedVarAndOneActiveCteAndEmptyActivationList_solves_returnFalse),
        ("testOneEquationWithOneActiveCteAndOneDeactiveCteAndAnyActivationList_solves_returnFalse",
         testOneEquationWithOneActiveCteAndOneDeactiveCteAndAnyActivationList_solves_returnFalse),
        ("testOneEquationWithTwoActiveCtesAndAnyActivationList_solves_returnTrue",
         testOneEquationWithTwoActiveCtesAndAnyActivationList_solves_returnTrue)
    ]
}
