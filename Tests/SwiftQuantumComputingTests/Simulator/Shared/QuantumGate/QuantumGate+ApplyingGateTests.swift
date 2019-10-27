//
//  QuantumGate+ApplyingGateTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/10/2019.
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

class QuantumGate_ApplyingGateTests: XCTestCase {

    // MARK: - Tests

    func testAnyGateAndInputGateWithDifferentQubitCount_applying_throwError() {
        // Given
        let firstMatrix = try! Matrix.makeIdentity(count: 1)
        let firstGate = try! QuantumGate(matrix: firstMatrix)

        let secondMatrix = try! Matrix.makeIdentity(count: 2)
        let secondGate = try! QuantumGate(matrix: secondMatrix)

        // Then
        XCTAssertThrowsError(try firstGate.applying(secondGate))
    }

    func testTwoGates_applying_returnExpectedGate() {
        // Given
        let gate = try! QuantumGate(matrix: Matrix.makeNot())
        let otherGate = try! QuantumGate(matrix: Matrix.makeHadamard())

        // When
        let result = try! gate.applying(otherGate)

        // Then
        let expectedMatrix = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex(1), Complex(1)],
                                                                   [Complex(-1), Complex(1)]])))
        let expectedResult = try! QuantumGate(matrix: expectedMatrix)

        XCTAssertEqual(result, expectedResult)
    }

    func testTwoGates_applyingInDifferentOrder_returnExpectedGate() {
        // Given
        let gate = try! QuantumGate(matrix: Matrix.makeNot())
        let otherGate = try! QuantumGate(matrix: Matrix.makeHadamard())

        // When
        let result = try! otherGate.applying(gate)

        // Then
        let expectedMatrix = (Complex(1 / sqrt(2)) * (try! Matrix([[Complex(1), Complex(-1)],
                                                                   [Complex(1), Complex(1)]])))
        let expectedResult = try! QuantumGate(matrix: expectedMatrix)

        XCTAssertEqual(result, expectedResult)
    }

    static var allTests = [
        ("testAnyGateAndInputGateWithDifferentQubitCount_applying_throwError",
         testAnyGateAndInputGateWithDifferentQubitCount_applying_throwError),
        ("testTwoGates_applying_returnExpectedGate",
         testTwoGates_applying_returnExpectedGate),
        ("testTwoGates_applyingInDifferentOrder_returnExpectedGate",
         testTwoGates_applyingInDifferentOrder_returnExpectedGate)
    ]
}
