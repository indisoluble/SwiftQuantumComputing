//
//  MainCircuitStatevectorFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/06/2020.
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

class MainCircuitStatevectorFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = MainCircuitStatevectorFactory()

    let nonPowerOfTwoVector = try! Vector([.zero, .zero, .one])
    let squareModulusNotEqualToOneVector = try! Vector([.zero, .zero, .one, .one])
    let validVector = try! Vector([.zero, .zero, .one, .zero])

    // MARK: - Tests

    func testNonPowerOfTwoVector_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorError?
        if case .failure(let e) = factory.makeStatevector(vector: nonPowerOfTwoVector) {
            error = e
        }
        XCTAssertEqual(error, .vectorCountHasToBeAPowerOfTwo)
    }

    func testSquareModulusNotEqualToOneVector_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorError?
        if case .failure(let e) = factory.makeStatevector(vector: squareModulusNotEqualToOneVector) {
            error = e
        }
        XCTAssertEqual(error, .vectorAdditionOfSquareModulusIsNotEqualToOne)
    }

    func testValidVector_makeStatevector_returnValue() {
        // Then
        var result: CircuitStatevector?
        if case .success(let r) = factory.makeStatevector(vector: validVector) {
            result = r
        }
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testNonPowerOfTwoVector_makeStatevector_throwException",
         testNonPowerOfTwoVector_makeStatevector_throwException),
        ("testSquareModulusNotEqualToOneVector_makeStatevector_throwException",
         testSquareModulusNotEqualToOneVector_makeStatevector_throwException),
        ("testValidVector_makeStatevector_returnValue",
         testValidVector_makeStatevector_returnValue)
    ]
}
