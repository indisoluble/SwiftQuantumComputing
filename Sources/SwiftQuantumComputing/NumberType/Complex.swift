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

/// Swift representation of a complex number
public struct Complex {

    // MARK: - Public properties

    /// Real part
    public let real: Double

    /// Imaginary part
    public let imag: Double

    // MARK: - Public init methods

    /// Initializes a `Complex` instance setting `real` & `imag` with the provided parameters
    public init(real: Double, imag: Double) {
        self.real = real
        self.imag = imag
    }

    /// Initialize a `Complex` instance setting `real` with the provided parameter & `imag` to 0
    public init(_ real: Double) {
        self.init(real: real, imag: 0)
    }

    /// Initialize a `Complex` instance setting `real` with the provided parameter & `imag` to 0
    public init(_ real: Int) {
        self.init(real: Double(real), imag: 0)
    }
}

// MARK: - Equatable methods

extension Complex: Equatable {}
