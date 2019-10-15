//
//  Register+ApplyingGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/10/2019.
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

class Register_ApplyingGateTests: XCTestCase {

    // MARK: - Tests

    func testAnyRegisterAndRegisterGateWithDifferentSizeThanRegister_applying_throwException() {
        // Given
        let register = try! Register(bits: "00")

        let matrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrix)

        // Then
        XCTAssertThrowsError(try register.applying(gate))
    }

    func testAnyRegisterAndRegisterGateWithSameSizeThanRegister_applying_returnExpectedRegister() {
        // Given
        let register = try! Register(bits: "0")

        let matrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let gate = try! RegisterGate(matrix: matrix)

        // When
        let result = try? register.applying(gate)

        // Then
        let expectedResult = try! Register(vector: try! Vector([Complex(0), Complex(1)]))
        XCTAssertEqual(result, expectedResult)
    }

    func testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne() {
        // Given
        let qubitCount = 2

        var register = try! Register(bits: String(repeating: "0", count: qubitCount))

        let notMatrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let factory = try! RegisterGateFactory(qubitCount: qubitCount, baseMatrix: notMatrix)
        let notGate = try! factory.makeGate(inputs: [0])

        // When
        register = try! register.applying(notGate)

        // Then
        let expectedVector = try! Vector([Complex(0), Complex(1), Complex(0), Complex(0)])
        XCTAssertEqual(register.statevector, expectedVector)
    }

    static var allTests = [
        ("testAnyRegisterAndRegisterGateWithDifferentSizeThanRegister_applying_throwException",
         testAnyRegisterAndRegisterGateWithDifferentSizeThanRegister_applying_throwException),
        ("testAnyRegisterAndRegisterGateWithSameSizeThanRegister_applying_returnExpectedRegister",
         testAnyRegisterAndRegisterGateWithSameSizeThanRegister_applying_returnExpectedRegister),
        ("testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne",
         testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_oneHasProbabilityOne)
    ]
}
