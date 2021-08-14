//
//  DensityMatrixTimeEvolutionFactoryAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/07/2021.
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

class DensityMatrixTimeEvolutionFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let transformation = DensityMatrixTransformationTestDouble()

    // MARK: - Tests

    func testAnyCircuitDensityMatrix_makeTimeEvolution_returnValue() {
        // Given
        let adapter = DensityMatrixTimeEvolutionFactoryAdapter(transformation: transformation)

        let matrix = try! Complex(1.0 / 3.0) * Matrix([[Complex(2), -.one],
                                                       [-.one, .one]])
        let densityMatrix = try! CircuitDensityMatrixAdapter(densityMatrix: matrix)

        // When
        let evolution = adapter.makeTimeEvolution(state: densityMatrix)

        // Then
        XCTAssertEqual(evolution.state, matrix)
    }

    static var allTests = [
        ("testAnyCircuitDensityMatrix_makeTimeEvolution_returnValue",
         testAnyCircuitDensityMatrix_makeTimeEvolution_returnValue)
    ]
}
