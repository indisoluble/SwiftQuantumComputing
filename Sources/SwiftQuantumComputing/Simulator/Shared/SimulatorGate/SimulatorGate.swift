//
//  SimulatorGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 09/12/2018.
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

// MARK: - Protocol definition

protocol SimulatorGate {
    typealias Components = (simulatorGateMatrix: SimulatorGateMatrix, inputs: [Int])

    func extractComponents(restrictedToCircuitQubitCount qubitCount: Int) -> Result<Components, GateError>
}

// MARK: - SimulatorGate default implementations

extension SimulatorGate where Self: SimulatorInputExtracting & SimulatorComponents {
    func extractComponents(restrictedToCircuitQubitCount qubitCount: Int) -> Result<Components, GateError> {
        let inputs = extractRawInputs()
        guard areInputsUnique(inputs) else {
            return .failure(.gateInputsAreNotUnique)
        }

        var simulatorGateMatrix: SimulatorGateMatrix!
        switch extractMatrix() {
        case .success(let extractedMatrix):
            simulatorGateMatrix = extractedMatrix
        case .failure(let error):
            return .failure(error)
        }

        guard doesInputCountMatchMatrixQubitCount(inputs, matrix: simulatorGateMatrix) else {
            return .failure(.gateInputCountDoesNotMatchGateMatrixQubitCount)
        }

        guard qubitCount > 0 else {
            return .failure(.circuitQubitCountHasToBeBiggerThanZero)
        }

        guard doesMatrixFitInCircuit(simulatorGateMatrix, qubitCount: qubitCount) else {
            return .failure(.gateMatrixHandlesMoreQubitsThatCircuitActuallyHas)
        }

        guard areInputsInBound(inputs, qubitCount: qubitCount) else {
            return .failure(.gateInputsAreNotInBound)
        }

        return .success((simulatorGateMatrix, inputs))
    }
}

// MARK: - Private body

private extension SimulatorGate {

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func doesInputCountMatchMatrixQubitCount(_ inputs: [Int], matrix: SimulatorGateMatrix) -> Bool {
        let matrixQubitCount = Int.log2(matrix.matrixCount)

        return (inputs.count == matrixQubitCount)
    }

    func doesMatrixFitInCircuit(_ matrix: SimulatorGateMatrix, qubitCount: Int) -> Bool {
        let matrixQubitCount = Int.log2(matrix.matrixCount)

        return matrixQubitCount <= qubitCount
    }

    func areInputsInBound(_ inputs: [Int], qubitCount: Int) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }
}
