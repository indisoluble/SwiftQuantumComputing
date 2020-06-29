import SwiftQuantumComputing // for macOS 

let secret = "1101"

let bitCount = secret.count

var gates = Gate.hadamard(targets: bitCount..<2*bitCount)
gates += Gate.oracle(truthTable: makeSimonTruthTable(secret: secret),
                     targets: 0..<bitCount,
                     controls: (bitCount..<2*bitCount).reversed())
gates += Gate.hadamard(targets: bitCount..<2*bitCount)

MainDrawerFactory().makeDrawer().drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let state = circuit.statevector().get()
let probabilities = state.summarizedProbabilities(byQubits: (bitCount..<2*bitCount).reversed()).get()

let allZeros = String(repeating: "0", count: bitCount)

var foundSecret = ""
if probabilities.count == Int(pow(2.0, Double(bitCount))) {
    foundSecret = allZeros
} else {
    let solver = MainXorGaussianEliminationSolverFactory().makeSolver()
    let solutions = solver.findActivatedVariablesInEquations(Array(probabilities.keys))

    foundSecret = solutions.filter({ $0 != allZeros }).first!
}

print("Secret: \(secret). Found secret: \(foundSecret). Success? \(secret == foundSecret)")
