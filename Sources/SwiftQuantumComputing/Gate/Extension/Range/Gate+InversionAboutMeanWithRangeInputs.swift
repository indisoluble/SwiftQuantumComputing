//
//  Gate+InversionAboutMeanWithRangeInputs.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 17/02/2020.
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

extension Gate {

    // MARK: - Public class methods

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that produces an inversion about the mean on
    public static func makeInversionAboutMean(inputs: Range<Int>) throws -> Gate {
        return try makeInversionAboutMean(inputs: Array(inputs))
    }

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that produces an inversion about the mean on
    public static func makeInversionAboutMean(inputs: ClosedRange<Int>) throws -> Gate {
        return try makeInversionAboutMean(inputs: Array(inputs))
    }

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that produces an inversion about the mean on
    public static func makeInversionAboutMean(inputs: ReversedCollection<Range<Int>>) throws -> Gate {
        return try makeInversionAboutMean(inputs: Array(inputs))
    }

    /// Buils a `Gate.matrix(matrix:inputs:)` gate that produces an inversion about the mean on
    public static func makeInversionAboutMean(inputs: ReversedCollection<ClosedRange<Int>>) throws -> Gate {
        return try makeInversionAboutMean(inputs: Array(inputs))
    }
}
