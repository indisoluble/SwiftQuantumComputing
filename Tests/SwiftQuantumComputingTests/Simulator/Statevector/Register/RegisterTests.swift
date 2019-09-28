//
//  RegisterTests.swift
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

class RegisterTests: XCTestCase {

    // MARK: - Tests

    func testEmptyBitsString_init_throwException() {
        // Then
        XCTAssertThrowsError(try Register(bits: ""))
    }

    func testBitsStringWithLeadingSpaces_init_throwException() {
        // Then
        XCTAssertThrowsError(try Register(bits: "  1001"))
    }

    func testBitsStringWithTrailingSpaces_init_throwException() {
        // Then
        XCTAssertThrowsError(try Register(bits: "1001  "))
    }

    func testBitsStringWithWrongCharacter_init_throwException() {
        // Then
        XCTAssertThrowsError(try Register(bits: "10#1"))
    }

    func testVectorWhichSumOfSquareModulesIsNotOne_init_throwException() {
        // Given
        let vector = try! Vector([Complex(real: 1, imag: 1), Complex(real: 2, imag: 2)])

        // Then
        XCTAssertThrowsError(try Register(vector: vector))
    }

    func testVectorWhichSumOfSquareModulesIsOne_init_returnRegister() {
        // Given
        let vector = try! Vector([Complex(real: sqrt(1 / 2), imag: 0),
                                  Complex(real: 0, imag: sqrt(1 / 2))])

        // Then
        XCTAssertNoThrow(try Register(vector: vector))
    }

    func testQubitCountBiggerThanZero_init_returnExpectedRegister() {
        // Then
        let register = try? Register(bits: "000")

        let elements = [Complex(1), Complex(0), Complex(0), Complex(0),
                        Complex(0), Complex(0), Complex(0), Complex(0)]
        let vector = try! Vector(elements)
        let expectedRegister = try? Register(vector: vector)

        XCTAssertNotNil(register)
        XCTAssertNotNil(expectedRegister)
        XCTAssertEqual(register, expectedRegister)
    }

    func testCorrectBitsString_init_returnExpectedRegister() {
        // Then
        let bits = "011"
        let register = try? Register(bits: bits)

        let elements = [Complex(0), Complex(0), Complex(0), Complex(1),
                        Complex(0), Complex(0), Complex(0), Complex(0)]
        let vector = try! Vector(elements)
        let expectedRegister = try? Register(vector: vector)

        XCTAssertNotNil(register)
        XCTAssertNotNil(expectedRegister)
        XCTAssertEqual(register, expectedRegister)
    }

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

    func testAnyRegisterAndZeroQubits_measure_throwException() {
        // Given
        let register = try! Register(bits: "000")

        // Then
        XCTAssertThrowsError(try register.measure(qubits: []))
    }

    func testAnyRegisterAndRepeatedQubits_measure_throwException() {
        // Given
        let register = try! Register(bits: "000")

        // Then
        XCTAssertThrowsError(try register.measure(qubits: [0, 0]))
    }

    func testAnyRegisterAndQubitsOutOfBound_measure_throwException() {
        // Given
        let register = try! Register(bits: "000")

        // Then
        XCTAssertThrowsError(try register.measure(qubits: [100, 0]))
    }

    func testAnyRegisterAndNegativeQubits_measure_throwException() {
        // Given
        let register = try! Register(bits: "000")

        // Then
        XCTAssertThrowsError(try register.measure(qubits: [0, -1]))
    }

    func testAnyRegisterAndUnsortedQubits_measure_throwException() {
        // Given
        let register = try! Register(bits: "000")

        // Then
        XCTAssertThrowsError(try register.measure(qubits: [0, 1]))
    }

    func testAnyRegisterAndOneQubit_measure_returnExpectedProbabilities() {
        // Given
        let prob = (1 / sqrt(5))
        let vector = try! Vector([Complex(0), Complex(prob), Complex(prob), Complex(prob),
                                  Complex(prob), Complex(0), Complex(0), Complex(prob)])
        let register = try! Register(vector: vector)

        // When
        let measures = try! register.measure(qubits: [0])

        // Then
        let expectedMeasures = [(Double(2) / Double(5)), (Double(3) / Double(5))]

        XCTAssertEqual(measures.count, expectedMeasures.count)
        for index in 0..<measures.count {
            XCTAssertEqual(measures[index], expectedMeasures[index], accuracy: 0.001)
        }
    }

    func testAnyRegisterAndTwoQubits_measure_returnExpectedProbabilities() {
        // Given
        let prob = (1 / sqrt(5))
        let vector = try! Vector([Complex(0), Complex(prob), Complex(prob), Complex(prob),
                                  Complex(prob), Complex(0), Complex(0), Complex(prob)])
        let register = try! Register(vector: vector)

        // When
        let measures = try! register.measure(qubits: [1, 0])

        // Then
        let expectedMeasures = [(Double(1) / Double(5)), (Double(1) / Double(5)),
                                (Double(1) / Double(5)), (Double(2) / Double(5))]

        XCTAssertEqual(measures.count, expectedMeasures.count)
        for index in 0..<measures.count {
            XCTAssertEqual(measures[index], expectedMeasures[index], accuracy: 0.001)
        }
    }

    func testRegisterInitializedWithoutAVector_measure_zeroHasProbabilityOne() {
        // Given
        let register = try! Register(bits: "00")

        // Then
        let expectedMeasurements = [Double(1), Double(0), Double(0), Double(0)]
        XCTAssertEqual(try? register.measure(qubits: [1, 0]), expectedMeasurements)
    }

    func testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_OneHasProbabilityOne() {
        // Given
        let qubitCount = 2

        var register = try! Register(bits: String(repeating: "0", count: qubitCount))
        
        let notMatrix = try! Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])
        let factory = try! RegisterGateFactory(qubitCount: qubitCount, baseMatrix: notMatrix)
        let notGate = try! factory.makeGate(inputs: [0])

        // When
        register = try! register.applying(notGate)

        // Then
        let expectedMeasurements = [Double(0), Double(1), Double(0), Double(0)]
        XCTAssertEqual(try? register.measure(qubits: [1, 0]), expectedMeasurements)
    }

    static var allTests = [
        ("testEmptyBitsString_init_throwException",
         testEmptyBitsString_init_throwException),
        ("testBitsStringWithLeadingSpaces_init_throwException",
         testBitsStringWithLeadingSpaces_init_throwException),
        ("testBitsStringWithTrailingSpaces_init_throwException",
         testBitsStringWithTrailingSpaces_init_throwException),
        ("testBitsStringWithWrongCharacter_init_throwException",
         testBitsStringWithWrongCharacter_init_throwException),
        ("testVectorWhichSumOfSquareModulesIsNotOne_init_throwException",
         testVectorWhichSumOfSquareModulesIsNotOne_init_throwException),
        ("testVectorWhichSumOfSquareModulesIsOne_init_returnRegister",
         testVectorWhichSumOfSquareModulesIsOne_init_returnRegister),
        ("testQubitCountBiggerThanZero_init_returnExpectedRegister",
         testQubitCountBiggerThanZero_init_returnExpectedRegister),
        ("testCorrectBitsString_init_returnExpectedRegister",
         testCorrectBitsString_init_returnExpectedRegister),
        ("testAnyRegisterAndRegisterGateWithDifferentSizeThanRegister_applying_throwException",
         testAnyRegisterAndRegisterGateWithDifferentSizeThanRegister_applying_throwException),
        ("testAnyRegisterAndRegisterGateWithSameSizeThanRegister_applying_returnExpectedRegister",
         testAnyRegisterAndRegisterGateWithSameSizeThanRegister_applying_returnExpectedRegister),
        ("testAnyRegisterAndZeroQubits_measure_throwException",
         testAnyRegisterAndZeroQubits_measure_throwException),
        ("testAnyRegisterAndRepeatedQubits_measure_throwException",
         testAnyRegisterAndRepeatedQubits_measure_throwException),
        ("testAnyRegisterAndQubitsOutOfBound_measure_throwException",
         testAnyRegisterAndQubitsOutOfBound_measure_throwException),
        ("testAnyRegisterAndNegativeQubits_measure_throwException",
         testAnyRegisterAndNegativeQubits_measure_throwException),
        ("testAnyRegisterAndUnsortedQubits_measure_throwException",
         testAnyRegisterAndUnsortedQubits_measure_throwException),
        ("testAnyRegisterAndOneQubit_measure_returnExpectedProbabilities",
         testAnyRegisterAndOneQubit_measure_returnExpectedProbabilities),
        ("testAnyRegisterAndTwoQubits_measure_returnExpectedProbabilities",
         testAnyRegisterAndTwoQubits_measure_returnExpectedProbabilities),
        ("testRegisterInitializedWithoutAVector_measure_zeroHasProbabilityOne",
         testRegisterInitializedWithoutAVector_measure_zeroHasProbabilityOne),
        ("testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_OneHasProbabilityOne",
         testTwoQubitsRegisterInitializedWithoutAVectorAndNotGate_applyNotGateToLeastSignificantQubit_OneHasProbabilityOne)
    ]
}
