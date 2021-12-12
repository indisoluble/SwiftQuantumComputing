//
//  MainCircuitStatevectorFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/06/2020.
//  Copyright © 2020 Enrique de la Torre. All rights reserved.
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

/// Conforms `CircuitStatevectorFactory`. Use to create new `CircuitStatevector` instances
public struct MainCircuitStatevectorFactory {

    /// Initialize a `MainCircuitStatevectorFactory` instance
    public init() {}
}

// MARK: - CircuitStatevectorFactory methods

extension MainCircuitStatevectorFactory: CircuitStatevectorFactory {

    /// Check `CircuitStatevectorFactory.makeStatevector(vector:)`
    public func makeStatevector(vector: Vector) -> Result<CircuitStatevector, MakeStatevectorError> {
        do {
            return .success(try CircuitStatevectorAdapter(statevector: vector))
        } catch CircuitStatevectorAdapter.InitError.statevectorAdditionOfSquareModulusIsNotEqualToOne {
            return .failure(.vectorAdditionOfSquareModulusIsNotEqualToOne)
        } catch CircuitStatevectorAdapter.InitError.statevectorCountHasToBeAPowerOfTwo {
            return .failure(.vectorCountHasToBeAPowerOfTwo)
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}
