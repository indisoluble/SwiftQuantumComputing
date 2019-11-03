//
//  Matrix+ElementsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre (dev) on 02/11/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
//

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Matrix_ElementsTests: XCTestCase {

    // MARK: - Tests

    func testAnyMatrix_elements_returnExpectedArray() {
        // Given
        let expectedElements = [
            [Complex(1), Complex(0), Complex(0)],
            [Complex(0), Complex(1), Complex(0)],
            [Complex(0), Complex(0), Complex(1)]
        ]

        let matrix = try! Matrix(expectedElements)

        // Then
        XCTAssertEqual(matrix.elements, expectedElements)
    }

    static var allTests = [
        ("testAnyMatrix_elements_returnExpectedArray", testAnyMatrix_elements_returnExpectedArray)
    ]
}
