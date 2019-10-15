//
//  XCTestManifests.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 16/06/2019.
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

#if !os(macOS)

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StatevectorRegisterAdapterTests.allTests),
        testCase(StatevectorSimulatorFacadeTests.allTests),
        testCase(CircuitFacadeTests.allTests),
        testCase(Circuit_ProbabilitiesTests.allTests),
        testCase(ComplexTests.allTests),
        testCase(MatrixTests.allTests),
        testCase(VectorTests.allTests),
        testCase(Int_DerivedTests.allTests),
        testCase(Int_IsPowerOfTwoTests.allTests),
        testCase(Matrix_OracleTests.allTests),
        testCase(MainGeneticCircuitEvaluatorTests.allTests),
        testCase(MainGeneticUseCaseEvaluatorTests.allTests),
        testCase(ControlledNotGateTests.allTests),
        testCase(HadamardGateTests.allTests),
        testCase(MatrixGateTests.allTests),
        testCase(NotGateTests.allTests),
        testCase(OracleGateTests.allTests),
        testCase(PhaseShiftGateTests.allTests),
        testCase(MainGeneticGatesRandomizerTests.allTests),
        testCase(MainInitialPopulationProducerTests.allTests),
        testCase(MainInitialPopulationProducerFactoryTests.allTests),
        testCase(ConfigurableGeneticGateTests.allTests),
        testCase(SimpleGeneticGateFactoryTests.allTests),
        testCase(MainOracleCircuitFactoryTests.allTests),
        testCase(MainGeneticCircuitMutationTests.allTests),
        testCase(MainGeneticCircuitMutationFactoryTests.allTests),
        testCase(MainGeneticPopulationCrossoverFactoryTests.allTests),
        testCase(MainGeneticPopulationCrossoverTests.allTests),
        testCase(MainGeneticPopulationMutationTests.allTests),
        testCase(MainGeneticPopulationMutationFactoryTests.allTests),
        testCase(MainGeneticPopulationReproductionTests.allTests),
        testCase(MainGeneticPopulationReproductionFactoryTests.allTests),
        testCase(GeneticUseCaseTests.allTests),
        testCase(MainGeneticFactoryTests.allTests),
        testCase(Register_ApplyingGateTests.allTests),
        testCase(RegisterTests.allTests),
        testCase(RegisterGateFactoryTests.allTests),
        testCase(RegisterGateTests.allTests),
        testCase(Vector_ElementsTests.allTests)
    ]
}

#endif
