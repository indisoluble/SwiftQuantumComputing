//
//  Complex.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/07/2018.
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

// MARK: - Main body

public struct Complex {

    // MARK: - Public properties

    public let real: Double
    public let imag: Double

    // MARK: - Internal properties

    var squaredModulus: Double {
        return (pow(real, 2) + pow(imag, 2))
    }

    // MARK: - Public init methods

    public init(real: Double, imag: Double) {
        self.real = real
        self.imag = imag
    }

    public init(_ real: Double) {
        self.init(real: real, imag: 0)
    }

    public init(_ real: Int) {
        self.init(real: Double(real), imag: 0)
    }

    // MARK: - Internal init methods

    enum InitError: Error {
        case use1x1Matrix
    }

    init(_ matrix: Matrix) throws {
        guard ((matrix.rowCount == 1) && (matrix.columnCount == 1)) else {
            throw InitError.use1x1Matrix
        }

        let complex = matrix.first

        self.init(real: complex.real, imag: complex.imag)
    }
}

// MARK: - CustomStringConvertible methods

extension Complex: CustomStringConvertible {
    public var description: String {
        return String(format: "(%.2f%+.2fi)", real, imag)
    }
}

// MARK: - Equatable methods

extension Complex: Equatable {
    public static func ==(lhs: Complex, rhs: Complex) -> Bool {
        return ((lhs.real == rhs.real) && (lhs.imag == rhs.imag))
    }
}

// MARK: - Overloaded operators

extension Complex {

    // MARK: - Internal operators

    static func *(lhs: Complex, rhs: Complex) -> Complex {
        let real = ((lhs.real * rhs.real) - (lhs.imag * rhs.imag))
        let imag = ((lhs.real * rhs.imag) + (rhs.real * lhs.imag))

        return Complex(real: real, imag: imag)
    }
}
