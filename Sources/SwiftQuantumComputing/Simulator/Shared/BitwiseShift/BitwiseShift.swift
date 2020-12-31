//
//  BitwiseShift.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 31/12/2020.
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

struct BitwiseShift {

    // MARK: - Internal properties

    let selectMask: Int
    let placesToTheRight: Int

    // MARK: - Internal init methods

    init(origin: Int, destination: Int) {
        selectMask = Int.mask(activatingBitAt: origin)
        placesToTheRight = origin - destination
    }

    // MARK: - Internal methods

    func perform(on value: Int) -> Int {
        return (value & selectMask) >> placesToTheRight
    }
}
