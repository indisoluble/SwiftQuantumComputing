import SwiftQuantumComputing // for iOS

let circuitFactory = FullMatrixCircuitFactory()
let drawer = MainDrawerFactory().makeDrawer()

func isFunctionConstant(truthTable: [String]) -> Bool {
    var gates = [
        Gate.not(target: 0)
    ]
    gates += Gate.hadamard(targets: 0, 1)
    gates += [
        Gate.oracle(truthTable: truthTable, target: 0, controls: [1]),
        Gate.hadamard(target: 1)
    ]

    try! drawer.drawCircuit(gates)

    let circuit = circuitFactory.makeCircuit(gates: gates)
    let probabilities = try! circuit.summarizedProbabilities(byQubits: [1])

    return (abs(1 - (probabilities["0"] ?? 0.0)) < 0.001)
}

print("Function: f(0) = 0, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: []))")
print("Function: f(0) = 1, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["0", "1"]))")
print("Function: f(0) = 1, f(1) = 0. Is it constant? \(isFunctionConstant(truthTable: ["0"]))")
print("Function: f(0) = 0, f(1) = 1. Is it constant? \(isFunctionConstant(truthTable: ["1"]))")

