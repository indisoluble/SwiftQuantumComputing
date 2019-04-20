import SwiftQuantumComputing // for macOS

let config = GeneticConfiguration(depth: (1..<50),
                                  generationCount: 2000,
                                  populationSize: (2500..<6500),
                                  tournamentSize: 7,
                                  mutationProbability: 0.2,
                                  threshold: 0.48,
                                  errorProbability: 0.000000000000001)
let cases = [
    try! GeneticUseCase(emptyTruthTableQubitCount: 1, circuitOutput: "00"),
    try! GeneticUseCase(truthTable: ["0", "1"], circuitOutput: "00"),
    try! GeneticUseCase(truthTable: ["0"], circuitOutput: "10"),
    try! GeneticUseCase(truthTable: ["1"], circuitOutput: "10")
]
let gates: [Gate] = [HadamardGate(), NotGate()]
let genFac = MainGeneticFactory()
var evol: GeneticFactory.EvolvedCircuit!
do {
    evol = try genFac.evolveCircuit(configuration: config, useCases: cases, gates: gates)
} catch {
    fatalError("Unabe to evolve a circuit: \(error)")
}
print("Solution found. Fitness score: \(evol.eval)")

for useCase in cases {
    let circuit = makeCircuit(evolvedCircuit: evol, useCase: useCase)
    let probabilities = try? circuit.probabilities(afterInputting: useCase.circuit.input)
    print(String(format: "Use case: [%@]. Input: %@ -> Output: %@. Probability: %.2f %%",
                 useCase.truthTable.truth.joined(separator: ", "),
                 useCase.circuit.input,
                 useCase.circuit.output,
                 (probabilities?[useCase.circuit.output] ?? 0.0) * 100))
}

