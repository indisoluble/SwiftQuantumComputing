import SwiftQuantumComputing // for macOS

func makeSimonTruthTable(secret: String) -> [Gate.ExtendedTruth] {
    let bitCount = secret.count

    let combinations = (0..<Int.pow(2, bitCount)).map { String($0, bitCount: bitCount) }
    var activations = combinations.shuffled()

    var tt: [String: String] = [:]
    for truth in combinations {
        tt[truth] = tt[String.bitXor(truth, secret)!] ?? activations.popLast()!
    }

    return tt.map { $0 }
}

let secret = "11010"

let bitCount = secret.count

var gates = Gate.hadamard(targets: bitCount..<2*bitCount)
gates += Gate.oracle(truthTable: makeSimonTruthTable(secret: secret),
                     controls: (bitCount..<2*bitCount).reversed(),
                     targets: 0..<bitCount)
gates += Gate.hadamard(targets: bitCount..<2*bitCount)

try MainDrawerFactory().makeDrawer().drawCircuit(gates).get()

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let state = try circuit.statevector().get()
let probabilities = try state.summarizedProbabilities(byQubits: (bitCount..<2*bitCount).reversed()).get()

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
