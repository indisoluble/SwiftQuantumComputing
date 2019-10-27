//
//  QuantumRegister+ApplyingGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/10/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

extension QuantumRegister {
    func applying(_ gate: QuantumGate) throws -> QuantumRegister {
        var nextVector: Vector!
        do {
            nextVector = try gate.matrix * statevector
        } catch Vector.ProductError.matrixColumnCountDoesNotMatchVectorCount {
            throw GateError.gateQubitCountDoesNotMatchCircuitQubitCount
        } catch {
            fatalError("Unexpected error: \(error).")
        }

        do {
            return try QuantumRegister(vector: nextVector)
        } catch QuantumRegister.InitVectorError.additionOfSquareModulusIsNotEqualToOne {
            throw GateError.additionOfSquareModulusIsNotEqualToOneAfterApplyingGateToStatevector
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
