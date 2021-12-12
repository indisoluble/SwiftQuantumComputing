import SwiftQuantumComputing // for macOS

func makeBernsteinVaziraniTruthTable(secret: String) -> [String] {
    let bitCount = secret.count

    let combinations = (0..<Int.pow(2, bitCount)).map { String($0, bitCount: bitCount) }

    return combinations.filter { ($0 & secret)!.bitXor()! }
}

let secret = "11010101"

var gates = [Gate.not(target: 0)]
gates += Gate.hadamard(targets: 0...secret.count)
gates += [Gate.oracle(truthTable: makeBernsteinVaziraniTruthTable(secret: secret),
                      controls: (1...secret.count).reversed(),
                      target: 0)]
gates += Gate.hadamard(targets: 1...secret.count)

try MainDrawerFactory().makeDrawer().drawCircuit(gates).get()

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let statevector = try circuit.statevector().get()
let probabilities = try statevector.summarizedProbabilities(byQubits: (1...secret.count).reversed()).get()

let foundSecret = probabilities.keys.first!

print("Secret: \(secret). Found secret: \(foundSecret). Success? \(secret == foundSecret)")
