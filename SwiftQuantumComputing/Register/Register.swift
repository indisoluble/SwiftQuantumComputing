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
import os.log

// MARK: - Main body

struct Register {

    // MARK: - Private properties

    private let vector: Vector

    // MARK: - Private class properties

    private static let logger = LoggerFactory.makeLogger()

    // MARK: - Internal init methods

    init?(qubitCount: Int) {
        guard let groundState = Register.makeGroundState(qubitCount: qubitCount) else {
            os_log("init failed: use qubit count bigger than 0", log: Register.logger, type: .debug)

            return nil
        }

        self.init(vector: groundState)
    }

    init?(vector: Vector) {
        guard Register.isAdditionOfSquareModulusInVectorEqualToOne(vector) else {
            os_log("init failed: addition of square modulus is not equal to 1",
                   log: Register.logger,
                   type: .debug)

            return nil
        }

        self.vector = vector
    }
}

// MARK: - CustomStringConvertible methods

extension Register: CustomStringConvertible {
    var description: String {
        return vector.description
    }
}

// MARK: - Equatable methods

extension Register: Equatable {
    static func ==(lhs: Register, rhs: Register) -> Bool {
        return (lhs.vector == rhs.vector)
    }
}

// MARK: - BackendRegister methods

extension Register: BackendRegister {
    func applying(_ gate: RegisterGate) -> Register? {
        guard let nextVector = gate.apply(to: vector) else {
            os_log("applying failed: gate can not be applied to this register",
                   log: Register.logger,
                   type: .debug)

            return nil
        }

        return Register(vector: nextVector)
    }

    func measure(qubits: [Int]) -> [Double]? {
        guard areQubitsValid(qubits) else {
            os_log("measure failed: provide sorted list of unique qubits",
                   log: Register.logger,
                   type: .debug)

            return nil
        }

        var result = Array(repeating: Double(0), count: Int.pow(2, qubits.count))

        for index in 0..<vector.count {
            let derivedIndex = index.derived(takingBitsAt: qubits)
            let measure = vector[index].squaredModulus

            result[derivedIndex] += measure
        }

        return result
    }
}

// MARK: - Private body

private extension Register {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }

    // MARK: - Private methods

    func areQubitsValid(_ qubits: [Int]) -> Bool {
        return ((qubits.count > 0) &&
            areQubitsUnique(qubits) &&
            areQubitsInBound(qubits) &&
            areQubitsSorted(qubits))
    }

    func areQubitsUnique(_ qubits: [Int]) -> Bool {
        return (qubits.count == Set(qubits).count)
    }

    func areQubitsInBound(_ qubits: [Int]) -> Bool {
        let qubitCount = Int.log2(vector.count)
        let validQubits = (0..<qubitCount)

        return qubits.allSatisfy { validQubits.contains($0) }
    }

    func areQubitsSorted(_ qubits: [Int]) -> Bool {
        return (qubits == qubits.sorted(by: >))
    }

    // MARK: - Private class methods

    static func makeGroundState(qubitCount: Int) -> Vector? {
        guard (qubitCount > 0) else {
            return nil
        }

        let count = Int.pow(2, qubitCount)
        var elements = Array(repeating: Complex(0), count: count)
        elements[0] = Complex(1)

        return Vector(elements)
    }

    static func isAdditionOfSquareModulusInVectorEqualToOne(_ vector: Vector) -> Bool {
        return (abs(vector.squaredNorm - Double(1)) <= Constants.accuracy)
    }
}
