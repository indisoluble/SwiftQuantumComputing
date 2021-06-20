//
//  CosineSineDecompositionSolver.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/03/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

struct CosineSineDecompositionSolver {}

// MARK: - SingleQubitGateDecompositionSolver methods

extension CosineSineDecompositionSolver: SingleQubitGateDecompositionSolver {
    func decomposeGate(_ gate: Gate) -> [Gate] {
        let extractor = SimulatorMatrixComponentsExtractor(extractor: gate)

        var matrix = try! extractor.extractMatrix().get().expandedRawMatrix(maxConcurrency: 1).get()
        if matrix.isApproximatelyEqual(to: Constants.matrixIdentity,
                                       absoluteTolerance: SharedConstants.tolerance) {
            return []
        }

        let target = extractor.extractRawInputs().first!
        if matrix.isApproximatelyEqual(to: Constants.matrixNot,
                                       absoluteTolerance: SharedConstants.tolerance) {
            return [.not(target: target)]
        }

        var result: [Gate] = []

        // Is matrix special unitary? i.e. is det(matrix) equal to Double(1) instead of a Complex
        // with absolute value 1? If det(matrix) is Double(1), its phase/angle is Double(0)
        let phi = determinant(of: matrix).phase
        if !phi.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
            // Turn matrix into a special unitary
            matrix = try! (.makePhaseShift(radians: -phi) * matrix).get()

            result.append(.phaseShift(radians: phi, target: target))

            if matrix.isApproximatelyEqual(to: Constants.matrixIdentity,
                                           absoluteTolerance: SharedConstants.tolerance) {
                return result
            }

            if matrix.isApproximatelyEqual(to: Constants.matrixNot,
                                           absoluteTolerance: SharedConstants.tolerance) {
                result.append(.not(target: target))

                return result
            }
        }

        let m00 = matrix[0,0]
        let theta = -acos(m00.length)
        let lmbda = (
            m00.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) ?
                0.0 :
                -m00.phase
        )

        let m01 = matrix[0,1]
        if m01.isApproximatelyEqual(to: .zero, absoluteTolerance: SharedConstants.tolerance) {
            result.insert(.rotation(axis: .z, radians: (2.0 * lmbda), target: target), at: 0)
        } else {
            let mu = -m01.phase

            if !(lmbda + mu).isApproximatelyEqual(to: .zero,
                                                  absoluteTolerance: SharedConstants.tolerance) {
                result.insert(.rotation(axis: .z, radians: (lmbda + mu), target: target), at: 0)
            }
            if !(2.0 * theta).isApproximatelyEqual(to: .zero,
                                                   absoluteTolerance: SharedConstants.tolerance) {
                result.insert(.rotation(axis: .y, radians: (2.0 * theta), target: target), at: 0)
            }
            if !(lmbda - mu).isApproximatelyEqual(to: .zero,
                                                  absoluteTolerance: SharedConstants.tolerance) {
                result.insert(.rotation(axis: .z, radians: (lmbda - mu), target: target), at: 0)
            }
        }

        return result
    }
}

// MARK: - Private body

private extension CosineSineDecompositionSolver {

    // MARK: - Constants

    enum Constants {
        static let matrixIdentity = try! Matrix.makeIdentity(count: 2).get()
        static let matrixNot = Matrix.makeNot()
    }

    // MARK: - Private methods

    func determinant(of matrix: SimulatorMatrix) -> Complex<Double> {
        return matrix[0,0] * matrix[1,1] - matrix[0,1] * matrix[1,0]
    }
}
