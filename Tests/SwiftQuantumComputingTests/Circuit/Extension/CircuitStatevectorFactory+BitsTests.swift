//
//  CircuitStatevectorFactory+BitsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/06/2020.
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

class CircuitStatevectorFactory_BitsTests: XCTestCase {

    // MARK: - Properties

    let factory = MainCircuitStatevectorFactory()

    // MARK: - Tests

    func testEmptyBits_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorBitsError?
        if case .failure(let e) = factory.makeStatevector(bits: "") {
            error = e
        }
        XCTAssertEqual(error, .bitsAreNotAStringComposedOnlyOfZerosAndOnes)
    }

    func testBitsBiggerThanOne_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorBitsError?
        if case .failure(let e) = factory.makeStatevector(bits: "012") {
            error = e
        }
        XCTAssertEqual(error, .bitsAreNotAStringComposedOnlyOfZerosAndOnes)
    }

    func testBitsWithSpaces_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorBitsError?
        if case .failure(let e) = factory.makeStatevector(bits: " 01 ") {
            error = e
        }
        XCTAssertEqual(error, .bitsAreNotAStringComposedOnlyOfZerosAndOnes)
    }

    func testBitsWithCharacters_makeStatevector_throwException() {
        // Then
        var error: MakeStatevectorBitsError?
        if case .failure(let e) = factory.makeStatevector(bits: "01ab") {
            error = e
        }
        XCTAssertEqual(error, .bitsAreNotAStringComposedOnlyOfZerosAndOnes)
    }

    func testBitOne_makeStatevector_returnExpectedValue() {
        // Then
        var result: CircuitStatevector?
        if case .success(let r) = factory.makeStatevector(bits: "1") {
            result = r
        }
        XCTAssertEqual(result?.statevector, try! Vector([.zero, .one]))
    }

    func testBitsFour_makeStatevector_returnExpectedValue() {
        // Then
        var result: CircuitStatevector?
        if case .success(let r) = factory.makeStatevector(bits: "101") {
            result = r
        }

        let expectedVector = try! Vector([.zero, .zero, .zero, .zero, .zero, .one, .zero, .zero])
        XCTAssertEqual(result?.statevector, expectedVector)
    }

    static var allTests = [
        ("testEmptyBits_makeStatevector_throwException",
         testEmptyBits_makeStatevector_throwException),
        ("testBitsBiggerThanOne_makeStatevector_throwException",
         testBitsBiggerThanOne_makeStatevector_throwException),
        ("testBitsWithSpaces_makeStatevector_throwException",
         testBitsWithSpaces_makeStatevector_throwException),
        ("testBitsWithCharacters_makeStatevector_throwException",
         testBitsWithCharacters_makeStatevector_throwException),
        ("testBitOne_makeStatevector_returnExpectedValue",
         testBitOne_makeStatevector_returnExpectedValue),
        ("testBitsFour_makeStatevector_returnExpectedValue",
         testBitsFour_makeStatevector_returnExpectedValue)
    ]
}
