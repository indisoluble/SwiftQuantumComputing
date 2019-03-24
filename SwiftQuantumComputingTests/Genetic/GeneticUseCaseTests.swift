//
//  GeneticUseCaseTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/03/2019.
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

class GeneticUseCaseTests: XCTestCase {

    // MARK: - Properties

    let circuitInput = "000"
    let circuitOutput = "101"

    // MARK: - Tests

    func testEmptyTruthTable_init_returnExpectedUseCase() {
        // Given
        let truthTable: [String] = []

        // When
        let useCase = GeneticUseCase(truthTable: truthTable, circuitOutput: circuitOutput)

        // Then
        if let useCase = useCase {
            XCTAssertEqual(useCase.truthTable.truth, truthTable)
            XCTAssertEqual(useCase.truthTable.qubitCount, 0)
        } else {
            XCTAssert(false)
        }
    }

    func testTruthTableWithEmptyValue_init_returnExpectedUseCase() {
        // Given
        let truthTable: [String] = [""]

        // When
        let useCase = GeneticUseCase(truthTable: truthTable, circuitOutput: circuitOutput)

        // Then
        if let useCase = useCase {
            XCTAssertEqual(useCase.truthTable.truth, truthTable)
            XCTAssertEqual(useCase.truthTable.qubitCount, 0)
        } else {
            XCTAssert(false)
        }
    }

    func testTruthTableWithMultipleSizedValues_init_returnExpectedUseCase() {
        // Given
        let truthTable: [String] = ["1", "111", "11"]

        // When
        let useCase = GeneticUseCase(truthTable: truthTable, circuitOutput: circuitOutput)

        // Then
        if let useCase = useCase {
            XCTAssertEqual(useCase.truthTable.truth, truthTable)
            XCTAssertEqual(useCase.truthTable.qubitCount, 3)
        } else {
            XCTAssert(false)
        }
    }

    func testAnyTruthTableQubitCount_init_returnExpectedUseCase() {
        // Given
        let truthTableQubitCount = 10

        // When
        let useCase = GeneticUseCase(emptyTruthTableQubitCount: truthTableQubitCount,
                                     circuitOutput: circuitOutput)

        // Then
        if let useCase = useCase {
            XCTAssertEqual(useCase.truthTable.truth, [])
            XCTAssertEqual(useCase.truthTable.qubitCount, truthTableQubitCount)
        } else {
            XCTAssert(false)
        }
    }

    func testAnyCircuitOutput_init_returnExpectedUseCase() {
        // Given
        let truthTableQubitCount = 10

        // When
        let useCase = GeneticUseCase(emptyTruthTableQubitCount: truthTableQubitCount,
                                     circuitOutput: circuitOutput)

        // Then
        if let useCase = useCase {
            XCTAssertEqual(useCase.circuit.input, circuitInput)
            XCTAssertEqual(useCase.circuit.output, circuitOutput)
            XCTAssertEqual(useCase.circuit.qubitCount, circuitOutput.count)
        } else {
            XCTAssert(false)
        }
    }

    func testCircuitInputDifferentSizeThanOutput_init_returnNil() {
        // Given
        let truthTableQubitCount = 10

        let input = "00"
        let output = "000"

        // Then
        XCTAssertNil(GeneticUseCase(emptyTruthTableQubitCount: truthTableQubitCount,
                                    circuitInput: input,
                                    circuitOutput: output))
    }
}
