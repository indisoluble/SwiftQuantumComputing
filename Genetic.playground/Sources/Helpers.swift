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

public func configureEvolvedGates(in evolvedCircuit: GeneticFactory.EvolvedCircuit,
                                  with useCase: GeneticUseCase) -> [FixedGate] {
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

    return evolvedGates
}

public func drawCircuit(with evolvedGates: [FixedGate], useCase: GeneticUseCase) -> SQCView {
    let drawer = MainDrawerFactory().makeDrawer()

    return try! drawer.drawCircuit(evolvedGates, qubitCount: useCase.circuit.qubitCount)
}

public func probabilities(in evolvedGates: [FixedGate],
                          useCase: GeneticUseCase) -> [String: Double] {
    let circuit = MainCircuitFactory().makeCircuit(gates: evolvedGates)

    return try! circuit.summarizedProbabilities(withInitialBits: useCase.circuit.input)
}
