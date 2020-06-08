//
//  Complex+OverloadedOperators.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/03/2020.
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

import Foundation

// MARK: - Overloaded operators

extension Complex {

    // MARK: - Internal operators

    static func +(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imag: lhs.imag + rhs.imag)
    }

    static func *(lhs: Complex, rhs: Complex) -> Complex {
        let real = ((lhs.real * rhs.real) - (lhs.imag * rhs.imag))
        let imag = ((lhs.real * rhs.imag) + (rhs.real * lhs.imag))

        return Complex(real: real, imag: imag)
    }
}