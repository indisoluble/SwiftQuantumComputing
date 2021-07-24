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
        var error: Gate.MakeModularExponentiationError?
        if case .failure(let e) = Gate.makeModularExponentiation(base: 0,
                                                                 modulus: modulus,
                                                                 exponent: exponent,
                                                                 inputs: inputs) {
            error = e
        }
        XCTAssertEqual(error, .baseHasToBeBiggerThanZero)
    }

    func testModulusEqualToOne_makeModularExponentiation_throwError() {
        // Then
        var error: Gate.MakeModularExponentiationError?
        if case .failure(let e) = Gate.makeModularExponentiation(base: base,
                                                                 modulus: 1,
                                                                 exponent: exponent,
                                                                 inputs: inputs) {
            error = e
        }
        XCTAssertEqual(error, .modulusHasToBeBiggerThanOne)
    }

    func testEmptyInputs_makeModularExponentiation_throwError() {
        // Then
        var error: Gate.MakeModularExponentiationError?
        if case .failure(let e) = Gate.makeModularExponentiation(base: base,
                                                                 modulus: modulus,
                                                                 exponent: exponent,
                                                                 inputs: []) {
            error = e
        }
        XCTAssertEqual(error, .inputsCanNotBeAnEmptyList)
    }

    func testModulusPowerOfBase_makeModularExponentiation_throwError() {
        // Then
        var error: Gate.MakeModularExponentiationError?
        if case .failure(let e) = Gate.makeModularExponentiation(base: base,
                                                                 modulus: Int.pow(base, 3),
                                                                 exponent: exponent,
                                                                 inputs: inputs) {
            error = e
        }
        XCTAssertEqual(error, .modulusProducesANonUnitaryMatrix)
    }

    func testValidParameters_makeModularExponentiation_returnExpectedList() {
        // When
        let gates = try? Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs).get()
        // Then
        let firstMatrix = try! Matrix([
            [.one,  .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .one,  .zero, .zero, .zero, .zero],
            [.zero, .one,  .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one,  .zero, .zero, .zero],
            [.zero, .zero, .one,  .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one,  .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one,  .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one]
        ])
        let secondMatrix = try! Matrix([
            [.one,  .zero, .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .one,  .zero, .zero, .zero],
            [.zero, .zero, .zero, .one,  .zero, .zero, .zero, .zero],
            [.zero, .zero, .one,  .zero, .zero, .zero, .zero, .zero],
            [.zero, .one,  .zero, .zero, .zero, .zero, .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .one,  .zero, .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .one,  .zero],
            [.zero, .zero, .zero, .zero, .zero, .zero, .zero, .one]
        ])
        let expectedGates = [
            Gate.controlled(gate: .matrix(matrix: firstMatrix, inputs: inputs),
                            controls: [exponent[1]]),
            Gate.controlled(gate: .matrix(matrix: secondMatrix, inputs: inputs),
                            controls: [exponent[0]])
        ]
        XCTAssertEqual(gates, expectedGates)
    }

    func testFullMatrixCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs).get()
        let circuit = MainCircuitFactory(statevectorConfiguration: .fullMatrix()).makeCircuit(gates: gates)
        let initialStatevector = try! MainCircuitStatevectorFactory().makeStatevector(bits: "11001").get()

        // When
        let statevector = try! circuit.statevector(withInitialState: initialStatevector).get()
        let probs = try! statevector.summarizedProbabilities(byQubits: inputs).get()

        // Then
        XCTAssertEqual(probs, ["011" : 1.0])
    }

    func testRowByRowCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs).get()
        let circuit = MainCircuitFactory(statevectorConfiguration: .rowByRow()).makeCircuit(gates: gates)
        let initialStatevector = try! MainCircuitStatevectorFactory().makeStatevector(bits: "11001").get()

        // When
        let statevector = try! circuit.statevector(withInitialState: initialStatevector).get()
        let probs = try! statevector.summarizedProbabilities(byQubits: inputs).get()

        // Then
        XCTAssertEqual(probs, ["011" : 1.0])
    }

    func testElementByElementCircuitWithModularExponentiation_summarizedProbabilities_returnExpectedProbs() {
        // Given
        let gates = try! Gate.makeModularExponentiation(base: base,
                                                        modulus: modulus,
                                                        exponent: exponent,
                                                        inputs: inputs).get()
        let circuit = MainCircuitFactory(statevectorConfiguration: .elementByElement()).makeCircuit(gates: gates)
        let initialStatevector = try! MainCircuitStatevectorFactory().makeStatevector(bits: "11001").get()

        // When
        let statevector = try! circuit.statevector(withInitialState: initialStatevector).get()
        let probs = try! statevector.summarizedProbabilities(byQubits: inputs).get()

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
