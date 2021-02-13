//
//  SimulatorControlledMatrixAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/01/2021.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class SimulatorControlledMatrixAdapterTests: XCTestCase {

    func testNotMatrixAndControlCountToTwo_matrixCount_returnExpectedValue() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 2
        let sut = SimulatorControlledMatrixAdapter(controlCount: controlCount,
                                                   controlledMatrix: controlledMatrix)

        // Then
        XCTAssertEqual(sut.expandedMatrixCount, 8)
    }

    func testNotMatrixAndControlCountToOne_expandedMatrix_returnExpectedMatrix() {
        // Given
        let controlledMatrix = Matrix.makeNot()
        let controlCount = 1
        let sut = SimulatorControlledMatrixAdapter(controlCount: controlCount,
                                                   controlledMatrix: controlledMatrix)

        // Then
        XCTAssertEqual(sut.expandedMatrix().rawMatrix, Matrix.makeControlledNot())
    }

    static var allTests = [
        ("testNotMatrixAndControlCountToTwo_matrixCount_returnExpectedValue",
         testNotMatrixAndControlCountToTwo_matrixCount_returnExpectedValue),
        ("testNotMatrixAndControlCountToOne_expandedMatrix_returnExpectedMatrix",
         testNotMatrixAndControlCountToOne_expandedMatrix_returnExpectedMatrix)
    ]
}
