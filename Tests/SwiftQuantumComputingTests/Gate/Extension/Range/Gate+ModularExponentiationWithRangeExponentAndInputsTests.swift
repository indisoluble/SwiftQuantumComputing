//
//  Gate+ModularExponentiationWithRangeExponentAndInputsTests.swift
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

class Gate_ModularExponentiationWithRangeExponentAndInputsTests: XCTestCase {

    // MARK: - Properties

    let base = 3
    let modulus = 4
    let inputs = [1, 0]
    let exponents = [3, 2]
    let firstMatrix = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .zero, .zero, .one],
        [.zero, .zero, .one, .zero],
        [.zero, .one, .zero, .zero]
    ])
    let secondMatrix = try! Matrix([
        [.one, .zero, .zero, .zero],
        [.zero, .one, .zero, .zero],
        [.zero, .zero, .one, .zero],
        [.zero, .zero, .zero, .one]
    ])

    // MARK: - Tests

    func testAnyRange_makeModularExponentiation_returnExpectedGates() {
        // Then
        let gates = [
            Gate.controlledMatrix(matrix: firstMatrix, inputs: inputs, control: 2),
            Gate.controlledMatrix(matrix: secondMatrix, inputs: inputs, control: 3)
        ]
        let reversedGates = [
            Gate.controlledMatrix(matrix: firstMatrix, inputs: inputs, control: 3),
            Gate.controlledMatrix(matrix: secondMatrix, inputs: inputs, control: 2)
        ]
        let reversedInputs = Array(inputs.reversed())
        let reversedInputsGates = [
            Gate.controlledMatrix(matrix: firstMatrix, inputs: reversedInputs, control: 2),
            Gate.controlledMatrix(matrix: secondMatrix, inputs: reversedInputs, control: 3)
        ]
        let reversedInputsReversedGates = [
            Gate.controlledMatrix(matrix: firstMatrix, inputs: reversedInputs, control: 3),
            Gate.controlledMatrix(matrix: secondMatrix, inputs: reversedInputs, control: 2)
        ]

        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2..<4,
                                                           inputs: inputs).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2...3,
                                                           inputs: inputs).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2..<4).reversed(),
                                                           inputs: inputs).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2...3).reversed(),
                                                           inputs: inputs).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: exponents,
                                                           inputs: 0..<2).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: exponents,
                                                           inputs: 0...1).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: exponents,
                                                           inputs: (0..<2).reversed()).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: exponents,
                                                           inputs: (0...1).reversed()).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2..<4,
                                                           inputs: 0..<2).get(),
                       reversedInputsReversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2..<4,
                                                           inputs: 0...1).get(),
                       reversedInputsReversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2..<4,
                                                           inputs: (0..<2).reversed()).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2..<4,
                                                           inputs: (0...1).reversed()).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2...3,
                                                           inputs: 0..<2).get(),
                       reversedInputsReversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2...3,
                                                           inputs: 0...1).get(),
                       reversedInputsReversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2...3,
                                                           inputs: (0..<2).reversed()).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: 2...3,
                                                           inputs: (0...1).reversed()).get(),
                       reversedGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2..<4).reversed(),
                                                           inputs: 0..<2).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2..<4).reversed(),
                                                           inputs: 0...1).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2..<4).reversed(),
                                                           inputs: (0..<2).reversed()).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2..<4).reversed(),
                                                           inputs: (0...1).reversed()).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2...3).reversed(),
                                                           inputs: 0..<2).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2...3).reversed(),
                                                           inputs: 0...1).get(),
                       reversedInputsGates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2...3).reversed(),
                                                           inputs: (0..<2).reversed()).get(),
                       gates)
        XCTAssertEqual(try? Gate.makeModularExponentiation(base: base,
                                                           modulus: modulus,
                                                           exponent: (2...3).reversed(),
                                                           inputs: (0...1).reversed()).get(),
                       gates)
    }

    static var allTests = [
        ("testAnyRange_makeModularExponentiation_returnExpectedGates",
         testAnyRange_makeModularExponentiation_returnExpectedGates)
    ]
}
