//
//  HadamardGate.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/08/2018.
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

public struct HadamardGate {

    // MARK: - Private properties

    private let factory: RegisterGateFactory

    // MARK: - Init methods

    public init?(qubitCount: Int) {
        let baseMatrix = Constants.baseHadamard
        guard let factory = RegisterGateFactory(qubitCount: qubitCount,
                                                baseMatrix: baseMatrix) else {
                                                return nil
        }

        self.factory = factory
    }
}

// MARK: - Gate methods

extension HadamardGate: Gate {
    public func apply(to register: Register, target: Int) throws -> Register {
        guard let gate = factory.makeGate(inputs: target) else {
            throw GateError.unableToApply
        }

        guard let nextRegister = register.applying(gate) else {
            throw GateError.unableToApply
        }

        return nextRegister
    }
}

// MARK: - Private body

private extension HadamardGate {

    // MARK: - Constants

    enum Constants {
        static let baseHadamard = (Complex(1 / sqrt(2)) * Matrix([[Complex(1), Complex(1)],
                                                                  [Complex(1), Complex(-1)]])!)
    }
}
