//
//  Gate+InversionAboutMean.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/02/2020.
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

extension Gate {

    // MARK: - Public class methods

    /// Errors throwed by `Gate.makeInversionAboutMean(inputs:)`
    public enum MakeInversionAboutMeanError: Error {
        /// Throwed if `inputs` is an empty list
        case inputsCanNotBeAnEmptyList
    }

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that produces an inversion about the mean on
    /// the given `inputs`
    public static func makeInversionAboutMean(inputs: [Int]) -> Result<Gate, MakeInversionAboutMeanError> {
        let count = inputs.count
        guard count > 0 else {
            return .failure(.inputsCanNotBeAnEmptyList)
        }

        let matrixCount = Int.pow(2, count)
        let identity = try! Matrix.makeIdentity(count: matrixCount).get()
        let average = try! Matrix.makeAverage(count: matrixCount).get()
        let matrix = try! (Complex(-1.0) * identity + Complex(2.0) * average).get()

        return .success(.matrix(matrix: matrix, inputs: inputs)) 
    }
}
