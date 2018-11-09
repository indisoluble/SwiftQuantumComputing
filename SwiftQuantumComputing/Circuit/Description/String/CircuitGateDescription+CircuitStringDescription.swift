//
//  CircuitGateDescription+CircuitStringDescription.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/09/2018.
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

extension CircuitGateDescription {

    // MARK: - Internal methods

    func toString() -> String {
        switch self {
        case .controlledNot(let target, let control):
            return "\(Texts.cNot) \(Texts.reg)[\(control)] \(Texts.reg)[\(target)]"
        case .hadamard(let target):
            return "\(Texts.h) \(Texts.reg)[\(target)]"
        case .not(let target):
            return "\(Texts.not) \(Texts.reg)[\(target)]"
        case .oracle(let inputs):
            return "\(Texts.oracle) \(Texts.reg)\(inputs)"
        case .phaseShift(let radians, let target):
            return "\(Texts.phase)(\(radians) \(Texts.reg)[\(target)]"
        }
    }
}

// MARK: - Private body

private extension CircuitGateDescription {

    // MARK: - Constants

    enum Texts {
        static let cNot = "cx"
        static let h = "h"
        static let not = "x"
        static let oracle = "U"
        static let phase = "r"
        static let reg = "q"
    }
}
