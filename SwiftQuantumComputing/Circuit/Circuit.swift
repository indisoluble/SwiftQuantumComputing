//
//  Circuit.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
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

enum CircuitError: Error {
    case informBitsAsANonEmptyStringComposedOnlyOfZerosAndOnes
    case unableToExtractMatrixFromGate(at: Int)
    case gateMatrixIsNotSquare(at: Int)
    case gateMatrixRowCountHasToBeAPowerOfTwo(at: Int)
    case gateMatrixHandlesMoreQubitsThanAreAvailable(at: Int)
    case gateInputCountDoesNotMatchMatrixQubitCount(at: Int)
    case gateInputsAreNotUnique(at: Int)
    case gateInputsAreNotInBound(at: Int)
    case gateIsNotUnitary(at: Int)
    case gateDoesNotHaveValidDimension(at: Int)
    case additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(at: Int)
    case emptyQubitList
    case qubitsAreNotUnique
    case qubitsAreNotInBound
    case qubitsAreNotSorted
}

// MARK: - Protocol definition

public protocol Circuit {
    func measure(qubits: [Int], afterInputting bits: String) throws -> [Double]
}
