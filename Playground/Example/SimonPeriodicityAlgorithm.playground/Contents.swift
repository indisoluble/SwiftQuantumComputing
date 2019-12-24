import SwiftQuantumComputing // for macOS 

let secret = "110"

let bitCount = secret.count

var gates = Gate.hadamard(targets: bitCount..<2*bitCount)
gates += Gate.oracle(truthTable: makeTruthTable(secret: secret),
                     targets: 0..<bitCount,
                     reversedControls: bitCount..<2*bitCount)
gates += Gate.hadamard(targets: bitCount..<2*bitCount)

MainDrawerFactory().makeDrawer().drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let probabilities = try! circuit.summarizedProbabilities(reversedQubits: bitCount..<2*bitCount)
print(probabilities)
