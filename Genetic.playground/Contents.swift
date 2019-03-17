import SwiftQuantumComputing // for macOS

let conf = GeneticConfiguration(qubitCount: 2, depth: (1..<50), generationCount: 2000,
                                populationSize: (2500..<6500), tournamentSize: 7,
                                mutationProbability: 0.2, threshold: 0.48,
                                errorProbability: 0.000000000000001)
let cases = [
    GeneticUseCase(emptyTruthTableQubitCount: 1, circuitOutput: "00"),
    GeneticUseCase(truthTable: ["0", "1"], circuitOutput: "00"),
    GeneticUseCase(truthTable: ["0"], circuitOutput: "10"),
    GeneticUseCase(truthTable: ["1"], circuitOutput: "10")
]
let gates: [Gate] = [HadamardGate(), NotGate()]
let genFac = MainGeneticFactory()
guard let evol = genFac.evolveCircuit(configuration: conf, useCases: cases, gates: gates) else {
    fatalError("Unabe to evolve a circuit")
}
print("Solution found. Fitness score: \(evol.eval)")

var evolGates = evol.gates
let oracleAt = evol.oracleAt!
var target = 0
var controls: [Int] = []
switch evolGates[oracleAt] {
case let .oracle(_, t, c):
    target = t
    controls = c
default:
    fatalError("No oracle found")
}
let circFactory = MainCircuitFactory()
let bits = "00"
for useCase in cases {
    let truth = useCase.truthTable.truth
    let output = useCase.circuit.output
    evolGates[oracleAt] = FixedGate.oracle(truthTable: truth, target: target, controls: controls)

    let circ = circFactory.makeCircuit(qubitCount: conf.qubitCount, gates: evolGates)!
    let probs = circ.probabilities(afterInputting: bits)!

    print(String(format: "Use case: [%@]. Expedted output: %@. Probability: %.2f %%",
                 truth.joined(separator: ", "),
                 output,
                 probs[output]! * 100))
}
