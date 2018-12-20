//
//  OracleGateFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre (dev) on 21/12/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
//

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class OracleGateFactoryTests: XCTestCase {

    // MARK: - Properties

    let matrix = Matrix([[Complex(0), Complex(1), Complex(0), Complex(0)],
                         [Complex(1), Complex(0), Complex(0), Complex(0)],
                         [Complex(0), Complex(0), Complex(1), Complex(0)],
                         [Complex(0), Complex(0), Complex(0), Complex(1)]])!

    // MARK: - Tests

    func testFactoryWithTwoQubitsMatrixAndOneInput_makeGate_returnNil() {
        // Given
        let factory = OracleGateFactory(matrix: matrix)

        // Then
        XCTAssertNil(factory.makeGate(inputs: [0]))
    }

    func testFactoryWithTwoQubitsMatrixAndFourInputs_makeGate__returnExpectedGate() {
        // Given
        let factory = OracleGateFactory(matrix: matrix)
        let inputs = [0, 1, 2, 3]

        // When
        guard let result = factory.makeGate(inputs: inputs) else {
            XCTAssert(false)

            return
        }

        // Then
        switch result {
        case let .oracle(oracleMatrix, oracleInputs):
            XCTAssertEqual(oracleMatrix, matrix)
            XCTAssertEqual(oracleInputs, Array(inputs[0..<2]))
        default:
            XCTAssert(false)
        }
    }
}
