//
//  Matrix+Rotation.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 19/09/2020.
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
import Foundation

// MARK: - Main body

extension Matrix {

    // MARK: - Internal class methods

    static func makeRotation(axis: Gate.Axis, radians: Double) -> Matrix {
        let angle = radians / 2.0

        var elements: [[Complex<Double>]] = []
        switch axis {
        case .x:
            elements = [[Complex(cos(angle)), Complex(imaginary: -sin(angle))],
                        [Complex(imaginary: -sin(angle)), Complex(cos(angle))]]
        case .y:
            elements = [[Complex(cos(angle)), Complex(-sin(angle))],
                        [Complex(sin(angle)), Complex(cos(angle))]]
        case .z:
            elements = [[-Complex.euler(angle), .zero],
                        [.zero, Complex.euler(angle)]]
        }

        return try! Matrix(elements)
    }
}
