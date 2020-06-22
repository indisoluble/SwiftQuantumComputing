//
//  Circuit+Statevector.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/06/2020.
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

extension Circuit {

    // MARK: - Public methods

    /**
     Applies `gates` to an initial statevector set to 0 to produce a new statevector.

     - Parameter factory: Used to produce the initial statevector set to 0.

     - Returns: Another `CircuitStatevector` instance, result of applying `gates` to 0. Or
     `StatevectorWithInitialStatevectorError` error.
     */
    public func statevector(withFactory factory: CircuitStatevectorFactory = MainCircuitStatevectorFactory()) -> Result<CircuitStatevector, StatevectorWithInitialStatevectorError> {
        let initialState = try! Vector.makeState(value: 0, qubitCount: gates.qubitCount()).get()
        let initialStatevector = try! factory.makeStatevector(vector: initialState).get()

        return statevector(withInitialStatevector: initialStatevector)
    }
}
