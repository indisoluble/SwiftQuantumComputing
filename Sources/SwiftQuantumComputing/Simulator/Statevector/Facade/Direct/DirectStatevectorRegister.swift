//
//  DirectStatevectorRegister.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/04/2020.
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

// MARK: - Main body

struct DirectStatevectorRegister {

    // MARK: - SimpleStatevectorRegister properties

    let vector: Vector

    // MARK: - Private properties

    private let qubitCount: Int
    private let factory: StatevectorTransformationFactory
    private let transformation: StatevectorTransformation

    // MARK: - Internal init methods

    enum InitError: Error {
        case vectorCountHasToBeAPowerOfTwo
    }

    init(vector: Vector, factory: StatevectorTransformationFactory) throws {
        var transformation: StatevectorTransformation!
        do {
            transformation = try factory.makeTransformation(state: vector)
        } catch MakeTransformationError.stateCountHasToBeAPowerOfTwo {
            throw InitError.vectorCountHasToBeAPowerOfTwo
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        qubitCount = Int.log2(vector.count)
        self.transformation = transformation

        self.vector = vector
        self.factory = factory
    }
}

// MARK: - StatevectorMeasurement methods

extension DirectStatevectorRegister: StatevectorMeasurement {}

// MARK: - SimpleStatevectorMeasurement methods

extension DirectStatevectorRegister: SimpleStatevectorMeasurement {}

// MARK: - SimulatorTransformation methods

extension DirectStatevectorRegister: SimulatorTransformation {
    func applying(_ gate: SimulatorGate) throws -> DirectStatevectorRegister {
        let (baseMatrix, inputs) = try gate.extractComponents(restrictedToCircuitQubitCount: qubitCount)

        let nextVector = applying(gateMatrix: baseMatrix, toInputs: inputs)

        return try! DirectStatevectorRegister(vector: nextVector, factory: factory)
    }
}

// MARK: - StatevectorTransformation methods

extension DirectStatevectorRegister: StatevectorTransformation {
    func applying(gateMatrix: Matrix, toInputs inputs: [Int]) -> Vector {
        var nextVector: Vector!

        if inputs.count == 1 {
            nextVector = applying(oneQubitMatrix: gateMatrix, toInput: inputs.first!)
        } else {
            nextVector = transformation.applying(gateMatrix: gateMatrix, toInputs: inputs)
        }

        return nextVector
    }
}

// MARK: - Private body

private extension DirectStatevectorRegister {

    // MARK: - Private methods

    func applying(oneQubitMatrix matrix: Matrix, toInput input: Int) -> Vector {
            let mask = 1 << input
            let invMask = ~mask

            return try! Vector.makeVector(count: vector.count) { index in
                var value: Complex!

                if index & mask == 0 {
                    let otherIndex = index | mask

                    value = matrix[0, 0] * vector[index] + matrix[0, 1] * vector[otherIndex]
                } else {
                    let otherIndex = index & invMask

                    value = matrix[1, 0] * vector[otherIndex] + matrix[1, 1] * vector[index]
                }

                return value
        }
    }
}
