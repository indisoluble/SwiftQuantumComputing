//
//  String+ActivatedBits.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 08/01/2020.
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

extension String {
    var activatedBits: Set<Int> {
        return Set(reversed().enumerated().filter({ $0.element == "1" }).map({ $0.offset }))
    }

    init(activatedBits: Set<Int>, minCount: Int) {
        let actualCount = Swift.max(minCount, (activatedBits.max() ?? -1) + 1)
        let characters = (0..<actualCount).reversed().map { index -> Character in
            return (activatedBits.contains(index) ? "1" : "0")
        }

        self.init(characters)
    }
}
