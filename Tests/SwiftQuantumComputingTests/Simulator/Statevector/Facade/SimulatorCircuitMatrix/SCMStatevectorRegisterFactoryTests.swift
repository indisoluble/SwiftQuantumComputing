//
//  SCMStatevectorRegisterFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/02/2020.
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

class SCMStatevectorRegisterFactoryTests: XCTestCase {

    // MARK: - Properties

    let adapter = SCMStatevectorRegisterFactory(matrixFactory: SimulatorCircuitMatrixFactoryTestDouble())
    let notPowerOfTwoVector = try! Vector([
        Complex.zero, Complex.zero, Complex.one
    ])
    let squareModulusNotEqualToOneVector = try! Vector([
        Complex.zero, Complex.zero, Complex.one, Complex.one
    ])
    let validVector = try! Vector([Complex.zero, Complex.zero, Complex.one, Complex.zero])

    // MARK: - Tests

    func testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError() {
        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: notPowerOfTwoVector))
    }

    func testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError() {
        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: squareModulusNotEqualToOneVector))
    }

    func testValidVector_makeRegister_returnValue() {
        // Then
        XCTAssertNoThrow(try adapter.makeRegister(state: validVector))
    }

    func testVectorWhichCountIsNotAPowerOfTwo_makeTransformation_throwError() {
        // Then
        XCTAssertThrowsError(try adapter.makeTransformation(state: notPowerOfTwoVector))
    }

    func testVectorAdditionOfSquareModulusIsNotEqualToOne_makeTransformation_throwError() {
        // Then
        XCTAssertThrowsError(try adapter.makeTransformation(state: squareModulusNotEqualToOneVector))
    }

    func testValidVector_makeTransformation_returnValue() {
        // Then
        XCTAssertNoThrow(try adapter.makeTransformation(state: validVector))
    }

    static var allTests = [
        ("testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError",
         testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError),
        ("testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError",
         testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError),
        ("testValidVector_makeRegister_returnValue",
         testValidVector_makeRegister_returnValue),
        ("testVectorWhichCountIsNotAPowerOfTwo_makeTransformation_throwError",
         testVectorWhichCountIsNotAPowerOfTwo_makeTransformation_throwError),
        ("testVectorAdditionOfSquareModulusIsNotEqualToOne_makeTransformation_throwError",
         testVectorAdditionOfSquareModulusIsNotEqualToOne_makeTransformation_throwError),
        ("testValidVector_makeTransformation_returnValue",
         testValidVector_makeTransformation_returnValue)
    ]
}
