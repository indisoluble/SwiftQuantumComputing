//
//  Vector+IsAdditionOfSquareModulusEqualToOneTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 14/04/2020.
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

class Vector_IsAdditionOfSquareModulusEqualToOneTests: XCTestCase {

    // MARK: - Tests

    func testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_isAdditionOfSquareModulusEqualToOne_returnFalse() {
        // Given
        let vector = try! Vector([.one, .one])

        // Then
        XCTAssertFalse(vector.isAdditionOfSquareModulusEqualToOne())
    }

    func testVectorWhichAdditionOfSquareModulusIsEqualToOne_isAdditionOfSquareModulusEqualToOne_returnTrue() {
        // Given
        let vector = try! Vector([.one, .zero])

        // Then
        XCTAssertTrue(vector.isAdditionOfSquareModulusEqualToOne())
    }

    static var allTests = [
        ("testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_isAdditionOfSquareModulusEqualToOne_returnFalse",
         testVectorWhichAdditionOfSquareModulusIsNotEqualToOne_isAdditionOfSquareModulusEqualToOne_returnFalse),
        ("testVectorWhichAdditionOfSquareModulusIsEqualToOne_isAdditionOfSquareModulusEqualToOne_returnTrue",
         testVectorWhichAdditionOfSquareModulusIsEqualToOne_isAdditionOfSquareModulusEqualToOne_returnTrue)
    ]
}
