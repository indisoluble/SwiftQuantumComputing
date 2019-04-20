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

    // MARK: - Private properties

    private let vector: Vector

    // MARK: - Internal init methods

    enum InitQubitCountError: Error {
        case qubitCountHasToBeBiggerThanZero
    }

    init(qubitCount: Int) throws {
        guard qubitCount > 0 else {
            throw InitQubitCountError.qubitCountHasToBeBiggerThanZero
        }

        try! self.init(bits: String(repeating: "0", count: qubitCount))
    }

    enum InitBitsError: Error {
        case provideNonEmptyStringComposedOnlyOfZerosAndOnes
    }

    init(bits: String) throws {
        guard let value = Int(bits, radix: 2) else {
            throw InitBitsError.provideNonEmptyStringComposedOnlyOfZerosAndOnes
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
    func applying(_ gate: RegisterGate) throws -> Register {
        var nextVector: Vector!
        do {
            nextVector = try gate.apply(to: vector)
        } catch RegisterGate.ApplyError.vectorDoesNotHaveValidDimension {
            throw BackendRegisterApplyingError.gateDoesNotHaveValidDimension
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try Register(vector: nextVector)
        } catch Register.InitVectorError.additionOfSquareModulusIsNotEqualToOne {
            throw BackendRegisterApplyingError.additionOfSquareModulusInNextRegisterIsNotEqualToOne
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }

    func measure(qubits: [Int]) throws -> [Double] {
        guard qubits.count > 0 else {
            throw BackendRegisterMeasureError.emptyQubitList
        }

        guard areQubitsUnique(qubits) else {
            throw BackendRegisterMeasureError.qubitsAreNotUnique
        }

        guard areQubitsInBound(qubits) else {
            throw BackendRegisterMeasureError.qubitsAreNotInBound
        }

        guard areQubitsSorted(qubits) else {
            throw BackendRegisterMeasureError.qubitsAreNotSorted
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
