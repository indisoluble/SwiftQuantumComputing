//
//  StatevectorRegisterFactoryAdapterTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/02/2020.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class StatevectorRegisterFactoryAdapterTests: XCTestCase {

    // MARK: - Properties

    let adapter = StatevectorRegisterFactoryAdapter(matrixFactory: SimulatorCircuitMatrixFactoryTestDouble())

    // MARK: - Tests

    func testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError() {
        // Given
        let vector = try! Vector([Complex(0), Complex(0), Complex(1)])

        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: vector))
    }

    func testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError() {
        // Given
        let vector = try! Vector([Complex(0), Complex(0), Complex(1), Complex(1)])

        // Then
        XCTAssertThrowsError(try adapter.makeRegister(state: vector))
    }

    static var allTests = [
        ("testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError",
         testVectorWhichCountIsNotAPowerOfTwo_makeRegister_throwError),
        ("testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError",
         testVectorAdditionOfSquareModulusIsNotEqualToOne_makeRegister_throwError)
    ]
}
