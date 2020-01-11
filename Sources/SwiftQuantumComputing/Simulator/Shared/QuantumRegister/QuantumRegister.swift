//
//  QuantumRegister.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/08/2018.
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

struct QuantumRegister {

    // MARK: - Internal properties

    let statevector: Vector

    var qubitCount: Int {
        return Int.log2(statevector.count)
    }

    // MARK: - Internal init methods

    enum InitVectorError: Error {
        case vectorCountHasToBeAPowerOfTwo
        case vectorAdditionOfSquareModulusIsNotEqualToOne
    }

    init(vector: Vector) throws {
        guard vector.count.isPowerOfTwo else {
            throw InitVectorError.vectorCountHasToBeAPowerOfTwo
        }

        guard QuantumRegister.isAdditionOfSquareModulusInVectorEqualToOne(vector) else {
            throw InitVectorError.vectorAdditionOfSquareModulusIsNotEqualToOne
        }

        self.statevector = vector
    }
}

// MARK: - CustomStringConvertible methods

extension QuantumRegister: CustomStringConvertible {
    var description: String {
        return statevector.description
    }
}

// MARK: - Equatable methods

extension QuantumRegister: Equatable {}

// MARK: - Private body

private extension QuantumRegister {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }

    // MARK: - Private class methods

    static func isAdditionOfSquareModulusInVectorEqualToOne(_ vector: Vector) -> Bool {
        return (abs(vector.squaredNorm - Double(1)) <= Constants.accuracy)
    }
}
