//
//  GeneticConfiguration.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/01/2019.
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

// MARK: - Main body

public struct GeneticConfiguration {

    // MARK: - Public properties

    public let depth: Range<Int>
    public let generationCount: Int
    public let populationSize: Range<Int>
    public let tournamentSize: Int
    public let mutationProbability: Double
    public let threshold: Double
    public let errorProbability: Double

    // MARK: - Public init methods

    public init(depth: Range<Int>,
                generationCount: Int,
                populationSize: Range<Int>,
                tournamentSize: Int,
                mutationProbability: Double,
                threshold: Double,
                errorProbability: Double) {
        self.depth = depth
        self.generationCount = generationCount
        self.populationSize = populationSize
        self.tournamentSize = tournamentSize
        self.mutationProbability = mutationProbability
        self.threshold = threshold
        self.errorProbability = errorProbability
    }
}
