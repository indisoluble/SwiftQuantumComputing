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

public struct Register {

    // MARK: - Public properties

    var measurements: [Double] {
        return (0..<vector.count).map { vector[$0].squaredModulus }
    }

    // MARK: - Private properties

    private let vector: Vector

    // MARK: - Init methods

    public init?(qubitCount: Int) {
        guard let groundState = Register.makeGroundState(qubitCount: qubitCount) else {
            return nil
        }

        self.init(vector: groundState)
    }

    init?(vector: Vector) {
        guard Register.isAdditionOfSquareModulusInVectorEqualToOne(vector) else {
            return nil
        }

        self.vector = vector
    }

    // MARK: - Public methods

    public func applying(_ gate: Gate) -> Register? {
        guard let nextVector = gate.apply(to: vector) else {
            return nil
        }

        return Register(vector: nextVector)
    }

    public func measure(qubits: Int...) -> [Double]? {
        guard areQubitsValid(qubits) else {
            return nil
        }

        let qubitCount = Int.log2(vector.count)
        let reversedBitPositions = qubits.map { qubitCount - $0 - 1 }
        let bitPositions = Array(reversedBitPositions.reversed())

        let raw = measurements
        let indexed = (0..<raw.count).map { (rawIndex) -> (index: Int, measure: Double) in
            return (rawIndex.derived(takingBitsAt: bitPositions), raw[rawIndex])
        }

        return (0..<Int.pow(2, qubits.count)).map { (index) -> Double in
            return indexed.reduce(0) { $0 + ($1.index == index ? $1.measure : 0) }
        }
    }
}

// MARK: - CustomStringConvertible methods

extension Register: CustomStringConvertible {
    public var description: String {
        let roundedMeasurements = measurements.map { String(format: "%.2f", $0) }

        return ("[" + roundedMeasurements.joined(separator: ", ") + "]")
    }
}

// MARK: - Equatable methods

extension Register: Equatable {
    public static func ==(lhs: Register, rhs: Register) -> Bool {
        return (lhs.vector == rhs.vector)
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
        return (!areQubitsRepeated(qubits) &&
            !areQubitsOutOfBound(qubits) &&
            areQubitsSorted(qubits))
    }

    func areQubitsRepeated(_ qubits: [Int]) -> Bool {
        return (qubits.count != Set(qubits).count)
    }

    func areQubitsOutOfBound(_ qubits: [Int]) -> Bool {
        let qubitCount = Int.log2(vector.count)

        return (qubits.index(where: { $0 >= qubitCount }) != nil)
    }

    func areQubitsSorted(_ qubits: [Int]) -> Bool {
        return (qubits == qubits.sorted())
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
