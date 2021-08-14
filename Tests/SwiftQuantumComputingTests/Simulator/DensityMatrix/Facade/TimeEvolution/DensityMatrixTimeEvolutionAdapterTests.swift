//
//  DensityMatrixTimeEvolutionAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class DensityMatrixTimeEvolutionAdapterTests: XCTestCase {

    // MARK: - Properties

    let transformation = DensityMatrixTransformationTestDouble()
    let anyMatrix = Matrix.makeNot()
    let otherMatrix = Matrix.makeHadamard()
    let anotherMatrix = try! Matrix.makeIdentity(count: 2).get()
    let gate = Gate.oracle(truthTable: ["00"], controls: [1, 2], gate: .not(target: 0))

    // MARK: - Tests

    func testNonSquareMatrix_init_throwException() {
        // Given
        let nonSquareMatrix = try! Matrix([[.zero, .zero, .one]])

        // Then
        XCTAssertThrowsError(try DensityMatrixTimeEvolutionAdapter(state: nonSquareMatrix,
                                                                   transformation: transformation))
    }

    func testAnyMatrix_state_returnValue() {
        // Given
        let adapter = try! DensityMatrixTimeEvolutionAdapter(state: anyMatrix,
                                                             transformation: transformation)

        // When
        let result = adapter.state

        // Then
        XCTAssertEqual(result, anyMatrix)
    }

    func testValidMatrix_applying_forwardToTransformation() {
        // Given
        let adapter = try! DensityMatrixTimeEvolutionAdapter(state: otherMatrix,
                                                             transformation: transformation)

        transformation.applyResult = anotherMatrix

        // When
        let result = try? adapter.applying(gate).get()

        // Then
        XCTAssertEqual(transformation.applyCount, 1)
        XCTAssertEqual(transformation.lastApplyGate, gate)
        XCTAssertEqual(transformation.lastApplyDensityMatrix, otherMatrix)
        XCTAssertEqual(result?.state, anotherMatrix)
    }

    func testValidMatrixAndTransformationThatThrowsError_applying_throwError() {
        // Given
        let adapter = try! DensityMatrixTimeEvolutionAdapter(state: otherMatrix,
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
        XCTAssertEqual(transformation.lastApplyDensityMatrix, otherMatrix)
    }

    static var allTests = [
        ("testNonSquareMatrix_init_throwException",
         testNonSquareMatrix_init_throwException),
        ("testAnyMatrix_state_returnValue",
         testAnyMatrix_state_returnValue),
        ("testValidMatrix_applying_forwardToTransformation",
         testValidMatrix_applying_forwardToTransformation),
        ("testValidMatrixAndTransformationThatThrowsError_applying_throwError",
         testValidMatrixAndTransformationThatThrowsError_applying_throwError)
    ]
}
