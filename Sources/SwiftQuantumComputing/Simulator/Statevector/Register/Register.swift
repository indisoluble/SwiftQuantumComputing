//
//  Register.swift
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

struct Register {

    // MARK: - StatevectorRegister properties

    let statevector: Vector

    // MARK: - Internal init methods

    enum InitBitsError: Error {
        case bitsAreNotAStringComposedOnlyOfZerosAndOnes
    }

    init(bits: String) throws {
        guard let value = Int(bits, radix: 2) else {
            throw InitBitsError.bitsAreNotAStringComposedOnlyOfZerosAndOnes
        }

        try! self.init(vector: Register.makeState(value: value, qubitCount: bits.count))
    }

    enum InitVectorError: Error {
        case additionOfSquareModulusIsNotEqualToOne
    }

    init(vector: Vector) throws {
        guard Register.isAdditionOfSquareModulusInVectorEqualToOne(vector) else {
            throw InitVectorError.additionOfSquareModulusIsNotEqualToOne
        }

        self.statevector = vector
    }
}

// MARK: - CustomStringConvertible methods

extension Register: CustomStringConvertible {
    var description: String {
        return statevector.description
    }
}

// MARK: - Equatable methods

extension Register: Equatable {
    static func ==(lhs: Register, rhs: Register) -> Bool {
        return (lhs.statevector == rhs.statevector)
    }
}

// MARK: - StatevectorRegister methods

extension Register: StatevectorRegister {
    func applying(_ gate: RegisterGate) throws -> Register {
        var nextVector: Vector!
        do {
            nextVector = try gate.apply(to: statevector)
        } catch RegisterGate.ApplyError.vectorCountDoesNotMatchGateMatrixColumnCount {
            throw GateError.gateQubitCountDoesNotMatchCircuitQubitCount
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try Register(vector: nextVector)
        } catch Register.InitVectorError.additionOfSquareModulusIsNotEqualToOne {
            throw GateError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGate
        }
    }
}

// MARK: - Private body

private extension Register {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }

    // MARK: - Private class methods

    static func makeState(value: Int, qubitCount: Int) -> Vector {
        let count = Int.pow(2, qubitCount)

        var elements = Array(repeating: Complex(0), count: count)
        elements[value] = Complex(1)

        return try! Vector(elements)
    }

    static func isAdditionOfSquareModulusInVectorEqualToOne(_ vector: Vector) -> Bool {
        return (abs(vector.squaredNorm - Double(1)) <= Constants.accuracy)
    }
}
