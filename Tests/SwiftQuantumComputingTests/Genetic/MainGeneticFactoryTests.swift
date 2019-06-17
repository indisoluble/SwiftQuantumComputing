//
//  MainGeneticFactoryTests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/03/2019.
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

class MainGeneticFactoryTests: XCTestCase {

    // MARK: - Properties

    let initialPopulationFactory = InitialPopulationProducerFactoryTestDouble()
    let initialPopulation = InitialPopulationProducerTestDouble()
    let population: [Fitness.EvalCircuit] = [(0.0, [GeneticGateTestDouble()])]
    let fitness = FitnessTestDouble()
    let fittestResult: Fitness.EvalCircuit = (1.0, [GeneticGateTestDouble()])
    let reproductionFactory = GeneticPopulationReproductionFactoryTestDouble()
    let reproduction = GeneticPopulationReproductionTestDouble()
    let reproductionResult: [Fitness.EvalCircuit] = [(0.0, [GeneticGateTestDouble()])]
    let oracleFactory = OracleCircuitFactoryTestDouble()
    let oracleCircuit: OracleCircuitFactory.OracleCircuit = ([], nil)
    let useCase = try! GeneticUseCase(emptyTruthTableQubitCount: 0, circuitOutput: "0")
    let gates: [Gate] = []

    // MARK: - Tests

    func testEmptyPopulationSize_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<0),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 0)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testEmptyDepth_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<0),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 0)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testEmptyUseCases_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 0)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testUseCasesWithDifferentCircuitQubitCount_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        let extraCircuitOutput = String(repeating: "0", count: useCase.circuit.qubitCount + 1)
        let extraUseCase = try! GeneticUseCase(emptyTruthTableQubitCount: 0,
                                               circuitOutput: extraCircuitOutput)

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase, extraUseCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 0)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testInitialPopulationFactoryThrowException_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testReproductionFactoryThrowException_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 0)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testInitialPopulationThrowException_evolveCircuit_throwException() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation
        reproductionFactory.makeReproductionResult = reproduction

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // Then
        XCTAssertThrowsError(try factory.evolveCircuit(configuration: configuration,
                                                       useCases: [useCase],
                                                       gates: gates))
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 1)
        XCTAssertEqual(fitness.fittestCount, 0)
        XCTAssertEqual(reproduction.appliedCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 0)
    }

    func testGenerationCountEqualToZero_evolveCircuit_reproductionIsNotApplied() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 0,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation
        initialPopulation.executeResult = population
        fitness.fittestResult = fittestResult
        reproductionFactory.makeReproductionResult = reproduction
        oracleFactory.makeOracleCircuitResult = oracleCircuit

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // When
        let result = try? factory.evolveCircuit(configuration: configuration,
                                                useCases: [useCase],
                                                gates: gates)

        // Then
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(reproduction.appliedCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertNotNil(result)
    }

    func testGenerationBiggerThanZeroAndSmallerThanPopulationSize_evolveCircuit_reproductionIsAppliedExpectedCount() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation
        initialPopulation.executeResult = population
        fitness.fittestResult = fittestResult
        reproductionFactory.makeReproductionResult = reproduction
        reproduction.appliedResult = reproductionResult
        oracleFactory.makeOracleCircuitResult = oracleCircuit

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // When
        let result = try? factory.evolveCircuit(configuration: configuration,
                                                useCases: [useCase],
                                                gates: gates)

        // Then
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 1)
        XCTAssertEqual(fitness.fittestCount, configuration.generationCount + 1)
        XCTAssertEqual(reproduction.appliedCount, configuration.generationCount)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertNotNil(result)
    }

    func testPopulationSizeEqualToZero_evolveCircuit_reproductionIsNotApplied() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 0,
                                                 populationSize: (0..<1),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation
        initialPopulation.executeResult = population
        fitness.fittestResult = fittestResult
        reproductionFactory.makeReproductionResult = reproduction
        oracleFactory.makeOracleCircuitResult = oracleCircuit

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // When
        let result = try? factory.evolveCircuit(configuration: configuration,
                                                useCases: [useCase],
                                                gates: gates)

        // Then
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(reproduction.appliedCount, 0)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertNotNil(result)
    }

    func testReproductionReturnEmpty_evolveCircuit_fitnessIsAppliedExpectedCount() {
        // Given
        let configuration = GeneticConfiguration(depth: (0..<10),
                                                 generationCount: 10,
                                                 populationSize: (0..<100),
                                                 tournamentSize: 0,
                                                 mutationProbability: 0.0,
                                                 threshold: 0.0,
                                                 errorProbability: 0.0)

        initialPopulationFactory.makeProducerResult = initialPopulation
        initialPopulation.executeResult = population
        fitness.fittestResult = fittestResult
        reproductionFactory.makeReproductionResult = reproduction
        oracleFactory.makeOracleCircuitResult = oracleCircuit

        let factory = MainGeneticFactory(initialPopulationFactory: initialPopulationFactory,
                                         fitness: fitness,
                                         reproductionFactory: reproductionFactory,
                                         oracleFactory: oracleFactory)

        // When
        let result = try? factory.evolveCircuit(configuration: configuration,
                                                useCases: [useCase],
                                                gates: gates)

        // Then
        XCTAssertEqual(initialPopulationFactory.makeProducerCount, 1)
        XCTAssertEqual(reproductionFactory.makeReproductionCount, 1)
        XCTAssertEqual(initialPopulation.executeCount, 1)
        XCTAssertEqual(fitness.fittestCount, 1)
        XCTAssertEqual(reproduction.appliedCount, configuration.generationCount)
        XCTAssertEqual(oracleFactory.makeOracleCircuitCount, 1)
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testEmptyPopulationSize_evolveCircuit_throwException",
         testEmptyPopulationSize_evolveCircuit_throwException),
        ("testEmptyDepth_evolveCircuit_throwException",
         testEmptyDepth_evolveCircuit_throwException),
        ("testEmptyUseCases_evolveCircuit_throwException",
         testEmptyUseCases_evolveCircuit_throwException),
        ("testUseCasesWithDifferentCircuitQubitCount_evolveCircuit_throwException",
         testUseCasesWithDifferentCircuitQubitCount_evolveCircuit_throwException),
        ("testInitialPopulationFactoryThrowException_evolveCircuit_throwException",
         testInitialPopulationFactoryThrowException_evolveCircuit_throwException),
        ("testReproductionFactoryThrowException_evolveCircuit_throwException",
         testReproductionFactoryThrowException_evolveCircuit_throwException),
        ("testInitialPopulationThrowException_evolveCircuit_throwException",
         testInitialPopulationThrowException_evolveCircuit_throwException),
        ("testGenerationCountEqualToZero_evolveCircuit_reproductionIsNotApplied",
         testGenerationCountEqualToZero_evolveCircuit_reproductionIsNotApplied),
        ("testGenerationBiggerThanZeroAndSmallerThanPopulationSize_evolveCircuit_reproductionIsAppliedExpectedCount",
         testGenerationBiggerThanZeroAndSmallerThanPopulationSize_evolveCircuit_reproductionIsAppliedExpectedCount),
        ("testPopulationSizeEqualToZero_evolveCircuit_reproductionIsNotApplied",
         testPopulationSizeEqualToZero_evolveCircuit_reproductionIsNotApplied),
        ("testReproductionReturnEmpty_evolveCircuit_fitnessIsAppliedExpectedCount",
         testReproductionReturnEmpty_evolveCircuit_fitnessIsAppliedExpectedCount)
    ]
}
