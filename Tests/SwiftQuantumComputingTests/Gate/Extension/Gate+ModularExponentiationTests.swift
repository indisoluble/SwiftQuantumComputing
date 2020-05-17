//
//  Gate+ModularExponentiationTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/03/2020.
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

class Gate_ModularExponentiationTests: XCTestCase {

    // MARK: - Properties

    let base = 2
    let modulus = 5
    let inputs = [2, 1, 0]
    let exponent = [4, 3]

    // MARK: - Tests

    func testBaseEqualToZero_makeModularExponentiation_throwError() {
        // Then
        XCTAssertThrowsError(try Gate.makeModularExponentiation(base: 0,
                                                                modulus: modulus,
                                                                exponent: exponent,
                                                                inputs: inputs))
    }

    func testModulusEqualToOne_makeModularExponentiation_throwError() {
        // Then
        XCTAssertThrowsError(try Gate.makeModularExponentiation(base: base,
                                                                modulus: 1,
                                                                exponent: exponent,
                                                                inputs: inputs))
    }

    func testEmptyInputs_makeModularExponentiation_throwError() {
        // Then
        XCTAssertThrowsError(try Gate.makeModularExponentiation(base: base,
                                                                modulus: modulus,
                                                                exponent: exponent,
                                                                inputs: []))
    }

    func testModulusPowerOfBase_makeModularExponentiation_throwError() {
        // Then
        XCTAssertThrowsError(try Gate.makeModularExponentiation(base: base,
                                                                modulus: Int.pow(base, 3),
                                                                exponent: exponent,
                                                                inputs: inputs))
    }

    func testValidParameters_makeModularExponentiation_returnExpectedList() {
        // When
        let gates = try? Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs)
        // Then
        let firstMatrix = try! Matrix([
            [Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one]
        ])
        let secondMatrix = try! Matrix([
            [Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.one,  Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero, Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one,  Complex.zero],
            [Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.zero, Complex.one]
        ])
        let expectedGates = [
            Gate.controlledMatrix(matrix: firstMatrix, inputs: inputs, control: exponent[1]),
            Gate.controlledMatrix(matrix: secondMatrix, inputs: inputs, control: exponent[0])
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testFullMatrixCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs)
        let circuit = MainCircuitFactory(statevectorConfiguration: .fullMatrix).makeCircuit(gates: gates)

        // When
        let probs = try! circuit.summarizedProbabilities(byQubits: inputs, withInitialBits: "11001")

        // Then
        XCTAssertEqual(probs, ["011" : 1.0])
    }

    func testRowByRowCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs)
        let circuit = MainCircuitFactory(statevectorConfiguration: .rowByRow).makeCircuit(gates: gates)

        // When
        let probs = try! circuit.summarizedProbabilities(byQubits: inputs, withInitialBits: "11001")

        // Then
        XCTAssertEqual(probs, ["011" : 1.0])
    }

    func testElementByElementCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs)
        let circuit = MainCircuitFactory(statevectorConfiguration: .elementByElement).makeCircuit(gates: gates)

        // When
        let probs = try! circuit.summarizedProbabilities(byQubits: inputs, withInitialBits: "11001")

        // Then
        XCTAssertEqual(probs, ["011" : 1.0])
    }

    static var allTests = [
        ("testBaseEqualToZero_makeModularExponentiation_throwError",
         testBaseEqualToZero_makeModularExponentiation_throwError),
        ("testModulusEqualToOne_makeModularExponentiation_throwError",
         testModulusEqualToOne_makeModularExponentiation_throwError),
        ("testEmptyInputs_makeModularExponentiation_throwError",
         testEmptyInputs_makeModularExponentiation_throwError),
        ("testModulusPowerOfBase_makeModularExponentiation_throwError",
         testModulusPowerOfBase_makeModularExponentiation_throwError),
        ("testValidParameters_makeModularExponentiation_returnExpectedList",
         testValidParameters_makeModularExponentiation_returnExpectedList),
        ("testFullMatrixCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs",
         testFullMatrixCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs),
        ("testRowByRowCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs",
         testRowByRowCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs),
        ("testElementByElementCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs",
         testElementByElementCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs)
    ]
}
