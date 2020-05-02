//
//  Drawable+DrawCircuit.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/11/2019.
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

extension Drawable {

    // MARK: - Public methods

    /**
     Prints a `circuit` in a view.

     - Parameter circuit: Circuit to be printed in a view..

     - Throws: `DrawCircuitError`.

     - Returns: A view with a representation of the `circuit` inside.
     */
    public func drawCircuit(_ circuit: [Gate]) throws -> SQCView {
        let qubitCount = circuit.qubitCount()

        return try drawCircuit(circuit, qubitCount: qubitCount)
    }
}
