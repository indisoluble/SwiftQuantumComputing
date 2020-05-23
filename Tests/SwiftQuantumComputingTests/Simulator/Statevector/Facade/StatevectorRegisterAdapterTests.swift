//
//  StatevectorRegisterAdapterTests.swift
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

class StatevectorRegisterAdapterTests: XCTestCase {

    // MARK: - Properties

    let transformation = StatevectorTransformationTestDouble()
    let oneQubitZeroVector = try! Vector([Complex.one, Complex.zero])
    let threeQubitZeroVector = try! Vector([
        Complex.one, Complex.zero, Complex.zero, Complex.zero,
        Complex.zero, Complex.zero, Complex.zero, Complex.zero
    ])
    let threeQubitFourVector = try! Vector([
        Complex.zero, Complex.zero, Complex.zero, Complex.zero,
        Complex.one, Complex.zero, Complex.zero, Complex.zero
    ])

    // MARK: - Tests

    func testVectorWhichCountIsNotAPowerOfTwo_init_throwException() {
        // Given
        let notPowerOfTwoVector = try! Vector([
            Complex.zero, Complex.zero, Complex.one
        ])

        // Then
        XCTAssertThrowsError(try StatevectorRegisterAdapter(vector: notPowerOfTwoVector,
                                                            transformation: transformation))
    }

    func testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException() {
        // Given
        let addSquareModulusNotEqualToOneVector = try! Vector([Complex.one, Complex.one])
        let adapter = try! StatevectorRegisterAdapter(vector: addSquareModulusNotEqualToOneVector,
                                                      transformation: transformation)

        // Then
        var error: StatevectorMeasurementError?
        if case .failure(let e) = adapter.statevector() {
            error = e
        }
        XCTAssertEqual(error, .statevectorAdditionOfSquareModulusIsNotEqualToOne)
    }

    func testValidVector_statevector_returnValue() {
        // Given
        let adapter = try! StatevectorRegisterAdapter(vector: oneQubitZeroVector,
                                                      transformation: transformation)

        // When
        let result = try? adapter.statevector().get()

        // Then
        XCTAssertEqual(result, oneQubitZeroVector)
    }

    func testValidVector_applying_forwardToTransformation() {
        // Given
        let adapter = try! StatevectorRegisterAdapter(vector: threeQubitZeroVector,
                                                      transformation: transformation)

        let controls = [1, 2]
        let target = 0
        let gate = Gate.oracle(truthTable: ["00"], target: target, controls: controls)

        transformation.applyResult = threeQubitFourVector

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(transformation.applyCount, 1)
        XCTAssertEqual(transformation.lastApplyVector, threeQubitZeroVector)
        XCTAssertEqual(transformation.lastApplyInputs, controls + [target])
        XCTAssertEqual(try? result?.statevector().get(), threeQubitFourVector)
    }

    static var allTests = [
        ("testVectorWhichCountIsNotAPowerOfTwo_init_throwException",
         testVectorWhichCountIsNotAPowerOfTwo_init_throwException),
        ("testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException",
         testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException),
        ("testValidVector_statevector_returnValue",
         testValidVector_statevector_returnValue),
        ("testValidVector_applying_forwardToTransformation",
         testValidVector_applying_forwardToTransformation)
    ]
}
