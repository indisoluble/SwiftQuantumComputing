//
//  String+BitXor.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 24/12/2019.
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

extension String {
    /// Returns the result of combining the bits in the bit string using XOR
    public func bitXor() -> Bool? {
        let result = reduce("0") { (acc, ch) -> String? in
            return (acc == nil ? nil : String.bitXor(acc!, String(ch)))
        }

        return (result == nil ? nil : result == "1")
    }

    /// Applies XOR to two bit strings
    public static func bitXor(_ inputA: String, _ inputB: String) -> String? {
        guard let a = Int(inputA, radix: 2), let b = Int(inputB, radix: 2) else {
            return nil
        }

        return String(a ^ b, bitCount: Swift.max(inputA.count, inputB.count))
    }
}
