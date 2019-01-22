//
//  FixedGate+BackendGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/12/2018.
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

// MARK: - BackendGate methods

extension FixedGate: BackendGate {
    func extract() -> (matrix: Matrix?, inputs: [Int]) {
        switch self {
        case .controlledNot(let target, let control):
            return (Constants.matrixControlledNot, [control, target])
        case .hadamard(let target):
            return (Constants.matrixHadamard, [target])
        case .matrix(let matrix, let inputs):
            return (matrix, inputs)
        case .not(let target):
            return (Constants.matrixNot, [target])
        case .oracle(let truthTable, let target, let controls):
            let matrix = Matrix.makeOracle(truthTable: truthTable, controlCount: controls.count)
            let inputs = controls + [target]

            return (matrix, inputs)
        case .phaseShift(let radians, let target):
            return (Matrix.makePhaseShift(radians: radians), [target])
        }
    }
}

// MARK: - Private body

private extension FixedGate {

    // MARK: - Constants

    enum Constants {
        static let matrixControlledNot = Matrix.makeControlledNot()
        static let matrixHadamard = Matrix.makeHadamard()
        static let matrixNot = Matrix.makeNot()
    }
}
