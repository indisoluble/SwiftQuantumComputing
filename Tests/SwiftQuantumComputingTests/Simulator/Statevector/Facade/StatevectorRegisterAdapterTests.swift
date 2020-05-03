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

    let factory = StatevectorRegisterFactoryTestDouble()
    let transformation = StatevectorRegisterTestDouble()
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

    func testFactoryThatThrowsException_init_throwException() {
        // Given
        factory.makeTransformationResult = nil
        factory.makeTransformationError = MakeTransformationError.stateCountHasToBeAPowerOfTwo

        // Then
        XCTAssertThrowsError(try StatevectorRegisterAdapter(vector: oneQubitZeroVector,
                                                            factory: factory))
        XCTAssertEqual(factory.makeTransformationCount, 1)
    }

    func testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException() {
        // Given
        factory.makeTransformationResult = transformation
        let addSquareModulusNotEqualToOneVector = try! Vector([Complex.one, Complex.one])
        let adapter = try! StatevectorRegisterAdapter(vector: addSquareModulusNotEqualToOneVector,
                                                      factory: factory)

        // Then
        XCTAssertThrowsError(try adapter.statevector())
    }

    func testValidVector_statevector_returnValue() {
        // Given
        factory.makeTransformationResult = transformation
        let adapter = try! StatevectorRegisterAdapter(vector: oneQubitZeroVector, factory: factory)

        // When
        let result = try! adapter.statevector()

        // Then
        XCTAssertEqual(result, oneQubitZeroVector)
    }

    func testValidVector_applying_forwardToTransformation() {
        // Given
        factory.makeTransformationResult = transformation
        let adapter = try! StatevectorRegisterAdapter(vector: threeQubitZeroVector,
                                                      factory: factory)

        let gate = Gate.oracle(truthTable: ["00"], target: 0, controls: [1, 2])

        transformation.statevectorApplyingResult = threeQubitFourVector

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(transformation.statevectorApplyingCount, 1)
        XCTAssertEqual(try? result?.statevector(), threeQubitFourVector)
    }

    static var allTests = [
        ("testFactoryThatThrowsException_init_throwException",
         testFactoryThatThrowsException_init_throwException),
        ("testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException",
         testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException),
        ("testValidVector_statevector_returnValue",
         testValidVector_statevector_returnValue),
        ("testValidVector_applying_forwardToTransformation",
         testValidVector_applying_forwardToTransformation)
    ]
}
