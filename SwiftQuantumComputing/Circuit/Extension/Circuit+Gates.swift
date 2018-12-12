//
//  Circuit+Gates.swift
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

// MARK: - Main body

extension Circuit {

    // MARK: - Public methods

    public func applyingControlledNotGate(to target: Int, controlledBy control: Int) -> Self? {
        return applyingGate(.controlledNot(target: target, control: control))
    }

    public func applyingHadamardGate(to target: Int) -> Self? {
        return applyingGate(.hadamard(target: target))
    }

    public func applyingNotGate(to target: Int) -> Self? {
        return applyingGate(.not(target: target))
    }

    public func applyingOracleGate(builtWith matrix: Matrix, inputs: [Int]) -> Self? {
        return applyingGate(.oracle(matrix: matrix, inputs: inputs))
    }

    public func applyingPhaseShiftGate(builtWith radians: Double, to target: Int) -> Self? {
        return applyingGate(.phaseShift(radians: radians, target: target))
    }
}
