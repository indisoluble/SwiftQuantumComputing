//
//  GeneticError.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 27/04/2019.
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

// MARK: - Public errors

public enum EvolveError: Error {
    case configurationDepthHasToBeAPositiveNumber
    case configurationDepthIsEmpty
    case configurationPopulationSizeHasToBeBiggerThanZero
    case configurationPopulationSizeIsEmpty
    case configurationTournamentSizeHasToBeBiggerThanZero
    case gateInputCountIsBiggerThanUseCaseCircuitQubitCount(gate: Gate)
    case useCaseCircuitOutputHasToBeANonEmptyStringComposedOnlyOfZerosAndOnes(useCase: GeneticUseCase)
    case useCaseCircuitQubitCountHasToBeBiggerThanZero
    case useCaseListIsEmpty
    case useCaseMeasurementThrowedError(useCase: GeneticUseCase, error: MeasureError)
    case useCasesDoNotSpecifySameCircuitQubitCount
    case useCaseTruthTableQubitCountHasToBeBiggerThanZeroToMakeOracle(useCase: GeneticUseCase)
}
