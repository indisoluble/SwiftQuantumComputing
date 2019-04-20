//
//  InitialPopulationProducerTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 03/03/2019.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class InitialPopulationProducerTestDouble {

    // MARK: - Internal properties

    private (set) var executeCount = 0
    private (set) var lastExecuteSize: Int?
    private (set) var lastExecuteDepth: Range<Int>?
    var executeResult: [Fitness.EvalCircuit]?
    var executeError = InitialPopulationProducerExecuteError.useCaseEvaluatorsThrowedErrorsForAtLeastOneCircuit(errors: [])
}

// MARK: - InitialPopulationProducer methods

extension InitialPopulationProducerTestDouble: InitialPopulationProducer {
    func execute(size: Int, depth: Range<Int>) throws -> [Fitness.EvalCircuit] {
        executeCount += 1

        lastExecuteSize = size
        lastExecuteDepth = depth

        if let executeResult = executeResult {
            return executeResult
        }

        throw executeError
    }
}
