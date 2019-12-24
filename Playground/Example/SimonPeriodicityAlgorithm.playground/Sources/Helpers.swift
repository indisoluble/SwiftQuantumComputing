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

import SwiftQuantumComputing

public func makeTruthTable(secret: String) -> [Gate.ExtendedTruth] {
    let bitCount = secret.count

    let combinations = (0..<Int.pow(2, bitCount)).map { String($0, bitCount: bitCount) }
    var activations = combinations.shuffled()

    var tt: [String: String] = [:]
    for truth in combinations {
        tt[truth] = tt[String.bitXor(truth, secret)!] ?? activations.popLast()!
    }

    return tt.map { $0 }
}
