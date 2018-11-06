//
//  Vector.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 01/08/2018.
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

import Foundation
import os.log

// MARK: - Main body

public struct Vector {

    // MARK: - Public properties

    public var squaredNorm: Double {
        return Vector.innerProduct(self, self)!.real
    }

    public var count: Int {
        return matrix.rowCount
    }

    public subscript(index: Int) -> Complex {
        return matrix[index,0]
    }

    // MARK: - Private properties

    private let matrix: Matrix

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Init methods

    public init?(_ elements: [Complex]) {
        let rows = elements.map { [$0] }

        guard let matrix = Matrix(rows) else {
            os_log("init failed: unable to build matrix with provided elements",
                   log: Vector.logger,
                   type: .debug)

            return nil
        }

        self.init(matrix: matrix)
    }

    private init(matrix: Matrix) {
        self.matrix = matrix
    }

    // MARK: - Public class methods

    public static func innerProduct(_ lhs: Vector, _ rhs: Vector) -> Complex? {
        guard let matrix = (Matrix.Transformation.adjointed(lhs.matrix) * rhs.matrix) else {
            os_log("innerProduct failed: can not multiple provided vectors",
                   log: Vector.logger,
                   type: .debug)

            return nil
        }

        return Complex(matrix)
    }
}

// MARK: - CustomStringConvertible methods

extension Vector: CustomStringConvertible {
    public var description: String {
        return matrix.description
    }
}

// MARK: - Equatable methods

extension Vector: Equatable {
    public static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return (lhs.matrix == rhs.matrix)
    }
}

// MARK: - Overloaded operators

extension Vector {
    public static func *(lhs: Matrix, rhs: Vector) -> Vector? {
        guard let matrix = (lhs * rhs.matrix) else {
            os_log("* failed: can not multiple matrix by vector",
                   log: Vector.logger,
                   type: .debug)

            return nil
        }

        return Vector(matrix: matrix)
    }
}
