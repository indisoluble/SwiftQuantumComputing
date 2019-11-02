//
//  QuantumRegisterTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 10/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

class QuantumRegisterTests: XCTestCase {

    // MARK: - Tests

    func testVectorWhichLengthIsNotPowerOfTwo_init_throwException() {
        // Given
        let vector = try! Vector([Complex(real: sqrt(1 / 2), imag: 0),
                                  Complex(real: 0, imag: sqrt(1 / 2)),
                                  Complex(real: 0, imag: 0)])

        // Then
        XCTAssertThrowsError(try QuantumRegister(vector: vector))
    }

    func testVectorWhichSumOfSquareModulesIsNotOne_init_throwException() {
        // Given
        let vector = try! Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: 2)])

        // Then
        XCTAssertThrowsError(try QuantumRegister(vector: vector))
    }

    func testVectorWhichSumOfSquareModulesIsOne_init_returnRegister() {
        // Given
        let vector = try! Vector([Complex(real: sqrt(1 / 2), imag: 0),
                                  Complex(real: 0, imag: sqrt(1 / 2))])

        // Then
        XCTAssertNoThrow(try QuantumRegister(vector: vector))
    }

    func testAnyRegister_qubitCount_returnExpectedValue() {
        // Given
        let qubitCount = 3
        var elements = Array(repeating: Complex(0), count: Int.pow(2, qubitCount))
        elements[0] = Complex(1)

        let vector = try! Vector(elements)
        let register = try! QuantumRegister(vector: vector)

        // Then
        XCTAssertEqual(register.qubitCount, qubitCount)
    }

    static var allTests = [
        ("testVectorWhichLengthIsNotPowerOfTwo_init_throwException",
         testVectorWhichLengthIsNotPowerOfTwo_init_throwException),
        ("testVectorWhichSumOfSquareModulesIsNotOne_init_throwException",
         testVectorWhichSumOfSquareModulesIsNotOne_init_throwException),
        ("testVectorWhichSumOfSquareModulesIsOne_init_returnRegister",
         testVectorWhichSumOfSquareModulesIsOne_init_returnRegister),
        ("testAnyRegister_qubitCount_returnExpectedValue",
         testAnyRegister_qubitCount_returnExpectedValue)
    ]
}
