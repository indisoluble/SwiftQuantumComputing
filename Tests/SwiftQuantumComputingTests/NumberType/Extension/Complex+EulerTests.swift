//
//  Complex+EulerTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 04/10/2020.
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

import ComplexModule
import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Complex_EulerTests: XCTestCase {

    // MARK: - Tests

    func testAnyValue_euler_returnExpectedValue() {
        // Given
        let value = 10.0

        // Then
        XCTAssertEqual(Complex.euler(value), Complex(cos(value), sin(value)))
    }

    static var allTests = [
        ("testAnyValue_euler_returnExpectedValue", testAnyValue_euler_returnExpectedValue)
    ]
}
