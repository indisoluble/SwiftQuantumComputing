//
//  TwoLevelDecompositionSolver+GatesTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/10/2020.
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

class TwoLevelDecompositionSolver_GatesTests: XCTestCase {

    // MARK: - Properties

    let sut = TwoLevelDecompositionSolverFacade(singleQubitGateDecomposer: DummySingleQubitGateDecompositionSolver())

    // MARK: - Tests

    func testEmptyList_decomposeGates_returnEmptyList() {
        // Then
        XCTAssertEqual(try? sut.decomposeGates([]).get(), [])
    }

    func testGateThatThrowsError_decomposeGates_throwError() {
        // Given
        let gate = Gate.matrix(matrix: .makeControlledNot(), inputs: [1])

        // Then
        var error: DecomposeGatesError?
        if case .failure(let e) = sut.decomposeGates([gate]) {
            error = e
        }
        XCTAssertEqual(error,
                       .gateThrowedError(gate: gate,
                                         error: .operatorInputCountDoesNotMatchOperatorMatrixQubitCount))
    }

    func testSameGateTwice_decomposeGates_returnExpectedDecomposition() {
        // Given
        let gate = Gate.oracle(truthTable: ["0"],
                               controls: [1],
                               gate: .matrix(matrix: .makeNot(), inputs: [0]))
        let qubitCount = 5

        let decomposition = try! sut.decomposeGate(gate,
                                                   restrictedToCircuitQubitCount: qubitCount).get()

        // When
        let result = try? sut.decomposeGates([gate, gate],
                                             restrictedToCircuitQubitCount: qubitCount).get()

        // Then
        XCTAssertEqual(result, decomposition + decomposition)
    }

    static var allTests = [
        ("testEmptyList_decomposeGates_returnEmptyList",
         testEmptyList_decomposeGates_returnEmptyList),
        ("testGateThatThrowsError_decomposeGates_throwError",
         testGateThatThrowsError_decomposeGates_throwError),
        ("testSameGateTwice_decomposeGates_returnExpectedDecomposition",
         testSameGateTwice_decomposeGates_returnExpectedDecomposition)
    ]
}
