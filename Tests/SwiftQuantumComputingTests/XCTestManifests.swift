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
        testCase(ArraySimulatorGate_QubitCountTests.allTests),
        testCase(StatevectorRegisterAdapterTests.allTests),
        testCase(StatevectorRegisterFactoryAdapterTests.allTests),
        testCase(StatevectorSimulatorFacadeTests.allTests),
        testCase(UnitaryGateAdapterTests.allTests),
        testCase(UnitaryGateFactoryAdapterTests.allTests),
        testCase(UnitarySimulatorFacadeTests.allTests),
        testCase(CircuitFacadeTests.allTests),
        testCase(Circuit_ProbabilitiesTests.allTests),
        testCase(Circuit_StatevectorTests.allTests),
        testCase(Circuit_SummarizedProbabilitiesTests.allTests),
        testCase(Circuit_UnitaryTests.allTests),
        testCase(ComplexTests.allTests),
        testCase(MatrixTests.allTests),
        testCase(Matrix_AverageTests.allTests),
        testCase(Matrix_ElementsTests.allTests),
        testCase(Matrix_IdentityTests.allTests),
        testCase(Matrix_TensorProductTests.allTests),
        testCase(VectorTests.allTests),
        testCase(Vector_ElementsTests.allTests),
        testCase(Array_CombinationsTests.allTests),
        testCase(Bool_XorTests.allTests),
        testCase(Int_DerivedTests.allTests),
        testCase(Int_IsPowerOfTwoTests.allTests),
        testCase(Int_RemainderWithDivisionTypeTests),
        testCase(String_ActivatedBitsTests.allTests),
        testCase(String_BitAndTests.allTests),
        testCase(String_BitXorTests.allTests),
        testCase(String_IsBitActivatedTests.allTests),
        testCase(Matrix_ControlledMatrixTests.allTests),
        testCase(Matrix_OracleTests.allTests),
        testCase(Gate_OracleWithRangeInputsTests.allTests),
        testCase(Gate_SingleQubitGateRangeTargetsTests.allTests),
        testCase(Gate_OracleReplicatorTests.allTests),
        testCase(Gate_SingleQubitGateReplicatorTests.allTests),
        testCase(Gate_InversionAboutMeanTests.allTests),
        testCase(Gate_ModularExponentiationTests.allTests),
        testCase(Gate_InversionAboutMeanWithRangeInputsTests.allTests),
        testCase(Gate_ModularExponentiationWithRangeExponentAndInputsTests.allTests),
        testCase(MainGeneticCircuitEvaluatorTests.allTests),
        testCase(MainGeneticUseCaseEvaluatorTests.allTests),
        testCase(ControlledMatrixGateTests.allTests),
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
        testCase(SimulatorCircuitMatrixFactoryAdapterTests.allTests),
        testCase(EuclideanSolverTests.allTests),
        testCase(XorEquationSystemAdapterTests.allTests),
        testCase(XorEquationSystemBruteForceSolverTests.allTests),
        testCase(XorEquationSystemPreSimplificationSolverTests.allTests),
        testCase(XorGaussianEliminationSolverFacadeTests.allTests),
        testCase(XorGaussianEliminationSolver_ActivatedBitsTests.allTests)
    ]
}

#endif
