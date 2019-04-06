//
//  BackendRegister.swift
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

// MARK: - Errors

enum BackendRegisterApplyingError: Error {
    case gateDoesNotHaveValidDimension
    case additionOfSquareModulusInNextRegisterIsNotEqualToOne
}

enum BackendRegisterMeasureError: Error {
    case emptyQubitList
    case qubitsAreNotUnique
    case qubitsAreNotInBound
    case qubitsAreNotSorted
}

// MARK: - Protocol definition

protocol BackendRegister {
    func applying(_ gate: RegisterGate) throws -> Self
    func measure(qubits: [Int]) throws -> [Double]
}
