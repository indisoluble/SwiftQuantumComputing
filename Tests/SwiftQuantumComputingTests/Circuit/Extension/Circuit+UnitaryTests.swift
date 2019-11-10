//
//  Circuit+UnitaryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/11/2019.
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

class Circuit_UnitaryTests: XCTestCase {

    // MARK: - Properties

    let circuit = CircuitTestDouble()

    // MARK: - Tests

    func testCircuitWithKnownQubitCount_unitaryWithoutQubitCount_useKnownQubitCount() {
        // Given
        let gates = [FixedGate.not(target: 0), FixedGate.hadamard(target: 2)]
        let qubitCount = 3

        circuit.gatesResult = gates

        // When
        _ = try? circuit.unitary()

        // Then
        XCTAssertEqual(circuit.gatesCount, 1)
        XCTAssertEqual(circuit.unitaryCount, 1)
        XCTAssertEqual(circuit.lastUnitaryQubitCount, qubitCount)
    }

    static var allTests = [
        ("testCircuitWithKnownQubitCount_unitaryWithoutQubitCount_useKnownQubitCount",
         testCircuitWithKnownQubitCount_unitaryWithoutQubitCount_useKnownQubitCount)
    ]
}
