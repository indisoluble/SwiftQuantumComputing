//
//  GeneticUseCaseCircuitEvaluationError.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 20/04/2019.
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

// MARK: - Errors

enum GeneticUseCaseEvaluationError: Error {
    case truthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(at: Int)
    case truthTableRequiresMoreInputQubitsThatAreAvailableToMakeOracle(at: Int)
    case unableToExtractMatrixFromGate(around: Int)
    case gateMatrixIsNotSquare(around: Int)
    case gateMatrixRowCountHasToBeAPowerOfTwo(around: Int)
    case gateMatrixHandlesMoreQubitsThanAreAvailable(around: Int)
    case gateInputCountDoesNotMatchMatrixQubitCount(around: Int)
    case gateInputsAreNotUnique(around: Int)
    case gateInputsAreNotInBound(around: Int)
    case gateIsNotUnitary(around: Int)
    case gateDoesNotHaveValidDimension(around: Int)
    case additionOfSquareModulusIsNotEqualToOneAfterApplyingGate(around: Int)
    case evaluatorForCircuitWithMoreQubits
    case useCaseCircuitInputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
    case useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes
    case useCaseCircuitOutputHasMoreQubitsThatCircuitHas
}
