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

    private var measurements: [Double] {
        return (0..<vector.count).map { vector[$0].squaredModulus }
    }

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
        let roundedMeasurements = measurements.map { String(format: "%.2f", $0) }

        return ("[" + roundedMeasurements.joined(separator: ", ") + "]")
    }
}

// MARK: - Equatable methods

extension Register: Equatable {
    static func ==(lhs: Register, rhs: Register) -> Bool {
        return (lhs.vector == rhs.vector)
    }
}

// MARK: - CircuitRegister methods

extension Register: CircuitRegister {
    var qubitCount: Int {
        return Int.log2(vector.count)
    }

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

        let raw = measurements
        let indexed = (0..<raw.count).map { (rawIndex) -> (index: Int, measure: Double) in
            return (rawIndex.derived(takingBitsAt: qubits), raw[rawIndex])
        }

        return (0..<Int.pow(2, qubits.count)).map { (index) -> Double in
            return indexed.reduce(0) { $0 + ($1.index == index ? $1.measure : 0) }
        }
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
            !areQubitsRepeated(qubits) &&
            !areQubitsOutOfBound(qubits) &&
            areQubitsSorted(qubits))
    }

    func areQubitsRepeated(_ qubits: [Int]) -> Bool {
        return (qubits.count != Set(qubits).count)
    }

    func areQubitsOutOfBound(_ qubits: [Int]) -> Bool {
        let qubitCount = self.qubitCount

        return (qubits.index(where: { $0 >= qubitCount }) != nil)
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
