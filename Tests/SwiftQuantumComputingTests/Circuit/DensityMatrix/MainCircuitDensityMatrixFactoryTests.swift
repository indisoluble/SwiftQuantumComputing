//
//  MainCircuitDensityMatrixFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 13/07/2021.
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

class MainCircuitDensityMatrixFactoryTests: XCTestCase {

    // MARK: - Properties

    let factory = MainCircuitDensityMatrixFactory()

    // MARK: - Tests

    func testNonHermitianMatrix_makeDensityMatrix_throwException() {
        // Given
        let row = [Complex<Double>.one, Complex<Double>.i]
        let matrix = try! Matrix((0..<row.count).map({ _ in row }))

        // Then
        var error: MakeDensityMatrixError?
        if case .failure(let e) = factory.makeDensityMatrix(matrix: matrix) {
            error = e
        }
        XCTAssertEqual(error, .matrixIsNotHermitian)
    }

    func testMatrixWithNegativeEigenvalues_makeDensityMatrix_throwException() {
        // Given
        let matrix = try! Matrix([[-.one, .zero, -2 * .i],
                                  [.zero, Complex(2), .zero],
                                  [2 * .i, .zero, -.one]])

        // Then
        var error: MakeDensityMatrixError?
        if case .failure(let e) = factory.makeDensityMatrix(matrix: matrix) {
            error = e
        }
        XCTAssertEqual(error, .matrixWithNegativeEigenvalues)
    }

    func testMatrixWithEigenvaluesNotAddingToOne_makeDensityMatrix_throwException() {
        // Given
        let matrix = try! Matrix([[Complex(2), .i, .zero],
                                  [-.i, Complex(2), .zero],
                                  [.zero, .zero, Complex(3)]])

        // Then
        var error: MakeDensityMatrixError?
        if case .failure(let e) = factory.makeDensityMatrix(matrix: matrix) {
            error = e
        }
        XCTAssertEqual(error, .matrixEigenvaluesDoesNotAddUpToOne)
    }

    func testValidMatrix_makeDensityMatrix_returnExpectedInstance() {
        // Given
        let matrix = try! Complex(1.0 / 3.0) * Matrix([[Complex(2), -.one],
                                                       [-.one, .one]])

        // When
        let result = try? factory.makeDensityMatrix(matrix: matrix).get()

        // Then
        XCTAssertEqual(matrix, result?.densityMatrix)
    }

    static var allTests = [
        ("testNonHermitianMatrix_makeDensityMatrix_throwException",
         testNonHermitianMatrix_makeDensityMatrix_throwException),
        ("testMatrixWithNegativeEigenvalues_makeDensityMatrix_throwException",
         testMatrixWithNegativeEigenvalues_makeDensityMatrix_throwException),
        ("testMatrixWithEigenvaluesNotAddingToOne_makeDensityMatrix_throwException",
         testMatrixWithEigenvaluesNotAddingToOne_makeDensityMatrix_throwException),
        ("testValidMatrix_makeDensityMatrix_returnExpectedInstance",
         testValidMatrix_makeDensityMatrix_returnExpectedInstance)
    ]
}
