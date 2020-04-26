//
//  DirectStatevectorRegisterFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 25/04/2020.
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

class DirectStatevectorRegisterFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = StatevectorRegisterFactoryTestDouble()
    let transformation = StatevectorRegisterTestDouble()
    let squareModulusNotEqualToOneVector = try! Vector([
        Complex.zero, Complex.zero, Complex.one, Complex.one
    ])
    let validVector = try! Vector([Complex.zero, Complex.zero, Complex.one, Complex.zero])

    // MARK: - Tests

    func testFactoryThatThrowsError_makeRegister_throwError() {
        // Given
        factory.makeTransformationResult = nil
        factory.makeTransformationError = MakeTransformationError.stateCountHasToBeAPowerOfTwo

        let adapter = DirectStatevectorRegisterFactory(factory: factory)

        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: validVector))
    }

    func testFactoryThatDoesNotThrowErrorAndVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError() {
        // Given
        factory.makeTransformationResult = transformation

        let adapter = DirectStatevectorRegisterFactory(factory: factory)

        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: squareModulusNotEqualToOneVector))
    }

    func testFactoryThatDoesNotThrowErrorAndValidVector_makeRegister_returnValue() {
        // Given
        factory.makeTransformationResult = transformation

        let adapter = DirectStatevectorRegisterFactory(factory: factory)

        // Then
        XCTAssertNoThrow(try adapter.makeRegister(state: validVector))
    }

    static var allTests = [
        ("testFactoryThatThrowsError_makeRegister_throwError",
         testFactoryThatThrowsError_makeRegister_throwError),
        ("testFactoryThatDoesNotThrowErrorAndVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError",
         testFactoryThatDoesNotThrowErrorAndVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError),
        ("testFactoryThatDoesNotThrowErrorAndValidVector_makeRegister_returnValue",
         testFactoryThatDoesNotThrowErrorAndValidVector_makeRegister_returnValue)
    ]
}
