//
//  SpecificCircuitGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 22/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
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

struct SpecificCircuitGateFactory {

    // MARK: - Private properties

    private let qubitCount: Int

    // MARK: - Init methods

    init(qubitCount: Int) {
        self.qubitCount = qubitCount
    }
}

// MARK: - Equatable methods

extension SpecificCircuitGateFactory: Equatable {
    static func ==(lhs: SpecificCircuitGateFactory, rhs: SpecificCircuitGateFactory) -> Bool {
        return (lhs.qubitCount == rhs.qubitCount)
    }
}

// MARK: - CircuitGateFactory methods

extension SpecificCircuitGateFactory: CircuitGateFactory {
    public func makeGate(matrix: Matrix, inputs: [Int]) -> RegisterGate? {
        guard let factory = RegisterGateFactory(qubitCount: qubitCount, baseMatrix: matrix) else {
            return nil
        }

        return factory.makeGate(inputs: inputs)
    }
}
