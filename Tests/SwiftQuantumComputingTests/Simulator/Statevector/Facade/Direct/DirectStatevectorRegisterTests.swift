//
//  DirectStatevectorRegisterTests.swift
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

class DirectStatevectorRegisterTests: XCTestCase {

    // MARK: - Properties

    let transformation = StatevectorRegisterTestDouble()
    let threeQubitZeroVector = try! Vector([
        Complex.one, Complex.zero, Complex.zero, Complex.zero,
        Complex.zero, Complex.zero, Complex.zero, Complex.zero
    ])
    let threeQubitFourVector = try! Vector([
        Complex.zero, Complex.zero, Complex.zero, Complex.zero,
        Complex.one, Complex.zero, Complex.zero, Complex.zero
    ])
    let threeQubitFiveVector = try! Vector([
        Complex.zero, Complex.zero, Complex.zero, Complex.zero,
        Complex.zero, Complex.one, Complex.zero, Complex.zero
    ])
    let oneQubitZeroVector = try! Vector([Complex.one, Complex.zero])
    let oneQubitOneVector = try! Vector([Complex.zero, Complex.one])

    // MARK: - Tests

    func testVectorWhichLengthIsNotPowerOfTwo_init_throwException() {
        // Given
        let noPowerOfTwoVector = try! Vector([Complex.one, Complex.zero, Complex.zero])

        // Then
        XCTAssertThrowsError(try DirectStatevectorRegister(vector: noPowerOfTwoVector,
                                                           transformation: transformation))
    }

    func testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException() {
        // Given
        let addSquareModulusNotEqualToOneVector = try! Vector([Complex.one, Complex.one])
        let adapter = try! DirectStatevectorRegister(vector: addSquareModulusNotEqualToOneVector,
                                                     transformation: transformation)

        // Then
        XCTAssertThrowsError(try adapter.statevector())
    }

    func testValidVector_statevector_returnValue() {
        // Given
        let vector = try! Vector([Complex.one, Complex.zero])
        let adapter = try! DirectStatevectorRegister(vector: vector, transformation: transformation)

        // When
        let result = try! adapter.statevector()

        // Then
        XCTAssertEqual(result, vector)
    }

    func testThreeQubitGate_applying_forwardToTransformation() {
        // Given
        let adapter = try! DirectStatevectorRegister(vector: threeQubitZeroVector,
                                                     transformation: transformation)

        let gate = Gate.oracle(truthTable: ["00"], target: 0, controls: [1, 2])

        let applyingResult = StatevectorRegisterTestDouble()
        applyingResult.vectorResult = threeQubitFourVector
        transformation.applyingResult = applyingResult

        // When
        let result = try? adapter.applying(gate)

        // Then
        XCTAssertEqual(transformation.applyingCount, 1)
        XCTAssertEqual(transformation.lastApplyingGate as? Gate, gate)
        XCTAssertEqual(applyingResult.vectorCount, 1)
        XCTAssertEqual(result?.vector, threeQubitFourVector)
    }

    func testNotGateAndOneQubitVector_applying_returnExpectedVector() {
        // Given
        let adapter = try! DirectStatevectorRegister(vector: oneQubitZeroVector,
                                                     transformation: transformation)

        // When
        let result = try? adapter.applying(Gate.not(target: 0))

        // Then
        XCTAssertEqual(result?.vector, oneQubitOneVector)
    }

    func testNotGateAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        let adapter = try! DirectStatevectorRegister(vector: threeQubitZeroVector,
                                                     transformation: transformation)

        // When
        let result = try? adapter.applying(Gate.not(target: 2))

        // Then
        XCTAssertEqual(result?.vector, threeQubitFourVector)
    }

    func testTwoNotGatesAndThreeQubitVector_applying_returnExpectedVector() {
        // Given
        let adapter = try! DirectStatevectorRegister(vector: threeQubitZeroVector,
                                                     transformation: transformation)

        // When
        let result = try? adapter.applying(Gate.not(target: 2)).applying(Gate.not(target: 0))

        // Then
        XCTAssertEqual(result?.vector, threeQubitFiveVector)
    }

    static var allTests = [
        ("testVectorWhichLengthIsNotPowerOfTwo_init_throwException",
         testVectorWhichLengthIsNotPowerOfTwo_init_throwException),
        ("testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException",
         testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_statevector_throwException),
        ("testValidVector_statevector_returnValue",
         testValidVector_statevector_returnValue),
        ("testThreeQubitGate_applying_forwardToTransformation",
         testThreeQubitGate_applying_forwardToTransformation),
        ("testNotGateAndOneQubitVector_applying_returnExpectedVector",
         testNotGateAndOneQubitVector_applying_returnExpectedVector),
        ("testNotGateAndThreeQubitVector_applying_returnExpectedVector",
         testNotGateAndThreeQubitVector_applying_returnExpectedVector),
        ("testTwoNotGatesAndThreeQubitVector_applying_returnExpectedVector",
         testTwoNotGatesAndThreeQubitVector_applying_returnExpectedVector)
    ]
}
