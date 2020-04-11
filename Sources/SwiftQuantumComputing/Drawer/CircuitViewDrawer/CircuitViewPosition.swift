//
//  CircuitViewPosition.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 15/09/2018.
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

// MARK: - Internal types

enum CircuitViewPosition {
    case qubit(index: Int)
    case lineHorizontal
    case crossedLines
    case hadamard
    case not
    case phaseShift(radians: Double)
    case controlledNot
    case controlledNotDown
    case controlledNotUp
    case control
    case controlDown
    case controlUp
    case matrix
    case matrixUp
    case matrixDown
    case matrixTop(inputs: [Int], connected: Bool)
    case matrixBottom(connected: Bool)
    case matrixMiddleConnected
    case matrixMiddleUnconnected
    case oracleUp
    case oracleDown
    case oracleTop(controls: [Int], connected: Bool)
    case oracleBottom(connected: Bool)
} 

// MARK: - Equatable methods

extension CircuitViewPosition: Equatable {}
