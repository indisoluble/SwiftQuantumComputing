//
//  Vector+ElementsTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre (dev) on 02/11/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
//

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class Vector_ElementsTests: XCTestCase {

    // MARK: - Tests

    func testAnyVector_elements_returnExpectedArray() {
        // Given
        let expectedElements = [Complex(1), Complex(0), Complex(1)]

        let vector = try! Vector(expectedElements)

        // Then
        XCTAssertEqual(vector.elements, expectedElements)
    }

    static var allTests = [
        ("testAnyVector_elements_returnExpectedArray", testAnyVector_elements_returnExpectedArray)
    ]
}
