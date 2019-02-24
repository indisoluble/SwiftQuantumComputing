//
//  MainInitialPopulationProducerFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/02/2019.
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

import XCTest

@testable import SwiftQuantumComputing

// MARK: - Main body

class MainInitialPopulationProducerFactoryTests: XCTestCase {

    // MARK: - Properties

    let generatorFactory = GeneticGatesRandomizerFactoryTestDouble()
    let evaluatorFactory = GeneticCircuitEvaluatorFactoryTestDouble()
    let score = GeneticCircuitScoreTestDouble()

    // MARK: - Tests

    func testGeneratorFactoryThatReturnNil_makeProducer_returnNil() {
        // Given
        let producer = MainInitialPopulationProducerFactory(generatorFactory: generatorFactory,
                                                            evaluatorFactory: evaluatorFactory,
                                                            score: score)

        // Then
        XCTAssertNil(producer.makeProducer(qubitCount: 0, threshold: 0, useCases: [], gates: []))
    }

    func testGeneratorFactoryThatReturnGenerator_makeProducer_returnProducer() {
        // Given
        generatorFactory.makeRandomizerResult = GeneticGatesRandomizerTestDouble()

        let producer = MainInitialPopulationProducerFactory(generatorFactory: generatorFactory,
                                                            evaluatorFactory: evaluatorFactory,
                                                            score: score)

        // Then
        XCTAssertNotNil(producer.makeProducer(qubitCount: 0, threshold: 0, useCases: [], gates: []))
    }
}
