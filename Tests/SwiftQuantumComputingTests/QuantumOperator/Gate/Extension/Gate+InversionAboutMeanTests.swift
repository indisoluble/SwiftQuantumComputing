//
//  Gate+InversionAboutMeanTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/02/2020.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Gate_InversionAboutMeanTests: XCTestCase {

    // MARK: - Tests

    func testEmptyInputs_makeInversionAboutMean_throwError() {
        // Then
        var error: Gate.MakeInversionAboutMeanError?
        if case .failure(let e) = Gate.makeInversionAboutMean(inputs: []) {
            error = e
        }
        XCTAssertEqual(error, .inputsCanNotBeAnEmptyList)
    }

    func testNonEmptyInputs_makeInversionAboutMean_returnExpectedGate() {
        // Given
        let inputs = [1, 0]

        // When
        let result = try? Gate.makeInversionAboutMean(inputs: inputs).get()

        // Then
        let mainValue = Complex<Double>(-1.0 + 2.0 / 4.0)
        let otherValue = Complex<Double>(2.0 / 4.0)
        let expectedMatrix = try! Matrix([[mainValue, otherValue, otherValue, otherValue],
                                          [otherValue, mainValue, otherValue, otherValue],
                                          [otherValue, otherValue, mainValue, otherValue],
                                          [otherValue, otherValue, otherValue, mainValue]])
        XCTAssertEqual(result, Gate.matrix(matrix: expectedMatrix, inputs: inputs))
    }

    static var allTests = [
        ("testEmptyInputs_makeInversionAboutMean_throwError",
         testEmptyInputs_makeInversionAboutMean_throwError),
        ("testNonEmptyInputs_makeInversionAboutMean_returnExpectedGate",
         testNonEmptyInputs_makeInversionAboutMean_returnExpectedGate)
    ]
}
