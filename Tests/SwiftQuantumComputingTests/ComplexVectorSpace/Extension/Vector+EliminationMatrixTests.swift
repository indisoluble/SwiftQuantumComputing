//
//  Vector+EliminationMatrixTests.swift
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

class Vector_EliminationMatrixTests: XCTestCase {

    // MARK: - Tests

    func testVectorWithCountThree_eliminationMatrix_throwException() {
        // Given
        let vector = try! Vector([.zero, .one, .i])

        // Then
        var error: Vector.EliminationMatrixError?
        if case .failure(let e) = vector.eliminationMatrix() {
            error = e
        }
        XCTAssertEqual(error, .vectorCountIsNotTwo)
    }

    func testAnyValidVectors_eliminationMatrix_returnExpectedMatrix() {
        // Given
        let vectors = [
            try! Vector([.zero, .zero]),
            try! Vector([.zero, .one]),
            try! Vector([.zero, .i]),
            try! Vector([.one, .zero]),
            try! Vector([.one, .one]),
            try! Vector([.one, .i]),
            try! Vector([.i, .zero]),
            try! Vector([.i, .one]),
            try! Vector([.i, .i]),
            try! Vector([Complex(1.0 / sqrt(2)), Complex(1.0 / sqrt(2))]),
            try! Vector([Complex(1.0 / sqrt(2)), Complex(imaginary: 1.0 / sqrt(2))]),
            try! Vector([Complex(imaginary: 1.0 / sqrt(2)), Complex(1.0 / sqrt(2))]),
            try! Vector([Complex(imaginary: 1.0 / sqrt(2)), Complex(imaginary: 1.0 / sqrt(2))]),
            try! Vector([Complex(1.0 / sqrt(2), 1.0 / sqrt(2)),
                         Complex(1.0 / sqrt(2), 1.0 / sqrt(2))])
        ]

        // Then
        for vector in vectors {
            let eliminationMatrix = try! vector.eliminationMatrix().get()
            let nextVector = try! (vector * eliminationMatrix).get()
            XCTAssertTrue(nextVector[1].isApproximatelyEqual(to: .zero,
                                                             absoluteTolerance: SharedConstants.tolerance))
        }
    }

    static var allTests = [
        ("testVectorWithCountThree_eliminationMatrix_throwException",
         testVectorWithCountThree_eliminationMatrix_throwException),
        ("testAnyValidVectors_eliminationMatrix_returnExpectedMatrix",
         testAnyValidVectors_eliminationMatrix_returnExpectedMatrix)
    ]
}
