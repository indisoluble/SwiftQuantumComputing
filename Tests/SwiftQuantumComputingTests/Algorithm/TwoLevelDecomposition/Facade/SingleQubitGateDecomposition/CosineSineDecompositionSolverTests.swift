//
//  CosineSineDecompositionSolverTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/03/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

class CosineSineDecompositionSolverTests: XCTestCase {

    // MARK: - Properties

    let sut = CosineSineDecompositionSolver()
    let circuitFactory = MainCircuitFactory()

    // MARK: - Tests

    func testUnitaryMatrix_decomposeGate_returnEmptyList() {
        // Given
        let gate = Gate.matrix(matrix: try! Matrix.makeIdentity(count: 2).get(), inputs: [0])

        // Then
        XCTAssertEqual(sut.decomposeGate(gate), [])
    }

    func testNotGate_decomposeGate_returnSameNotGate() {
        // Given
        let gate = Gate.not(target: 10)

        // Then
        XCTAssertEqual(sut.decomposeGate(gate), [gate])
    }

    func testPhaseShiftGate_decomposeGate_returnSamePhaseShiftGate() {
        // Given
        let gate = Gate.phaseShift(radians: 0.2, target: 5)

        // Then
        XCTAssertEqual(sut.decomposeGate(gate), [gate])
    }

    func testHadamardGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 0
        let qubitCount = target + 1
        let gate = Gate.hadamard(target: target)

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: .makeHadamard(),
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testRotationXGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 0
        let qubitCount = target + 1
        let radians = 0.2
        let gate = Gate.rotation(axis: .x, radians: radians, target: target)

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: .makeRotation(axis: .x, radians: radians),
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testRotationYGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 0
        let qubitCount = target + 1
        let radians = 0.3
        let gate = Gate.rotation(axis: .y, radians: radians, target: target)

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: .makeRotation(axis: .y, radians: radians),
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testRotationZGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 0
        let qubitCount = target + 1
        let radians = 0.7
        let gate = Gate.rotation(axis: .z, radians: radians, target: target)

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: .makeRotation(axis: .z, radians: radians),
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testInversionAboutMeanGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 2
        let qubitCount = target + 1
        let gate = try! Gate.makeInversionAboutMean(inputs: [target]).get()

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        let expectedUnitary = try! circuitFactory.makeCircuit(gates: [gate]).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: expectedUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    func testQuantumFourierTransformGate_decomposeGate_returnGatesThatProduceSameUnitary() {
        // Given
        let target = 2
        let qubitCount = target + 1
        let gate = try! Gate.makeQuantumFourierTransform(inputs: [target]).get()

        // When
        let result = sut.decomposeGate(gate)

        // Then
        XCTAssertTrue(result.allSatisfy { $0.extractRawInputs() == [target] })

        let unitary = try! circuitFactory.makeCircuit(gates: result).unitary(withQubitCount: qubitCount).get()
        let expectedUnitary = try! circuitFactory.makeCircuit(gates: [gate]).unitary(withQubitCount: qubitCount).get()
        XCTAssertTrue(unitary.isApproximatelyEqual(to: expectedUnitary,
                                                   absoluteTolerance: SharedConstants.tolerance))
    }

    static var allTests = [
        ("testUnitaryMatrix_decomposeGate_returnEmptyList",
         testUnitaryMatrix_decomposeGate_returnEmptyList),
        ("testNotGate_decomposeGate_returnSameNotGate",
         testNotGate_decomposeGate_returnSameNotGate),
        ("testPhaseShiftGate_decomposeGate_returnSamePhaseShiftGate",
         testPhaseShiftGate_decomposeGate_returnSamePhaseShiftGate),
        ("testHadamardGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testHadamardGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testRotationXGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testRotationXGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testRotationYGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testRotationYGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testRotationZGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testRotationZGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testInversionAboutMeanGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testInversionAboutMeanGate_decomposeGate_returnGatesThatProduceSameUnitary),
        ("testQuantumFourierTransformGate_decomposeGate_returnGatesThatProduceSameUnitary",
         testQuantumFourierTransformGate_decomposeGate_returnGatesThatProduceSameUnitary)
    ]
}
