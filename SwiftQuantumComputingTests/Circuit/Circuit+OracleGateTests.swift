//
//  Circuit+OracleGateTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 16/09/2018.
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

class Circuit_OracleGateTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()
    let matrix = Matrix([[Complex(0)]])!

    // MARK: - Tests

    func testAnyCircuit_applyingOracleGate_callApplyingGate() {
        // When
        _ = circuit.applyingOracleGate(builtWith: matrix, inputs: [0])

        // Then
        XCTAssertEqual(circuit.applyingGateCount, 1)
    }
}
