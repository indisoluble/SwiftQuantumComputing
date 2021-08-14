//
//  StatevectorTimeEvolutionAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/05/2020.
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

class StatevectorTimeEvolutionAdapterTests: XCTestCase {

    // MARK: - Properties

    let transformation = StatevectorTransformationTestDouble()
    let oneQubitZeroVector = try! Vector([.one, .zero])
    let threeQubitZeroVector = try! Vector([.one, .zero, .zero, .zero, .zero, .zero, .zero, .zero])
    let threeQubitFourVector = try! Vector([.zero, .zero, .zero, .zero, .one, .zero, .zero, .zero])
    let gate = Gate.oracle(truthTable: ["00"], controls: [1, 2], gate: .not(target: 0))

    // MARK: - Tests

    func testVectorWhichCountIsNotAPowerOfTwo_init_throwException() {
        // Given
        let notPowerOfTwoVector = try! Vector([.zero, .zero, .one])

        // Then
        XCTAssertThrowsError(try StatevectorTimeEvolutionAdapter(state: notPowerOfTwoVector,
                                                                 transformation: transformation))
    }

    func testAnyVector_state_returnValue() {
        // Given
        let adapter = try! StatevectorTimeEvolutionAdapter(state: oneQubitZeroVector,
                                                           transformation: transformation)

        // When
        let result = adapter.state

        // Then
        XCTAssertEqual(result, oneQubitZeroVector)
    }

    func testValidVector_applying_forwardToTransformation() {
        // Given
        let adapter = try! StatevectorTimeEvolutionAdapter(state: threeQubitZeroVector,
                                                           transformation: transformation)

        transformation.applyResult = threeQubitFourVector

        // When
        let result = try? adapter.applying(gate).get()

        // Then
        XCTAssertEqual(transformation.applyCount, 1)
        XCTAssertEqual(transformation.lastApplyGate, gate)
        XCTAssertEqual(transformation.lastApplyVector, threeQubitZeroVector)
        XCTAssertEqual(result?.state, threeQubitFourVector)
    }

    func testValidVectorAndTransformationThatThrowsError_applying_throwError() {
        // Given
        let adapter = try! StatevectorTimeEvolutionAdapter(state: threeQubitZeroVector,
                                                           transformation: transformation)

        transformation.applyError = .gateMatrixIsNotUnitary

        // Then
        var error: GateError?
        if case .failure(let e) = adapter.applying(gate) {
            error = e
        }

        XCTAssertEqual(error, .gateMatrixIsNotUnitary)
        XCTAssertEqual(transformation.applyCount, 1)
        XCTAssertEqual(transformation.lastApplyGate, gate)
        XCTAssertEqual(transformation.lastApplyVector, threeQubitZeroVector)
    }

    static var allTests = [
        ("testVectorWhichCountIsNotAPowerOfTwo_init_throwException",
         testVectorWhichCountIsNotAPowerOfTwo_init_throwException),
        ("testAnyVector_state_returnValue",
         testAnyVector_state_returnValue),
        ("testValidVector_applying_forwardToTransformation",
         testValidVector_applying_forwardToTransformation),
        ("testValidVectorAndTransformationThatThrowsError_applying_throwError",
         testValidVectorAndTransformationThatThrowsError_applying_throwError)
    ]
}
