//
//  Array+Shuffled.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 26/08/2018.
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

extension Array {
    func shuffled() -> Array {
        var array = self

        for i in 0..<count {
            let remaining = (count - i)
            let randomIndex = Int(arc4random_uniform(UInt32(remaining)))

            let element = array[randomIndex]
            array.remove(at: randomIndex)
            array.append(element)
        }

        return array
    }
}
