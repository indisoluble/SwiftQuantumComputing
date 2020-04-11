//
//  Matrix+IsSquareTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/03/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
//

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Matrix_IsSquareTests: XCTestCase {

    // MARK: - Tests

    func testNonSquareMatrix_isSquare_returnFalse() {
        // Given
        let complex = Complex.zero
        let matrix = try! Matrix([[complex], [complex]])

        // Then
        XCTAssertFalse(matrix.isSquare)
    }

    func testSquareMatrix_isSquare_returnTrue() {
        // Given
        let complex = Complex.zero
        let matrix = try! Matrix([[complex, complex], [complex, complex]])

        // Then
        XCTAssertTrue(matrix.isSquare)
    }

    static var allTests = [
        ("testNonSquareMatrix_isSquare_returnFalse", testNonSquareMatrix_isSquare_returnFalse),
        ("testSquareMatrix_isSquare_returnTrue", testSquareMatrix_isSquare_returnTrue),
    ]
}
