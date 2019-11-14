import SwiftQuantumComputing // for iOS

let circuitFactory = MainCircuitFactory()
let drawer = MainDrawerFactory().makeDrawer()

func isFunctionConstant(truthTable: [String]) -> Bool {
    let gates = [
        FixedGate.not(target: 0),
        FixedGate.hadamard(target: 0),
        FixedGate.hadamard(target: 1),
        FixedGate.oracle(truthTable: truthTable, target: 0, controls: [1]),
        FixedGate.hadamard(target: 1)
    ]
    try! drawer.drawCircuit(gates)

    let circuit = circuitFactory.makeCircuit(gates: gates)
    let probabilities = try! circuit.summarizedProbabilities(qubits: [1])

    return (abs(1 - (probabilities["0"] ?? 0.0)) < 0.001)
}

print("Function: f(0) = 0, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: []))")
print("Function: f(0) = 1, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["0", "1"]))")
print("Function: f(0) = 1, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: ["0"]))")
print("Function: f(0) = 0, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["1"]))")

