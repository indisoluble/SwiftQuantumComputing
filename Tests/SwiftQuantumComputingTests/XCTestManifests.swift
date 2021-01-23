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
        testCase(ArrayGate_QubitCountTests.allTests),
        testCase(DirectStatevectorTransformationTests.allTests),
        testCase(DirectStatevectorSingleQubitGateIndexerTests.allTests),
        testCase(DirectStatevectorMultiQubitGateIndexerTests.allTests),
        testCase(CircuitMatrixStatevectorTransformationTests.allTests),
        testCase(CircuitMatrixRowStatevectorTransformationTests.allTests),
        testCase(CircuitMatrixElementStatevectorTransformationTests.allTests),
        testCase(StatevectorRegisterAdapterTests.allTests),
        testCase(StatevectorRegisterFactoryAdapterTests.allTests),
        testCase(StatevectorSimulatorFacadeTests.allTests),
        testCase(UnitaryGateAdapterTests.allTests),
        testCase(UnitaryGateFactoryAdapterTests.allTests),
        testCase(UnitarySimulatorFacadeTests.allTests),
        testCase(CircuitFacadeTests.allTests),
        testCase(CircuitStatevectorAdapterTests.allTests),
        testCase(MainCircuitStatevectorFactoryTests.allTests),
        testCase(Circuit_StatevectorTests.allTests),
        testCase(Circuit_UnitaryTests.allTests),
        testCase(CircuitStatevectorFactory_BitsTests.allTests),
        testCase(CircuitStatevector_GroupedProbabilitiesTests.allTests),
        testCase(CircuitStatevector_ProbabilitiesTests.allTests),
        testCase(CircuitStatevector_SummarizedProbabilitiesTests.allTests),
        testCase(ComplexTests.allTests),
        testCase(Complex_EulerTests.allTests),
        testCase(Complex_MatrixTests.allTests),
        testCase(Rational_MagnitudeTests.allTests),
        testCase(Rational_OverloadedOperatorsTests.allTests),
        testCase(Rational_QuotientAndRemainderWithDivisionTypeTests.allTests),
        testCase(RationalTests.allTests),
        testCase(MatrixTests.allTests),
        testCase(Matrix_AverageTests.allTests),
        testCase(Matrix_ConjugateTransposedTests.allTests),
        testCase(Matrix_ElementsTests.allTests),
        testCase(Matrix_IdentityTests.allTests),
        testCase(Matrix_IsSquareTests.allTests),
        testCase(Matrix_PermutationTests.allTests),
        testCase(Matrix_QuantumFourierTransformTests.allTests),
        testCase(Matrix_TensorProductTests.allTests),
        testCase(Matrix_TransposedTests.allTests),
        testCase(Matrix_TwoLevelUnitaryTests.allTests),
        testCase(VectorTests.allTests),
        testCase(Vector_ElementsTests.allTests),
        testCase(Vector_EliminationMatrixTests.allTests),
        testCase(Vector_IsAdditionOfSquareModulusApproximatelyEqualToOneTests.allTests),
        testCase(Vector_StateTests.allTests),
        testCase(Array_CombinationsTests.allTests),
        testCase(Bool_XorTests.allTests),
        testCase(Double_RoundedToDecimalPlacesTests.allTests),
        testCase(Int_ActivatedBitsTests.allTests),
        testCase(Int_IsPowerOfTwoTests.allTests),
        testCase(Int_MaskTests.allTests),
        testCase(Int_QuotientAndRemainderWithDivisionTypeTests.allTests),
        testCase(Range_GrayCodesTests.allTests),
        testCase(String_ActivatedBitsTests.allTests),
        testCase(String_BitAndTests.allTests),
        testCase(String_BitsTests.allTests),
        testCase(String_BitXorTests.allTests),
        testCase(String_IsBitActivatedTests.allTests),
        testCase(Gate_OracleWithRangeInputsTests.allTests),
        testCase(Gate_SingleQubitGateRangeTargetsTests.allTests),
        testCase(Gate_OracleReplicatorTests.allTests),
        testCase(Gate_OracleTests.allTests),
        testCase(Gate_SingleQubitGateReplicatorTests.allTests),
        testCase(Gate_InversionAboutMeanTests.allTests),
        testCase(Gate_ModularExponentiationTests.allTests),
        testCase(Gate_QuantumFourierTransformTests.allTests),
        testCase(Gate_InversionAboutMeanWithRangeInputsTests.allTests),
        testCase(Gate_ModularExponentiationWithRangeExponentAndInputsTests.allTests),
        testCase(Gate_SimulatorGateTests.allTests),
        testCase(Gate_ControlledNotTests.allTests),
        testCase(FixedControlledGateTests.allTests),
        testCase(FixedOracleGateTests.allTests),
        testCase(GateTests.allTests),
        testCase(MainGeneticCircuitEvaluatorTests.allTests),
        testCase(MainGeneticUseCaseEvaluatorTests.allTests),
        testCase(ControlledGateTests.allTests),
        testCase(HadamardGateTests.allTests),
        testCase(MatrixGateTests.allTests),
        testCase(NotGateTests.allTests),
        testCase(OracleGateTests.allTests),
        testCase(PhaseShiftGateTests.allTests),
        testCase(RotationGateTests.allTests),
        testCase(MainGeneticGatesRandomizerFactoryTests.allTests),
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
        testCase(GeneticConfigurationTests.allTests),
        testCase(GeneticUseCaseTests.allTests),
        testCase(MainGeneticFactoryTests.allTests),
        testCase(SimulatorCircuitMatrixTests.allTests),
        testCase(Array_RearrangeBitsTests.allTests),
        testCase(BitwiseShiftTests.allTests),
        testCase(SimulatorGateMatrix_CountTests.allTests),
        testCase(SimulatorGateMatrix_MatrixTests.allTests),
        testCase(OracleSimulatorMatrixTests.allTests),
        testCase(ContinuedFractionsSolverTests.allTests),
        testCase(EuclideanSolverTests.allTests),
        testCase(TwoLevelDecompositionSolverTests.allTests),
        testCase(TwoLevelDecompositionSolver_GatesTests.allTests),
        testCase(XorEquationSystemAdapterTests.allTests),
        testCase(XorEquationSystemBruteForceSolverTests.allTests),
        testCase(XorEquationSystemPreSimplificationSolverTests.allTests),
        testCase(XorGaussianEliminationSolverFacadeTests.allTests),
        testCase(XorGaussianEliminationSolver_ActivatedBitsTests.allTests)
    ]
}

#endif
