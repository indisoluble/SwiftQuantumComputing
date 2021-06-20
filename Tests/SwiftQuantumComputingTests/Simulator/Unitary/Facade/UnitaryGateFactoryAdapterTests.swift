//
//  UnitaryGateFactoryAdapterTests.swift
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

class UnitaryGateFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let adapter = try! UnitaryGateFactoryAdapter(maxConcurrency: 1,
                                                 transformation: try! CSMFullMatrixUnitaryTransformation(maxConcurrency: 1))

    // MARK: - Tests

    func testMaxConcurrencyEqualToZero_init_throwException() {
        // Given
        let transformation = try! CSMFullMatrixUnitaryTransformation(maxConcurrency: 1)

        // Then
        XCTAssertThrowsError(try UnitaryGateFactoryAdapter(maxConcurrency: 0,
                                                           transformation: transformation))
    }

    func testGateThatThrowsError_makeUnitaryGate_throwError() {
        // Given
        let failingGate = Gate.controlledNot(target: 0, control: 0)

        // Then
        var error: GateError?
        if case .failure(let e) = adapter.makeUnitaryGate(qubitCount: 1, gate: failingGate) {
            error = e
        }
        XCTAssertEqual(error, .gateInputsAreNotUnique)
    }

    func testGateReturnsComponents_makeUnitaryGate_returnValue() {
        // Given
        let gate = Gate.hadamard(target: 0)

        // When
        let result = try? adapter.makeUnitaryGate(qubitCount: 1, gate: gate).get()

        // Then
        XCTAssertEqual(try? result?.unitary().get(), Matrix.makeHadamard())
    }

    static var allTests = [
        ("testMaxConcurrencyEqualToZero_init_throwException",
         testMaxConcurrencyEqualToZero_init_throwException),
        ("testGateThatThrowsError_makeUnitaryGate_throwError",
         testGateThatThrowsError_makeUnitaryGate_throwError),
        ("testGateReturnsComponents_makeUnitaryGate_returnValue",
         testGateReturnsComponents_makeUnitaryGate_returnValue)
    ]
}
