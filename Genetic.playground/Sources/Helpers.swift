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

public func makeCircuit(evolvedCircuit: GeneticFactory.EvolvedCircuit,
                        useCase: GeneticUseCase) -> Circuit {
    var evolvedGates = evolvedCircuit.gates

    if let oracleAt = evolvedCircuit.oracleAt {
        switch evolvedGates[oracleAt] {
        case let .oracle(_, target, controls):
            evolvedGates[oracleAt] = FixedGate.oracle(truthTable: useCase.truthTable.truth,
                                                      target: target,
                                                      controls: controls)
        default:
            fatalError("No oracle found")
        }
    }

    return try! MainCircuitFactory().makeCircuit(qubitCount: useCase.circuit.qubitCount,
                                                 gates: evolvedGates)
}
