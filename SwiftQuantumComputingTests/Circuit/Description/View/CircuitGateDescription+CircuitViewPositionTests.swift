//
//  CircuitGateDescription+CircuitViewPositionTests.swift
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

class CircuitGateDescription_CircuitViewPositionTests: XCTestCase {

    // MARK: - Tests

    func testControlledNotDescription_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 5
        let gate = CircuitGateDescription.controlledNot(target: 1, control: 3)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.controlledNotUp,
            CircuitViewPosition.crossedLines,
            CircuitViewPosition.controlDown,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testHadamardDescription_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = CircuitGateDescription.hadamard(target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.hadamard,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testNotDescription_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = CircuitGateDescription.not(target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.not,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testSingleQubitOracleDescription_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 3
        let gate = CircuitGateDescription.oracle(inputs: [1])

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracle,
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testMultiQubitOracleDescription_makeLayer_returnExpectedPositions() {
        // Given
        let qubitCount = 7
        let inputs = [1, 5, 3]
        let gate = CircuitGateDescription.oracle(inputs: inputs)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.oracleBottom,
            CircuitViewPosition.oracleMiddleUnconnected,
            CircuitViewPosition.oracleMiddleConnected,
            CircuitViewPosition.oracleMiddleUnconnected,
            CircuitViewPosition.oracleTop(inputs: inputs),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }

    func testPhaseShiftDescription_makeLayer_returnExpectedPositions() {
        // Given
        let radians = 0.1
        let qubitCount = 3
        let gate = CircuitGateDescription.phaseShift(radians: radians, target: 1)

        // When
        let positions = gate.makeLayer(qubitCount: qubitCount)

        // Then
        let expectedPositions = [
            CircuitViewPosition.lineHorizontal,
            CircuitViewPosition.phaseShift(radians: radians),
            CircuitViewPosition.lineHorizontal
        ]
        XCTAssertEqual(positions, expectedPositions)
    }
}
