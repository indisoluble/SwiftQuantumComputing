//
//  String+Bits.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 10/11/2018.
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

extension String {
    init(_ value: Int, bitCount: Int) {
        let bits = Array((0..<bitCount).reversed())

        self.init(value, bits: bits)
    }

    init(_ value: Int, bits: [Int]) {
        let binary = String(value, radix: 2).reversed()
        let characters = bits.map { (index) -> Character in
            guard (index < binary.count) else {
                return "0"
            }

            return binary[binary.index(binary.startIndex, offsetBy: index)]
        }

        self.init(characters)
    }
}
