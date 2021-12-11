//
//  MainCircuitDensityMatrixFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/07/2021.
//  Copyright © 2021 Enrique de la Torre. All rights reserved.
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

/// Conforms `CircuitDensityMatrixFactory`. Use to create new `CircuitDensityMatrix` instances
public struct MainCircuitDensityMatrixFactory {

    /// Initialize a `MainCircuitDensityMatrixFactory` instance
    public init() {}
}

// MARK: - CircuitDensityMatrixFactory methods

extension MainCircuitDensityMatrixFactory: CircuitDensityMatrixFactory {
    /// Check `CircuitDensityMatrixFactory.makeDensityMatrix(matrix::)`
    public func makeDensityMatrix(matrix: Matrix) -> Result<CircuitDensityMatrix & CircuitProbabilities, MakeDensityMatrixError> {
        do {
            return .success(try CircuitDensityMatrixAdapter(densityMatrix: matrix))
        } catch CircuitDensityMatrixAdapter.InitError.eigenvaluesDoesNotAddUpToOne {
            return .failure(.matrixEigenvaluesDoesNotAddUpToOne)
        } catch CircuitDensityMatrixAdapter.InitError.matrixIsNotHermitian {
            return .failure(.matrixIsNotHermitian)
        } catch CircuitDensityMatrixAdapter.InitError.negativeEigenvalues {
            return .failure(.matrixWithNegativeEigenvalues)
        } catch CircuitDensityMatrixAdapter.InitError.unableToComputeEigenvalues {
            return .failure(.unableToComputeMatrixEigenvalues)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
