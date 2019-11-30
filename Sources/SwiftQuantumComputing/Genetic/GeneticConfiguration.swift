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

/// Configuration of a genetic algorithm to evolve a quantum circuit
public struct GeneticConfiguration {

    // MARK: - Public properties

    /// Number of gates in an evolved circuits will be between the boundaries specified by `depth`
    public let depth: Range<Int>
    /// Maximum number of times a reproduction operation will be applied to increase the number of evolved circuits in a population
    public let generationCount: Int
    /// Number of evolved circuits produced by a genetic algorithm will be between the boundaries specified by `populationSize`.
    /// The minimum size is the size of the initial population of randomly generated circuits
    public let populationSize: Range<Int>
    /// A reproduction operation is applied over a sub-set of the entire population of evolved circuits. `tournamentSize` is the
    /// size of this sub-set
    public let tournamentSize: Int
    /// There are 2 reproduction operations: cross-over and mutation. `mutationProbability` is the probability of applying
    /// the latter on each new generation. It is expected to take a value between 0.0 and 1.0
    public let mutationProbability: Double
    /// An evolved circuit is evaluated against multiple `GeneticUseCase` instances. Each evaluation returns a a score,
    /// the lowest the score, the better a circuit solves a given `GeneticUseCase` instance. If the score is below this `threshold`,
    /// the circuit is considered in the right track to solve the use case
    public let threshold: Double
    /// If the total score of an evolved circuit (i.e. the score considering all `GeneticUseCase` instances) is below
    /// `errorProbability`, the circuit is considered a solution for the entire problem
    public let errorProbability: Double

    // MARK: - Public init methods

    /// Initialize a `GeneticConfiguration` instance
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
