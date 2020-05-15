import SwiftQuantumComputing // for macOS

let secret = "110101"

var gates = [Gate.not(target: 0)]
gates += Gate.hadamard(targets: 0...secret.count)
gates += [Gate.oracle(truthTable: makeBernsteinVaziraniTruthTable(secret: secret),
                      target: 0,
                      controls: (1...secret.count).reversed())]
gates += Gate.hadamard(targets: 1...secret.count)

MainDrawerFactory().makeDrawer().drawCircuit(gates)

let circuit = FullMatrixCircuitFactory().makeCircuit(gates: gates)
let probabilities = circuit.summarizedProbabilities(byQubits: (1...secret.count).reversed())

let foundSecret = probabilities.keys.first!

print("Secret: \(secret). Found secret: \(foundSecret). Success? \(secret == foundSecret)")
