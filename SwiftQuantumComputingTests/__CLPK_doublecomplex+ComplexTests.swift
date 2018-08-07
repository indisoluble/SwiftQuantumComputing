//
//  __CLPK_doublecomplex+ComplexTests.swift
//  SwiftQuantumComputingTests
//
//  Created by Enrique de la Torre on 06/08/2018.
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

import Accelerate
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class __CLPK_doublecomplex_ComplexTests: XCTestCase {

    // MARK: - Tests

    func testAnyComplex_init_returnExpectedDoubleComplex() {
        // Given
        let complex = Complex(real: 10, imag: 10)

        // When
        let doubleComplex = __CLPK_doublecomplex(complex)

        // Then
        XCTAssertEqual(doubleComplex.r, complex.real)
        XCTAssertEqual(doubleComplex.i, complex.imag)
    }
}
